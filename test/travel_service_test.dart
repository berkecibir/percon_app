import 'package:flutter_test/flutter_test.dart';
import 'package:percon_app/feat/data/service/travel/travel_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TravelService', () {
    late TravelService travelService;

    setUp(() async {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
      travelService = TravelService();
    });

    test('toggleFavorite should add and remove user favorite IDs', () async {
      // Test adding a favorite
      await travelService.toggleFavorite('1');
      expect(await travelService.isFavorite('1'), true);

      // Test removing a favorite
      await travelService.toggleFavorite('1');
      expect(await travelService.isFavorite('1'), false);
    });

    test('getFavoriteTravels should return user favorite travels', () async {
      // Add a favorite
      await travelService.toggleFavorite('1');

      // Get favorite travels
      final favorites = await travelService.getFavoriteTravels();

      // Check that we get the favorite travel
      // Note: This will return an empty list because we don't have actual travel data in tests
      // But the important thing is that it doesn't crash
      expect(favorites.length, 1);
      expect(favorites[0].id, '1');
      expect(favorites[0].isFavorite, true);
    });
  });
}
