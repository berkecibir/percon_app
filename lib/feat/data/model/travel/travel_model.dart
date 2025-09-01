import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';

class TravelModel extends Equatable {
  final String id;
  final String title;
  final String country;
  final String region;
  final DateTime startDate;
  final DateTime endDate;
  final String category;
  final String description;
  final bool isFavorite;

  const TravelModel({
    required this.id,
    required this.title,
    required this.country,
    required this.region,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.description,
    required this.isFavorite,
  });

  factory TravelModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String dateStr) {
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        debugPrint(e.toString());
        return DateTime.now();
      }
    }

    return TravelModel(
      id: json[AppTexts.id],
      title: json[AppTexts.title],
      country: json[AppTexts.country],
      region: json[AppTexts.region],
      startDate: parseDate(json[AppTexts.startDate]),
      endDate: parseDate(json[AppTexts.endDate]),
      category: json[AppTexts.category],
      description: json[AppTexts.description],
      isFavorite: json[AppTexts.isFavorite],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppTexts.id: id,
      AppTexts.title: title,
      AppTexts.country: country,
      AppTexts.region: region,
      AppTexts.startDate: startDate.toIso8601String(),
      AppTexts.endDate: endDate.toIso8601String(),
      AppTexts.category: category,
      AppTexts.description: description,
      AppTexts.isFavorite: isFavorite,
    };
  }

  TravelModel copyWith({
    String? id,
    String? title,
    String? country,
    String? region,
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    String? description,
    bool? isFavorite,
  }) {
    return TravelModel(
      id: id ?? this.id,
      title: title ?? this.title,
      country: country ?? this.country,
      region: region ?? this.region,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      category: category ?? this.category,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    country,
    region,
    startDate,
    endDate,
    category,
    description,
    isFavorite,
  ];
}
