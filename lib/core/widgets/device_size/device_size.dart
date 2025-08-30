import 'package:flutter/material.dart';

final class DeviceSize {
  static MediaQueryData? _data;
  static double? width;
  static double? height;

  /// Initialize the device size
  static void init(BuildContext context) {
    _data = MediaQuery.of(context);
    width = _data?.size.width;
    height = _data?.size.height;
  }

  /// width calculate by percentage
  static double calculateWidth(double percentage) {
    return (width ?? 0) * (percentage / 100);
  }

  /// height calculate by percentage
  static double calculateHeight(double percentage) {
    return (height ?? 0) * (percentage / 100);
  }
}
