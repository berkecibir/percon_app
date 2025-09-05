import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';
import 'package:easy_localization/easy_localization.dart';

class CountryRegionDropDowns extends StatelessWidget {
  final TravelCubit travelCubit;
  final Map<String, List<String>> countryRegions;

  const CountryRegionDropDowns({
    super.key,
    required this.travelCubit,
    required this.countryRegions,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelCubit, TravelState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: travelCubit.currentCountry,
                hint: Text(AppTexts.countryDe.tr()),
                items: countryRegions.keys.map((String countryKey) {
                  return DropdownMenuItem(
                    value: countryKey,
                    child: Text(countryKey.tr()),
                  );
                }).toList(),
                onChanged: (value) =>
                    travelCubit.onCountryChanged(value, countryRegions),
              ),
            ),
            DeviceSpacing.small.width,
            Expanded(
              child: DropdownButtonFormField<String>(
                value: travelCubit.currentRegion,
                hint: Text(AppTexts.regionDe.tr()),
                items: travelCubit.currentCountry != null
                    ? (countryRegions[travelCubit.currentCountry!] ?? []).map((
                        String regionKey,
                      ) {
                        return DropdownMenuItem(
                          value: regionKey,
                          child: Text(regionKey.tr()),
                        );
                      }).toList()
                    : [],
                onChanged: travelCubit.currentCountry != null
                    ? (value) => travelCubit.onRegionChanged(value)
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
