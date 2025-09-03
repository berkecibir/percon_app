import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';

class CategoryAndClearFilters extends StatelessWidget {
  final TravelCubit travelCubit;

  const CategoryAndClearFilters({super.key, required this.travelCubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelCubit, TravelState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: travelCubit.currentCategory,
                hint: const Text(AppTexts.categoryDe),
                items: const [
                  DropdownMenuItem(
                    value: AppTexts.cultureDe,
                    child: Text(AppTexts.cultureDe),
                  ),
                  DropdownMenuItem(
                    value: AppTexts.festivalDe,
                    child: Text(AppTexts.festivalDe),
                  ),
                  DropdownMenuItem(
                    value: AppTexts.adventureDe,
                    child: Text(AppTexts.adventureDe),
                  ),
                ],
                onChanged: (value) => travelCubit.onCategoryChanged(value),
              ),
            ),
            DeviceSpacing.small.width,
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: travelCubit.clearAllFilters,
            ),
          ],
        );
      },
    );
  }
}
