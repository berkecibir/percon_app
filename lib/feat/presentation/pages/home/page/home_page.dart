import 'package:flutter/material.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';

class HomePage extends StatefulWidget {
  static const String id = AppTexts.homePageId;
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Home Page')));
  }
}
