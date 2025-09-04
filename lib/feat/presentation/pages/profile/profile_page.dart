import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/feat/data/repository/auth/i_user_repositiory.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_state.dart';
import 'package:percon_app/feat/presentation/cubit/profile/profile_cubit.dart';
import 'package:percon_app/feat/presentation/pages/profile/profile_view.dart';

class ProfilePage extends StatelessWidget {
  static const String id = AppTexts.profilePageId;
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final userRepository = context.read<UserRepositiory>();
        final profileCubit = ProfileCubit(userRepository: userRepository);

        // Get current user ID from AuthCubit
        final authState = context.read<AuthCubit>().state;
        if (authState is AuthAuthenticated) {
          profileCubit.loadUserProfile(authState.user.uid);
        }

        return profileCubit;
      },
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.read<ProfileCubit>().loadUserProfile(state.user.uid);
          }
        },
        child: const ProfileView(),
      ),
    );
  }
}
