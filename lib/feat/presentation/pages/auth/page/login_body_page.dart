import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/device_padding/device_padding.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_state.dart';
import 'package:percon_app/feat/presentation/product/widgets/custom_button.dart';

class LoginBodyPage extends StatelessWidget {
  const LoginBodyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: DevicePadding.xlarge.allSymtetric,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Text
                Text(
                  textAlign: TextAlign.center,
                  AppTexts.welcomeText,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DeviceSpacing.xlarge.height,
                // Google Login Button or Loading
                _buildLoginButton(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthState state) {
    if (state is AuthLoading) {
      return Column(
        children: [
          const CircularProgressIndicator(),
          DeviceSpacing.medium.height,
          Text(
            AppTexts.logginInText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }

    return CustomButton.googleSignIn(
      onTap: () {
        context.read<AuthCubit>().signInWithGoogle();
      },
    );
  }
}
