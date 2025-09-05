import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/device_padding/device_padding.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_state.dart';
import 'package:percon_app/feat/presentation/product/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginPage extends StatelessWidget {
  static const String id = AppTexts.loginPageId;
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            // Show error message
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Padding(
              padding: DevicePadding.large.all,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo or Name
                  Text(
                    AppTexts.appName.tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppTexts.welcomeText.tr(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 40),
                  // Google Sign In Button
                  CustomButton.googleSignIn(
                    onTap: () {
                      context.read<AuthCubit>().signInWithGoogle();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
