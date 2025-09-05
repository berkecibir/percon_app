import 'package:percon_app/feat/data/model/travel/travel_model.dart';

abstract class ITravelRepository {
  Future<List<TravelModel>> getAllTravels({int offset, int limit});
  Future<int> getTotalCount();
  Future<void> toggleFavorite(String travelId);
  Future<List<TravelModel>> getFavoriteTravels();
  Future<bool> isFavorite(String travelId);
}
