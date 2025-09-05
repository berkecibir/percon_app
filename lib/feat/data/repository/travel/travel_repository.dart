import 'package:percon_app/feat/data/model/travel/travel_model.dart';
import 'package:percon_app/feat/data/repository/travel/i_travel_repository.dart';
import 'package:percon_app/feat/data/service/travel/travel_service.dart'
    show TravelService;

class TravelRepository implements ITravelRepository {
  final TravelService _travelService;

  TravelRepository({TravelService? travelService})
    : _travelService = travelService ?? TravelService();
  @override
  Future<List<TravelModel>> getAllTravels({
    int offset = 0,
    int limit = 20,
  }) async {
    return await _travelService.loadTravels(offSet: offset, limit: limit);
  }

  @override
  Future<void> toggleFavorite(String travelId) async {
    return await _travelService.toggleFavorite(travelId);
  }

  @override
  Future<List<TravelModel>> getFavoriteTravels() async {
    return await _travelService.getFavoriteTravels();
  }

  @override
  Future<int> getTotalCount() async {
    return await _travelService.getTotalCount();
  }

  @override
  Future<bool> isFavorite(String travelId) async {
    return await _travelService.isFavorite(travelId);
  }
}
