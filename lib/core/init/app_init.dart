import 'package:flutter/material.dart';
import 'package:percon_app/core/widgets/device_size/device_size.dart';

class AppInit {
  // Private constructor to prevent instantiation
  AppInit._();

  /// Initialize device size
  static void initDeviceSize(BuildContext context) {
    DeviceSize.init(context);
  }
}
