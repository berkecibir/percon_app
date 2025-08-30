import 'package:flutter/material.dart';
import 'package:percon_app/core/sizes/app_sizes.dart';

class AppBorderRadius extends BorderRadius {
  AppBorderRadius.all(double radius) : super.all(Radius.circular(radius));

  // Global border radius class
  AppBorderRadius.only({
    double topLeft = AppSizes.zero,
    double topRight = AppSizes.zero,
    double bottomLeft = AppSizes.zero,
    double bottomRight = AppSizes.zero,
  }) : super.only(
         topLeft: Radius.circular(topLeft),
         topRight: Radius.circular(topRight),
         bottomLeft: Radius.circular(bottomLeft),
         bottomRight: Radius.circular(bottomRight),
       );

  // Border radius for horizontal and vertical
  AppBorderRadius.horizontal(double radius)
    : super.horizontal(
        left: Radius.circular(radius),
        right: Radius.circular(radius),
      );

  AppBorderRadius.vertical(double radius)
    : super.vertical(
        top: Radius.circular(radius),
        bottom: Radius.circular(radius),
      );
  // Symmetric border radius
  static AppBorderRadius symmetric({
    double vertical = AppSizes.zero,
    double horizontal = AppSizes.zero,
  }) => AppBorderRadius.only(
    topLeft: horizontal,
    topRight: horizontal,
    bottomLeft: horizontal,
    bottomRight: horizontal,
  );
  // Circular border radius
  static AppBorderRadius circular(double radius) => AppBorderRadius.all(radius);
}
