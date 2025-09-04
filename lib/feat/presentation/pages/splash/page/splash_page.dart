import 'package:flutter/material.dart';
import 'package:percon_app/core/config/asset/app_images.dart';
import 'package:percon_app/core/duration/app_duration.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/navigation/navigation_helper.dart';
import 'package:percon_app/feat/presentation/pages/auth/page/login_page.dart';

class SplashPage extends StatefulWidget {
  static const String id = AppTexts.splashPageId;
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Duration splashDurationValue() => AppDuration.twoSecond;

  Future<void> redirect() async {
    await Future.delayed(splashDurationValue());
    Navigation.pushReplace(page: const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AppImages.logo, fit: BoxFit.contain, scale: 2.5),
      ),
    );
  }
}
