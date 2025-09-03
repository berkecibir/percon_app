import 'package:equatable/equatable.dart';
import 'package:percon_app/core/utils/enum/view_mode_enum.dart';
import 'package:percon_app/feat/data/model/travel/travel_model.dart';

abstract class TravelState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TravelInitial extends TravelState {}

class TravelLoading extends TravelState {}

class TravelLoaded extends TravelState {
  final List<TravelModel> travels;
  final ViewMode viewMode;

  TravelLoaded(this.travels, {this.viewMode = ViewMode.list});

  @override
  List<Object> get props => [travels, viewMode];

  TravelLoaded copyWith({List<TravelModel>? travels, ViewMode? viewMode}) {
    return TravelLoaded(
      travels ?? this.travels,
      viewMode: viewMode ?? this.viewMode,
    );
  }
}

class TravelError extends TravelState {
  final String message;

  TravelError(this.message);
  @override
  List<Object> get props => [message];
}
