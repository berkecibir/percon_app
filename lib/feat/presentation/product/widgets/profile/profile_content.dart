import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/device_padding/device_padding.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/feat/data/model/auth/user_model.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/locale/locale_cubit.dart';
import 'package:percon_app/feat/presentation/product/widgets/custom_button.dart';
import 'package:percon_app/feat/presentation/product/widgets/profile/profile_header.dart';
import 'package:percon_app/feat/presentation/product/widgets/profile/user_info_card.dart';

class ProfileContent extends StatelessWidget {
  final UserModel user;

  const ProfileContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: DevicePadding.medium.all,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          ProfileHeader(user: user),
          DeviceSpacing.medium.height,

          // User Info Cards
          UserInfoCard(
            title: AppTexts.nameSurnameDe.tr(),
            content: user.fullName,
            icon: Icons.person,
          ),
          DeviceSpacing.small.height,

          UserInfoCard(
            title: AppTexts.emailDe.tr(),
            content: user.email,
            icon: Icons.email,
          ),
          DeviceSpacing.small.height,

          UserInfoCard(
            title: AppTexts.memberShipDe.tr(),
            content: _formatDate(user.createdAt),
            icon: Icons.calendar_today,
          ),
          DeviceSpacing.small.height,

          UserInfoCard(
            title: AppTexts.lastLoginDe.tr(),
            content: _formatDate(user.lastLogin),
            icon: Icons.access_time,
          ),
          DeviceSpacing.small.height,

          // Language Selection Buttons
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.setLocale(const Locale('en'));
                    context.read<LocaleCubit>().setLocale(const Locale('en'));
                  },
                  child: Text('English'.tr()),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.setLocale(const Locale('tr'));
                    context.read<LocaleCubit>().setLocale(const Locale('tr'));
                  },
                  child: Text('Türkçe'.tr()),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.setLocale(const Locale('de'));
                    context.read<LocaleCubit>().setLocale(const Locale('de'));
                  },
                  child: Text('Deutsch'.tr()),
                ),
              ],
            ),
          ),
          DeviceSpacing.small.height,

          Center(
            child: CustomButton(
              onTap: () {
                context.read<AuthCubit>().signOut();
              },
              child: Text(
                AppTexts.logOutDe.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return AppTexts.unknowdDe.tr();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
