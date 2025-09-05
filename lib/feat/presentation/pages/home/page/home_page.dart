import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/config/theme/app_colors.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/utils/enum/view_mode_enum.dart';
import 'package:percon_app/core/widgets/device_padding/device_padding.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';
import 'package:percon_app/feat/presentation/pages/home/mixin/home_page_mixin.dart';
import 'package:percon_app/feat/presentation/product/widgets/custom_app_bar.dart';
import 'package:percon_app/feat/presentation/product/widgets/home/filter_section.dart';
import 'package:percon_app/feat/presentation/product/widgets/home/travel_card.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  static const String id = AppTexts.homePageId;
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomePageMixin {
  @override
  Widget build(BuildContext context) {
    // Listen to locale changes and rebuild the entire page
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
            body: OrientationBuilder(
              builder: (context, orientation) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      FilterSection(travelCubit: travelCubit),
                      _buildTravelList(travelCubit, state, orientation),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTravelList(
    TravelCubit travelCubit,
    TravelState state,
    Orientation orientation,
  ) {
    if (state is TravelLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is TravelLoaded) {
      if (state.travels.isEmpty) {
        return Center(child: Text(AppTexts.noTravelsFoundDe.tr()));
      }

      // Landscape modunda iki sütunlu bir liste göster
      final crossAxisCount = orientation == Orientation.landscape ? 3 : 2;
      final childAspectRatio = orientation == Orientation.landscape ? 0.7 : 0.8;

      return travelCubit.viewMode == ViewMode.grid
          ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
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
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
          padding: DevicePadding.medium.all,
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
