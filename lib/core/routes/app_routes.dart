import 'package:flutter/material.dart';
import 'package:percon_app/feat/presentation/pages/auth/page/login_page.dart';
import 'package:percon_app/feat/presentation/pages/favorite/favorite_page.dart';
import 'package:percon_app/feat/presentation/pages/home/page/home_page.dart';
import 'package:percon_app/feat/presentation/pages/profile/profile_page.dart';

class AppRoutes {
  // App routes will be added here

  static Map<String, WidgetBuilder> routes = {
    // Login Page
    LoginPage.id: (context) => const LoginPage(),
    // Home Page
    HomePage.id: (context) => const HomePage(),
    // Favorite Page
    FavoritePage.id: (context) => const FavoritePage(),
    // Profile Page
    ProfilePage.id: (context) => const ProfilePage(),
  };
}
