import 'package:equatable/equatable.dart';
import 'package:percon_app/feat/data/model/travel/travel_model.dart';

abstract class TravelState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TravelInitial extends TravelState {}

class TravelLoading extends TravelState {}

class TravelLoaded extends TravelState {
  final List<TravelModel> travels;

  TravelLoaded(this.travels);
  @override
  List<Object> get props => [travels];
}

class TravelError extends TravelState {
  final String message;

  TravelError(this.message);
  @override
  List<Object> get props => [message];
}
