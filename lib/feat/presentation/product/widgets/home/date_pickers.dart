import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';
import 'package:easy_localization/easy_localization.dart';

class DatePickers extends StatelessWidget {
  final TravelCubit travelCubit;

  const DatePickers({super.key, required this.travelCubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelCubit, TravelState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => travelCubit.selectStartDate(context),
                child: Text(
                  travelCubit.currentStartDate == null
                      ? AppTexts.startDateDe.tr()
                      : '${travelCubit.currentStartDate!.day}/${travelCubit.currentStartDate!.month}/${travelCubit.currentStartDate!.year}',
                ),
              ),
            ),
            DeviceSpacing.small.width,
            Expanded(
              child: ElevatedButton(
                onPressed: () => travelCubit.selectEndDate(context),
                child: Text(
                  travelCubit.currentEndDate == null
                      ? AppTexts.endDateDe.tr()
                      : '${travelCubit.currentEndDate!.day}/${travelCubit.currentEndDate!.month}/${travelCubit.currentEndDate!.year}',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
