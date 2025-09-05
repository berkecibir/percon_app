import 'package:flutter/material.dart';
import 'package:percon_app/core/sizes/app_sizes.dart';
import 'package:percon_app/feat/data/model/auth/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: AppSizes.xxLarge,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          user.fullName.isNotEmpty ? user.fullName[0] : 'U',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
