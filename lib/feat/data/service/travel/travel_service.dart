import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/feat/data/model/travel/travel_model.dart';
import 'package:percon_app/feat/data/service/travel/i_travel_service.dart';

class TravelService implements ITravelService {
  List<TravelModel>? _cachedTravels;
  final Set<String> _favoriteTravels = {};

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

  @override
  Future<void> toggleFavorite(String travelId) async {
    if (_favoriteTravels.contains(travelId)) {
      _favoriteTravels.remove(travelId);
    } else {
      _favoriteTravels.add(travelId);
    }
  }

  @override
  Future<List<TravelModel>> getFavoriteTravels() async {
    if (_cachedTravels == null) {
      await loadTravels();
    }
    return [];
  }
}
