import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:percon_app/core/widgets/device_size/device_size.dart';
import 'package:percon_app/firebase_options.dart';

class AppInit {
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await dotenv.load(fileName: "assets/.env");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static void initDeviceSize(BuildContext context) {
    DeviceSize.init(context);
  }
}
