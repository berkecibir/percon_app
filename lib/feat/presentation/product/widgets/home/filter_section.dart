import 'package:flutter/material.dart';
import 'package:percon_app/core/widgets/device_padding/device_padding.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/product/widgets/home/category_and_clear_filters.dart';
import 'package:percon_app/feat/presentation/product/widgets/home/country_region_drop_downs.dart';
import 'package:percon_app/feat/presentation/product/widgets/home/date_pickers.dart';
import 'package:percon_app/feat/presentation/product/widgets/home/search_field.dart';

class FilterSection extends StatelessWidget {
  final TravelCubit travelCubit;

  const FilterSection({super.key, required this.travelCubit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: DevicePadding.small.all,
      child: Column(
        children: [
          SearchField(travelCubit: travelCubit),
          DeviceSpacing.small.height,
          CountryRegionDropdowns(travelCubit: travelCubit),
          DeviceSpacing.small.height,
          CategoryAndClearFilters(travelCubit: travelCubit),
          DeviceSpacing.small.height,
          DatePickers(travelCubit: travelCubit),
        ],
      ),
    );
  }
}
