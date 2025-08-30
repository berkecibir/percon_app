import 'package:flutter/material.dart';
import 'package:percon_app/core/sizes/app_sizes.dart';

final class SpacingType {
  // Private constructor to prevent instantiation
  SpacingType._();
}

/// Project's global spacing class
enum DeviceSpacing {
  /// This value 5
  xsmall(AppSizes.xSmall),

  /// This value 10
  small(AppSizes.small),

  ///  This value 15
  medium(AppSizes.medium),

  /// This value 20
  large(AppSizes.large),

  /// This value 30
  xlarge(AppSizes.xxLarge);

  final double value;
  const DeviceSpacing(this.value);

  ///  SizedBox for only width
  SizedBox get width => SizedBox(width: value);

  ///  SizedBox for only height
  SizedBox get height => SizedBox(height: value);

  /// SizedBox for height and width
  SizedBox get square => SizedBox(width: value, height: value);
}
