import 'package:equatable/equatable.dart';
import '/core/models/simulation_data.dart';

abstract class SimulationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SimulationInitial extends SimulationState {}

class SimulationLoading extends SimulationState {}

class SimulationLoaded extends SimulationState {
  final SimulationData data;
  final List<SimulationData> history;

  SimulationLoaded({required this.data, required this.history});

  @override
  List<Object?> get props => [data, history];
}

class SimulationError extends SimulationState {
  final String message;
  SimulationError(this.message);

  @override
  List<Object?> get props => [message];
}