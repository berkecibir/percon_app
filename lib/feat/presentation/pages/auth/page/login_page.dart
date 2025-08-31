import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/sizes/app_sizes.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/device_padding/device_padding.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/core/widgets/navigation/navigation_helper.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_state.dart';
import 'package:percon_app/feat/presentation/pages/auth/page/login_body_page.dart';
import 'package:percon_app/feat/presentation/pages/home/page/home_page.dart';

class LoginPage extends StatelessWidget {
  static const String id = AppTexts.loginPageId;
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: _buildListener,
        child: const LoginBodyPage(),
      ),
    );
  }

  void _buildListener(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      // Başarılı giriş sonrası HomePage'e yönlendir
      Navigation.pushReplacementNamed(root: HomePage.id);
    } else if (state is AuthError) {
      // Hata durumunda BottomSheet göster
      _showErrorBottomSheet(context, state.message);
    }
  }

  void _showErrorBottomSheet(BuildContext context, String message) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.red,
          padding: DevicePadding.medium.all,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: AppSizes.xxLarge,
              ),
              DeviceSpacing.small.height,
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppSizes.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
