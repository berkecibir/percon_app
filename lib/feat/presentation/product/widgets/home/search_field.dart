import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchField extends StatefulWidget {
  final TravelCubit travelCubit;

  const SearchField({super.key, required this.travelCubit});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = widget.travelCubit.state;
      if (currentState is TravelLoaded) {
        _controller.text = widget.travelCubit.currentSearchTerm ?? '';
      }
    });
  }

  void _updateControllerText() {
    final cubit = widget.travelCubit;
    _controller.text = cubit.currentSearchTerm ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelCubit, TravelState>(
      builder: (context, state) {
        _updateControllerText();
        return TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: AppTexts.searchDe.tr(),
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
          ),
          onChanged: widget.travelCubit.onSearchChanged,
        );
      },
    );
  }
}
