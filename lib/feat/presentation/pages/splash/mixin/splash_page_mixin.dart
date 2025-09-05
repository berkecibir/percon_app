import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/duration/app_duration.dart';
import 'package:percon_app/core/widgets/navigation/navigation_helper.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_state.dart';
import 'package:percon_app/feat/presentation/pages/auth/page/login_page.dart';
import 'package:percon_app/feat/presentation/pages/home/page/home_page.dart';
import 'package:percon_app/feat/presentation/pages/splash/page/splash_page.dart';

mixin SplashPageMixin on State<SplashPage> {
  Duration splashDurationValue() => AppDuration.twoSecond;
  @override
  void initState() {
    super.initState();
    redirect();
  }

  Future<void> redirect() async {
    await Future.delayed(splashDurationValue());
    if (mounted) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        Navigation.pushReplace(page: const HomePage());
      } else {
        Navigation.pushReplace(page: const LoginPage());
      }
    }
  }
}
