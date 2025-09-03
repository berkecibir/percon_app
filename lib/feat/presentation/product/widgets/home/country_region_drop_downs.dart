import 'package:flutter/material.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';

class CountryRegionDropdowns extends StatelessWidget {
  final TravelCubit travelCubit;

  const CountryRegionDropdowns({super.key, required this.travelCubit});

  @override
  Widget build(BuildContext context) {
    // Ülke-bölge eşleme tablosu
    final Map<String, List<String>> countryRegions = {
      'Almanya': ['Berlin', 'Hamburg', 'Bayern', 'Sachsen', 'Hessen'],
      'Avusturya': ['Wien', 'Tirol', 'Salzburg', 'Steiermark', 'Vorarlberg'],
      'İsviçre': ['Zürich', 'Genève', 'Bern', 'Luzern', 'Valais'],
    };

    return BlocBuilder<TravelCubit, TravelState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: travelCubit.currentCountry,
                hint: const Text(AppTexts.countryDe),
                items: countryRegions.keys.map((String country) {
                  return DropdownMenuItem(value: country, child: Text(country));
                }).toList(),
                onChanged: (value) =>
                    travelCubit.onCountryChanged(value, countryRegions),
              ),
            ),
            DeviceSpacing.small.width,
            Expanded(
              child: DropdownButtonFormField<String>(
                value: travelCubit.currentRegion,
                hint: const Text(AppTexts.regionDe),
                items: travelCubit.currentCountry != null
                    ? (countryRegions[travelCubit.currentCountry!] ?? []).map((
                        String region,
                      ) {
                        return DropdownMenuItem(
                          value: region,
                          child: Text(region),
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
