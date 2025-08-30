import 'package:flutter/material.dart';
import 'package:percon_app/core/init/app_init.dart';
import 'package:percon_app/core/widgets/navigation/navigation_helper.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize device size
    AppInit.initDeviceSize(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Percon Travel App',
      navigatorKey: Navigation.navigationKey,
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
