import '/core/models/simulation_data.dart';

abstract class SimulationEvent {}

class SimulationStarted extends SimulationEvent {
  final SimulationData? seed;
  SimulationStarted({this.seed});
}

class SimulationDataReceived extends SimulationEvent {
  final SimulationData data;
  SimulationDataReceived(this.data);
}

class SimulationHistoryUpdated extends SimulationEvent {
  final List<SimulationData> history;
  SimulationHistoryUpdated(this.history);
}

class SimulationStopped extends SimulationEvent {}