import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/simulation_repository.dart';
import '/core/models/simulation_data.dart';
import 'simulation_event.dart';
import 'simulation_state.dart';

class SimulationBloc extends Bloc<SimulationEvent, SimulationState> {
  final SimulationRepository repository;
  StreamSubscription<SimulationData>? _dataSub;
  StreamSubscription<List<SimulationData>>? _historySub;

  SimulationBloc(this.repository) : super(SimulationInitial()) {
    on<SimulationStarted>(_onStarted);
    on<SimulationDataReceived>(_onDataReceived);
    on<SimulationHistoryUpdated>(_onHistoryUpdated);
    on<SimulationStopped>(_onStopped);
  }

  Future<void> _onStarted(
    SimulationStarted event,
    Emitter<SimulationState> emit,
  ) async {
    emit(SimulationLoading());

    // start repository using optional seed
    repository.start(seed: event.seed);

    // subscribe to datapoints
    _dataSub = repository.streamSimulationData().listen(
      (d) {
        add(SimulationDataReceived(d));
      },
      onError: (err) {
        addError(err);
      },
    );

    // subscribe to history
    _historySub = repository.streamSimulationHistory().listen(
      (hist) {
        add(SimulationHistoryUpdated(hist));
      },
      onError: (err) {
        addError(err);
      },
    );
  }

  void _onDataReceived(
    SimulationDataReceived event,
    Emitter<SimulationState> emit,
  ) {
    final currentHistory = state is SimulationLoaded
        ? (state as SimulationLoaded).history
        : <SimulationData>[];
    emit(
      SimulationLoaded(
        data: event.data,
        history: List<SimulationData>.unmodifiable(currentHistory),
      ),
    );
  }

  void _onHistoryUpdated(
    SimulationHistoryUpdated event,
    Emitter<SimulationState> emit,
  ) {
    final hist = List<SimulationData>.unmodifiable(event.history);
    SimulationData? currentData = state is SimulationLoaded
        ? (state as SimulationLoaded).data
        : (hist.isNotEmpty ? hist.last : null);
    if (currentData != null) {
      emit(SimulationLoaded(data: currentData, history: hist));
    } else {
      emit(SimulationLoading());
    }
  }

  Future<void> _onStopped(
    SimulationStopped event,
    Emitter<SimulationState> emit,
  ) async {
    await _dataSub?.cancel();
    await _historySub?.cancel();
    repository.stop();
    emit(SimulationInitial());
  }

  @override
  Future<void> close() async {
    await _dataSub?.cancel();
    await _historySub?.cancel();
    await repository.dispose();
    return super.close();
  }
}
