import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';

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
            hintText: AppTexts.searchDe,
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: widget.travelCubit.clearSearch,
            ),
          ),
          onChanged: widget.travelCubit.onSearchChanged,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
