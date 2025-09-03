import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';

class SearchField extends StatelessWidget {
  final TravelCubit travelCubit;

  const SearchField({super.key, required this.travelCubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelCubit, TravelState>(
      builder: (context, state) {
        return TextField(
          decoration: InputDecoration(
            hintText: AppTexts.searchDe,
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: travelCubit.clearSearch,
            ),
          ),
          onChanged: travelCubit.onSearchChanged,
        );
      },
    );
  }
}
