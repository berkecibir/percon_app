import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';
import 'package:percon_app/feat/presentation/product/widgets/custom_app_bar.dart';
import 'package:percon_app/feat/presentation/product/widgets/home/travel_card.dart';

class FavoritePage extends StatefulWidget {
  static const String id = AppTexts.favoritePageId;
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.favorite(),
      body: BlocBuilder<TravelCubit, TravelState>(
        builder: (context, state) {
          if (state is TravelLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is TravelError) {
            return const Center(child: Text(AppTexts.errorLoadingMsgDe));
          } else if (state is TravelLoaded) {
            // Filter favorites directly from the state
            final favoriteTravels = state.travels
                .where((travel) => travel.isFavorite)
                .toList();
            if (favoriteTravels.isEmpty) {
              return const Center(child: Text(AppTexts.noFavoritesYetDe));
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
