import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';
import 'package:percon_app/feat/presentation/product/widgets/custom_app_bar.dart';
import 'package:percon_app/feat/presentation/product/widgets/home/travel_card.dart';
import 'package:easy_localization/easy_localization.dart';

class FavoritePage extends StatelessWidget {
  static const String id = AppTexts.favoritePageId;
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.favorite(),
      body: BlocBuilder<TravelCubit, TravelState>(
        builder: (context, state) {
          if (state is TravelLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is TravelError) {
            return Center(child: Text(AppTexts.errorLoadingMsgDe.tr()));
          } else if (state is TravelLoaded) {
            // Filter favorites directly from the state
            final favoriteTravels = state.travels
                .where((travel) => travel.isFavorite)
                .toList();
            if (favoriteTravels.isEmpty) {
              return Center(child: Text(AppTexts.noFavoritesYetDe.tr()));
            }
            return ListView.builder(
              itemCount: favoriteTravels.length,
              itemBuilder: (context, index) {
                return TravelCard(
                  travel: favoriteTravels[index],
                  onToggleFavorite: (String id) {
                    context.read<TravelCubit>().toggleFavorite(id);
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
