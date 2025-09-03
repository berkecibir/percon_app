import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/utils/enum/view_mode_enum.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, required this.title, this.actions});

  // Factory method for home
  factory CustomAppBar.home() {
    return CustomAppBar(
      title: AppTexts.homeAppbarTitle,
      actions: [
        IconButton(icon: const Icon(Icons.favorite), onPressed: () {}),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title), actions: actions);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
