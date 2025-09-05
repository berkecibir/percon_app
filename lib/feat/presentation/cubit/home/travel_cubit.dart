import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/duration/app_duration.dart';
import 'package:percon_app/core/utils/enum/view_mode_enum.dart';
import 'package:percon_app/feat/data/model/travel/travel_model.dart';
import 'package:percon_app/feat/data/repository/travel/i_travel_repository.dart';
import 'package:percon_app/feat/data/repository/travel/travel_repository.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_state.dart';

class TravelCubit extends Cubit<TravelState> {
  final ITravelRepository _travelRepository;
  List<TravelModel> _allTravels = [];
  List<TravelModel> _filteredTravels = [];
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 0;
  static const int _pageSize = 50;
  String? _currentCountry;
  String? _currentRegion;
  String? _currentCategory;
  DateTime? _currentStartDate;
  DateTime? _currentEndDate;
  String? _currentSearchTerm;
  ViewMode _viewMode = ViewMode.list; // Use ViewMode from utils

  TravelCubit({ITravelRepository? travelRepository})
    : _travelRepository = travelRepository ?? TravelRepository(),
      super(TravelInitial()) {
    loadInitialTravels();
  }
  void loadInitialTravels() async {
    emit(TravelLoading());
    try {
      _allTravels = await _travelRepository.getAllTravels(limit: _pageSize);
      _filteredTravels = List.from(_allTravels);
      _currentPage = 1;
      emit(TravelLoaded(_filteredTravels, viewMode: _viewMode));
    } catch (e) {
      emit(TravelError('Failed to load travels: $e'));
    }
  }

  void loadMoreTravels() async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    // Emit the current state with a loading indicator flag
    if (state is TravelLoaded) {
      emit(
        (state as TravelLoaded).copyWith(travels: List.from(_filteredTravels)),
      );
    } else {
      emit(TravelLoaded(List.from(_filteredTravels), viewMode: _viewMode));
    }

