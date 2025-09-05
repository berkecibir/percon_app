import 'package:flutter/material.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/device_padding/device_padding.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/product/widgets/home/category_and_clear_filters.dart';
import 'package:percon_app/feat/presentation/product/widgets/home/country_region_drop_downs.dart';
import 'package:percon_app/feat/presentation/product/widgets/home/date_pickers.dart';
import 'package:percon_app/feat/presentation/product/widgets/home/search_field.dart';
import 'package:easy_localization/easy_localization.dart';

class FilterSection extends StatelessWidget {
  final TravelCubit travelCubit;

  const FilterSection({super.key, required this.travelCubit});

  @override
  Widget build(BuildContext context) {
    // Ülke-bölge eşleme tablosu with localization keys
    final Map<String, List<String>> countryRegions = {
      AppTexts.germany: [
        AppTexts.berlin,
        AppTexts.hamburg,
        AppTexts.bavaria,
        AppTexts.saxony,
        AppTexts.hesse,
      ],
      AppTexts.austria: [
        AppTexts.vienna,
        AppTexts.tyrol,
        AppTexts.salzburg,
        AppTexts.styria,
        AppTexts.vorarlberg,
      ],
      AppTexts.switzerland: [
        AppTexts.zurich,
        AppTexts.geneva,
        AppTexts.bern,
        AppTexts.lucerne,
        AppTexts.valais,
      ],
    };

    return Padding(
      padding: DevicePadding.small.all,
      child: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  SearchField(travelCubit: travelCubit),
                  DeviceSpacing.small.height,
                  CountryRegionDropDowns(
                    travelCubit: travelCubit,
                    countryRegions: countryRegions,
                  ),
                  DeviceSpacing.small.height,
                  CategoryAndClearFilters(travelCubit: travelCubit),
                  DeviceSpacing.small.height,
                  DatePickers(travelCubit: travelCubit),
                ],
              ),
            );
          } else {
            // Portrait mod
            return Column(
              children: [
                SearchField(travelCubit: travelCubit),
                DeviceSpacing.small.height,
                CountryRegionDropDowns(
                  travelCubit: travelCubit,
                  countryRegions: countryRegions,
                ),
                DeviceSpacing.small.height,
                CategoryAndClearFilters(travelCubit: travelCubit),
                DeviceSpacing.small.height,
                DatePickers(travelCubit: travelCubit),
              ],
            );
          }
        },
      ),
    );
  }
}
