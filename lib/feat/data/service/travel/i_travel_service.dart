import 'package:percon_app/feat/data/model/travel/travel_model.dart';

abstract class ITravelService {
  Future<List<TravelModel>?> loadTravels({
    required int offSet,
    required int limit,
  });
  Future<int> getTotalCount();
  Future<void> toggleFavorite(String travelId);
  Future<List<TravelModel>> getFavoriteTravels();
  Future<bool> isFavorite(String travelId); // Add this missing method
}
