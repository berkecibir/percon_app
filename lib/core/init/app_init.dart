import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:percon_app/core/widgets/device_size/device_size.dart';
import 'package:percon_app/firebase_options.dart';

class AppInit {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static void initDeviceSize(BuildContext context) {
    DeviceSize.init(context);
  }
}
