import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/feat/presentation/cubit/profile/profile_cubit.dart';

class ErrorWidget extends StatelessWidget {
  final String error;
  const ErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${AppTexts.errorDe} : $error'),
        DeviceSpacing.small.height,
        ElevatedButton(
          onPressed: () {
            final userId = context.read<ProfileCubit>().state.user?.uid;
            if (userId != null) {
              context.read<ProfileCubit>().loadUserProfile(userId);
            }
          },
          child: Text(AppTexts.tryAgainDe),
        ),
      ],
    );
  }
}
