import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';
import 'package:easy_localization/easy_localization.dart';

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
                hint: Text(AppTexts.categoryDe.tr()),
                items: [
                  DropdownMenuItem(
                    value: AppTexts.cultureDe.tr(),
                    child: Text(AppTexts.cultureDe.tr()),
                  ),
                  DropdownMenuItem(
                    value: AppTexts.festivalDe.tr(),
                    child: Text(AppTexts.festivalDe.tr()),
                  ),
                  DropdownMenuItem(
                    value: AppTexts.adventureDe.tr(),
                    child: Text(AppTexts.adventureDe.tr()),
                  ),
                ],
                onChanged: (value) => travelCubit.onCategoryChanged(value),
              ),
            ),
            DeviceSpacing.small.width,
            ElevatedButton(
              onPressed: travelCubit.clearAllFilters,
              child: Text(AppTexts.clearFiltersDe.tr()),
            ),
          ],
        );
      },
    );
  }
}
