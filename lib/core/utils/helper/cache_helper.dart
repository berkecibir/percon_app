import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percon_app/feat/data/model/travel/travel_model.dart';

class CacheHelper {
  static const String _favoriteTravelIdsKey = 'favorite_travel_ids';
  static const String _favoriteTravelsKey = 'favorite_travels';

  // Favorite travel ID'lerini kaydet (Basit ve etkili yöntem)
  static Future<void> saveFavoriteTravelIds(List<String> favoriteIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoriteTravelIdsKey, favoriteIds);
    } catch (e) {
      throw Exception('Failed to save favorite travel IDs: $e');
    }
  }

  // Favorite travel ID'lerini al
  static Future<List<String>> getFavoriteTravelIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_favoriteTravelIdsKey) ?? [];
    } catch (e) {
      throw Exception('Failed to get favorite travel IDs: $e');
    }
  }

  // Tam travel modellerini kaydet (Eski metod - backward compatibility için)
  static Future<void> saveFavoriteTravels(
    List<TravelModel> favoriteTravels,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = favoriteTravels
          .map((travel) => travel.toJson())
          .toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString(_favoriteTravelsKey, jsonString);
    } catch (e) {
      throw Exception('Failed to save favorite travels: $e');
    }
  }

  // Tam travel modellerini al (Eski metod - backward compatibility için)
  static Future<List<TravelModel>> getFavoriteTravels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_favoriteTravelsKey);

      if (jsonString == null) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => TravelModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get favorite travels: $e');
    }
  }

  // Tüm cache'i temizle
  static Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoriteTravelIdsKey);
      await prefs.remove(_favoriteTravelsKey);
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }

  // Belirli bir anahtarı temizle
  static Future<void> clearKey(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      throw Exception('Failed to clear key $key: $e');
    }
  }

  // Cache boyutunu kontrol et (Debug amaçlı)
  static Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList(_favoriteTravelIdsKey) ?? [];
      final favoriteTravelsString = prefs.getString(_favoriteTravelsKey);

      return {
        'favorite_ids_count': favoriteIds.length,
        'favorite_ids': favoriteIds,
        'has_legacy_data': favoriteTravelsString != null,
        'legacy_data_size': favoriteTravelsString?.length ?? 0,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Migration: Eski veri formatından yenisine geçiş
  static Future<void> migrateFavoriteData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Yeni format zaten varsa migration'a gerek yok
      final existingIds = prefs.getStringList(_favoriteTravelIdsKey);
      if (existingIds != null && existingIds.isNotEmpty) {
        return;
      }

      // Eski formatı kontrol et
      final oldDataString = prefs.getString(_favoriteTravelsKey);
      if (oldDataString != null) {
        final List<dynamic> jsonList = jsonDecode(oldDataString);
        final favoriteIds = jsonList
            .map((json) => json['id'] as String?)
            .where((id) => id != null)
            .cast<String>()
            .toList();

        // Yeni formata kaydet
        await saveFavoriteTravelIds(favoriteIds);

        // Eski veriyi temizle (isteğe bağlı)
        // await prefs.remove(_favoriteTravelsKey);

        debugPrint('Migrated ${favoriteIds.length} favorites to new format');
      }
    } catch (e) {
      debugPrint('Migration failed: $e');
    }
  }
}
