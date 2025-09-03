import 'package:flutter/material.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/pages/home/page/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin HomePageMixin on State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TravelCubit>().loadInitialTravels();
    });
  }
}
