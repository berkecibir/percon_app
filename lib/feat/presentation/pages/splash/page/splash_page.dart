import 'package:flutter/material.dart';
import 'package:percon_app/core/config/asset/app_images.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/feat/presentation/pages/splash/mixin/splash_page_mixin.dart';

class SplashPage extends StatefulWidget {
  static const String id = AppTexts.splashPageId;
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SplashPageMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AppImages.logo, fit: BoxFit.contain, scale: 2.5),
      ),
    );
  }
}
