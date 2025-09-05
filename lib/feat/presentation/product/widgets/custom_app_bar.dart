import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/utils/enum/view_mode_enum.dart';
import 'package:percon_app/core/widgets/navigation/navigation_helper.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';
import 'package:easy_localization/easy_localization.dart';

// Enum to identify the type of AppBar
enum AppBarType { home, profile, favorite }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final AppBarType? type;

  const CustomAppBar({super.key, required this.title, this.actions, this.type});

  // Factory method for home
  factory CustomAppBar.home() {
    return const CustomAppBar._(type: AppBarType.home);
  }

  const CustomAppBar._({this.type}) : title = '', actions = const [];

  // Factory method for profile
  factory CustomAppBar.profile() {
    return const CustomAppBar._(type: AppBarType.profile);
  }

  // Factory method for favorite
  factory CustomAppBar.favorite() {
    return const CustomAppBar._(type: AppBarType.favorite);
  }

  @override
  Widget build(BuildContext context) {
    // Use a Builder to ensure the widget rebuilds when locale changes
    return Builder(
      builder: (context) {
        // Determine the title and actions based on the type
        String resolvedTitle;
        List<Widget>? resolvedActions = actions;

        if (type == AppBarType.home) {
          resolvedTitle = AppTexts.homeAppbarTitle.tr();
          resolvedActions = [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigation.pushNamed(root: AppTexts.favoritePageId);
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigation.pushNamed(root: AppTexts.profilePageId);
              },
            ),
            BlocBuilder<TravelCubit, TravelState>(
              builder: (context, state) {
                final travelCubit = context.read<TravelCubit>();
                return IconButton(
                  icon: Icon(
                    travelCubit.viewMode == ViewMode.grid
                        ? Icons.list
                        : Icons.grid_view,
                  ),
                  onPressed: travelCubit.toggleViewMode,
                );
              },
            ),
          ];
        } else if (type == AppBarType.profile) {
          resolvedTitle = AppTexts.profilePageAppBarTitle.tr();
          resolvedActions = null;
        } else if (type == AppBarType.favorite) {
          resolvedTitle = AppTexts.favoriteAppBarTitle.tr();
          resolvedActions = null;
        } else {
          resolvedTitle = title;
        }

        return AppBar(title: Text(resolvedTitle), actions: resolvedActions);
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
