import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/feat/presentation/cubit/locale/locale_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/profile/profile_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/profile/profile_state.dart';
import 'package:percon_app/feat/presentation/product/widgets/profile/profile_content.dart';
import 'package:percon_app/feat/presentation/product/widgets/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocaleCubit, Locale>(
      listener: (context, locale) {
        // Rebuild the widget when locale changes
      },
      builder: (context, localeState) {
        return Scaffold(
          appBar: CustomAppBar.profile(),
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              //  isLoading kontrolü
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Sonra error kontrolü
              if (state.error != null) {
                return ErrorWidget(state.error!);
              }

              // En son user null mı kontrolü
              if (state.user == null) {
                return Center(
                  child: Text(
                    AppTexts.userNotFoundDe.tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }

              // Her şey yolundaysa profil içeriğini gösterir
              return ProfileContent(user: state.user!);
            },
          ),
        );
      },
    );
  }
}