    try {
      final moreTravels = await _travelRepository.getAllTravels(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
      );

      if (moreTravels.isEmpty) {
        _hasMoreData = false;
      } else {
        _allTravels.addAll(moreTravels);
        _applyCurrentFilters(); // Re-apply filters to include new data
        _currentPage++;
      }

      _isLoadingMore = false;
    } catch (e) {
      _isLoadingMore = false;
      // Handle error silently or emit an error state for loading more
    }
  }

  void toggleFavorite(String travelId) async {
    try {
      // Repository'de toggle işlemini yap
      await _travelRepository.toggleFavorite(travelId);

      // Repository'den güncel favorite durumunu al
      final isNowFavorite = await _travelRepository.isFavorite(travelId);

      // Lokal state'i güncelle
      _updateTravelFavoriteStatus(travelId, isNowFavorite);

      // UI'ı güncelle
      _emitUpdatedState();
    } catch (e) {
      emit(TravelError('Failed to toggle favorite: $e'));
    }
  }

  // Belirli bir travel'ın favorite durumunu güncelle
  void _updateTravelFavoriteStatus(String travelId, bool isFavorite) {
    // _allTravels listesini güncelle
    for (int i = 0; i < _allTravels.length; i++) {
      if (_allTravels[i].id == travelId) {
        _allTravels[i] = _allTravels[i].copyWith(isFavorite: isFavorite);
        break;
      }
    }

    // _filteredTravels listesini güncelle
    for (int i = 0; i < _filteredTravels.length; i++) {
      if (_filteredTravels[i].id == travelId) {
        _filteredTravels[i] = _filteredTravels[i].copyWith(
          isFavorite: isFavorite,
        );
        break;
      }
    }
  }

  // Güncellenmiş state'i emit et
  void _emitUpdatedState() {
    if (state is TravelLoaded) {
      emit(
        (state as TravelLoaded).copyWith(travels: List.from(_filteredTravels)),
      );
    } else {
      emit(TravelLoaded(List.from(_filteredTravels), viewMode: _viewMode));
    }
  }

  // Get favorite travels
  List<TravelModel> getFavoriteTravels() {
    return _allTravels.where((travel) => travel.isFavorite).toList();
  }

  void _applyCurrentFilters() {
    List<TravelModel> filtered = List.from(_allTravels);

    if (_currentCountry != null && _currentCountry!.isNotEmpty) {
      filtered = filtered.where((t) => t.country == _currentCountry).toList();
    }

    if (_currentRegion != null && _currentRegion!.isNotEmpty) {
      filtered = filtered.where((t) => t.region == _currentRegion).toList();
    }

    if (_currentCategory != null && _currentCategory!.isNotEmpty) {
      filtered = filtered.where((t) => t.category == _currentCategory).toList();
    }

    if (_currentStartDate != null) {
      filtered = filtered
          .where(
            (t) =>
                t.startDate.isAtSameMomentAs(_currentStartDate!) ||
                t.startDate.isAfter(_currentStartDate!),
          )
          .toList();
    }

    if (_currentEndDate != null) {
      filtered = filtered
          .where(
            (t) =>
                t.endDate.isAtSameMomentAs(_currentEndDate!) ||
                t.endDate.isBefore(_currentEndDate!),
          )
          .toList();
    }

    if (_currentSearchTerm != null && _currentSearchTerm!.isNotEmpty) {
      final term = _currentSearchTerm!.toLowerCase();
      filtered = filtered
          .where(
            (t) =>
                t.title.toLowerCase().contains(term) ||
                t.description.toLowerCase().contains(term) ||
                t.country.toLowerCase().contains(term) ||
                t.region.toLowerCase().contains(term) ||
                t.category.toLowerCase().contains(term),
          )
          .toList();
    }

    _filteredTravels = filtered;
    emit(TravelLoaded(_filteredTravels));
  }

  void filterTravels({
    String? country,
    String? region,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    String? searchTerm,
  }) {
    // Store current filter values
    _currentCountry = country;
    _currentRegion = region;
    _currentCategory = category;
    _currentStartDate = startDate;
    _currentEndDate = endDate;
    _currentSearchTerm = searchTerm;

    // Reset pagination when filters change
    _currentPage = 1;
    _hasMoreData = true;
    _applyCurrentFilters();
  }

  //method => load favorites
  Future<void> loadFavoriteTravels() async {
    try {
      // This will load favorites from cache into the service
      final favoriteTravels = await _travelRepository.getFavoriteTravels();

      // Update the isFavorite flag for all travels
      for (int i = 0; i < _allTravels.length; i++) {
        final isFavorite = favoriteTravels.any(
          (fav) => fav.id == _allTravels[i].id,
        );
        if (_allTravels[i].isFavorite != isFavorite) {
          _allTravels[i] = _allTravels[i].copyWith(isFavorite: isFavorite);
        }
      }

      // Also update filtered travels
      for (int i = 0; i < _filteredTravels.length; i++) {
        final isFavorite = favoriteTravels.any(
          (fav) => fav.id == _filteredTravels[i].id,
        );
        if (_filteredTravels[i].isFavorite != isFavorite) {
          _filteredTravels[i] = _filteredTravels[i].copyWith(
            isFavorite: isFavorite,
          );
        }
      }

      // Emit updated state
      if (state is TravelLoaded) {
        emit(
          (state as TravelLoaded).copyWith(
            travels: List.from(_filteredTravels),
          ),
        );
      } else {
        emit(TravelLoaded(List.from(_filteredTravels), viewMode: _viewMode));
      }
    } catch (e) {
      emit(TravelError('Failed to load favorites: $e'));
    }
  }

  // New methods for UI interactions
  void clearSearch() {
    _currentSearchTerm = null;
    _applyCurrentFilters();
  }

  void onSearchChanged(String value) {
    // Debounce the search to avoid too many requests
    Future.delayed(AppDuration.short, () {
      _currentSearchTerm = value.isEmpty ? null : value;
      _applyCurrentFilters();
    });
  }

  void onCountryChanged(
    String? value,
    Map<String, List<String>> countryRegions,
  ) {
    filterTravels(
      country: value,
      region: value != null
          ? null
          : _currentRegion, // Reset region to null when country changes
      category: _currentCategory,
      startDate: _currentStartDate,
      endDate: _currentEndDate,
      searchTerm: _currentSearchTerm,
    );
  }

  void onRegionChanged(String? value) {
    filterTravels(
      country: _currentCountry,
      region: value,
      category: _currentCategory,
      startDate: _currentStartDate,
      endDate: _currentEndDate,
      searchTerm: _currentSearchTerm,
    );
  }

  void onCategoryChanged(String? value) {
    filterTravels(
      country: _currentCountry,
      region: _currentRegion,
      category: value,
      startDate: _currentStartDate,
      endDate: _currentEndDate,
      searchTerm: _currentSearchTerm,
    );
  }

  void clearAllFilters() {
    filterTravels();
  }

  void selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      filterTravels(
        country: _currentCountry,
        region: _currentRegion,
        category: _currentCategory,
        startDate: picked,
        endDate: _currentEndDate,
        searchTerm: _currentSearchTerm,
      );
    }
  }

  void selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      filterTravels(
        country: _currentCountry,
        region: _currentRegion,
        category: _currentCategory,
        startDate: _currentStartDate,
        endDate: picked,
        searchTerm: _currentSearchTerm,
      );
    }
  }

  // Add view mode toggle method
  void toggleViewMode() {
    _viewMode = _viewMode == ViewMode.list ? ViewMode.grid : ViewMode.list;
    // Emit updated state with new viewMode
    if (state is TravelLoaded) {
      emit((state as TravelLoaded).copyWith(viewMode: _viewMode));
    } else {
      emit(TravelLoaded(List.from(_filteredTravels), viewMode: _viewMode));
    }
  }

  bool get hasMoreData => _hasMoreData;
  bool get isLoadingMore => _isLoadingMore;
  ViewMode get viewMode => _viewMode; // Add getter for view mode

  // Public getter methods for filter values
  String? get currentCountry => _currentCountry;
  String? get currentRegion => _currentRegion;
  String? get currentCategory => _currentCategory;
  DateTime? get currentStartDate => _currentStartDate;
  DateTime? get currentEndDate => _currentEndDate;
  String? get currentSearchTerm => _currentSearchTerm;
}
