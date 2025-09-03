import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/config/theme/app_colors.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/utils/enum/view_mode_enum.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';
import 'package:percon_app/feat/presentation/product/widgets/custom_app_bar.dart';
import 'package:percon_app/feat/presentation/product/widgets/home/filter_section.dart';
import 'package:percon_app/feat/presentation/product/widgets/home/travel_card.dart';

class HomePage extends StatelessWidget {
  static const String id = AppTexts.homePageId;
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TravelCubit, TravelState>(
      listener: (context, state) {
        // Error durumunda BottomSheet göster
        if (state is TravelError) {
          _showErrorBottomSheet(context, state.message);
        }
      },
      builder: (context, state) {
        final travelCubit = context.read<TravelCubit>();

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: CustomAppBar.home(),
            body: Column(
              children: [
                FilterSection(travelCubit: travelCubit),
                Expanded(child: _buildTravelList(travelCubit, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTravelList(TravelCubit travelCubit, TravelState state) {
    if (state is TravelLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is TravelLoaded) {
      if (state.travels.isEmpty) {
        return const Center(child: Text(AppTexts.noTravelsFoundDe));
      }

      return travelCubit.viewMode == ViewMode.grid
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: state.travels.length,
              itemBuilder: (context, index) {
                return TravelCard(
                  travel: state.travels[index],
                  onToggleFavorite: travelCubit.toggleFavorite,
                );
              },
            )
          : ListView.builder(
              itemCount: state.travels.length,
              itemBuilder: (context, index) {
                return TravelCard(
                  travel: state.travels[index],
                  onToggleFavorite: travelCubit.toggleFavorite,
                );
              },
            );
    }

    return const SizedBox.shrink();
  }

  void _showErrorBottomSheet(BuildContext context, String message) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.red,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.primary,
                size: 48,
              ),
              DeviceSpacing.small.height,
              Text(
                message,
                style: const TextStyle(color: AppColors.primary, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
