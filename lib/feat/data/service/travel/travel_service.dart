import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/utils/helper/cache_helper.dart';
import 'package:percon_app/feat/data/model/travel/travel_model.dart';
import 'package:percon_app/feat/data/service/travel/i_travel_service.dart';

class TravelService implements ITravelService {
  List<TravelModel>? _cachedTravels;
  // Only manage user favorites, ignore default favorites from JSON
  Set<String> _userFavoriteIds = <String>{};
  bool _favoritesLoaded = false;

  String get jsonPath => AppTexts.jsonPath;

  @override
  Future<List<TravelModel>> loadTravels({
    int offSet = 0,
    int limit = 20,
  }) async {
    try {
      if (_cachedTravels == null) {
        final String response = await rootBundle.loadString(jsonPath);
        final List<dynamic> data = jsonDecode(response);
        _cachedTravels = data
            .map((json) => TravelModel.fromJson(json))
            .toList();
      }
      int end = (offSet + limit < _cachedTravels!.length)
          ? offSet + limit
          : _cachedTravels!.length;
      return _cachedTravels!.sublist(offSet, end);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<int> getTotalCount() async {
    if (_cachedTravels == null) {
      await loadTravels();
    }
    return _cachedTravels?.length ?? 0;
  }

  // Load user favorites from cache
  Future<void> _loadUserFavorites() async {
    if (_favoritesLoaded) return;
    try {
      final ids = await CacheHelper.getFavoriteTravelIds();
      _userFavoriteIds = ids.toSet();
      _favoritesLoaded = true;
      debugPrint('Loaded ${_userFavoriteIds.length} user favorites from cache');
    } catch (e) {
      debugPrint('Error loading user favorite travel IDs: $e');
    }
  }

  @override
  Future<void> toggleFavorite(String travelId) async {
    await _loadUserFavorites(); // Make sure favorites are loaded

    if (_userFavoriteIds.contains(travelId)) {
      _userFavoriteIds.remove(travelId);
      debugPrint('Removed travel $travelId from favorites');
    } else {
      _userFavoriteIds.add(travelId);
      debugPrint('Added travel $travelId to favorites');
    }

    // Save the updated list to SharedPreferences
    await CacheHelper.saveFavoriteTravelIds(_userFavoriteIds.toList());
    debugPrint('Saved ${_userFavoriteIds.length} favorites to cache');
  }

  @override
  Future<bool> isFavorite(String travelId) async {
    await _loadUserFavorites(); // Make sure favorites are loaded

    // Check if it's a user favorite
    if (_userFavoriteIds.contains(travelId)) {
      return true;
    }

    // Check if it's a default favorite from JSON
    if (_cachedTravels == null) {
      await loadTravels();
    }

    if (_cachedTravels != null) {
      try {
        final travel = _cachedTravels!.firstWhere((t) => t.id == travelId);
        return travel.isFavorite;
      } catch (e) {
        // Travel not found
        return false;
      }
    }

    return false;
  }

  @override
  Future<List<TravelModel>> getFavoriteTravels() async {
    await _loadUserFavorites(); // Make sure favorites are loaded

    // Load travels if not already loaded
    if (_cachedTravels == null) {
      await loadTravels();
    }

    // Return all travels that are either user favorites or default favorites
    final List<TravelModel> allFavorites = [];
    if (_cachedTravels != null) {
      for (var travel in _cachedTravels!) {
        // Check if it's a user favorite or default favorite
        if (_userFavoriteIds.contains(travel.id) || travel.isFavorite) {
          allFavorites.add(travel);
        }
      }
    }

    debugPrint(
      'Returning ${allFavorites.length} total favorite travels (${_userFavoriteIds.length} user favorites + default favorites)',
    );
    return allFavorites;
  }
}
