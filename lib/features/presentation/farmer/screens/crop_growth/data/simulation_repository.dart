import 'dart:async';
import '/core/models/simulation_data.dart';

class SimulationRepository {
  final int bufferSize;
  final Duration interval;

  final List<SimulationData> _buffer = [];
  Timer? _timer;

  final StreamController<SimulationData> _dataController =
      StreamController<SimulationData>.broadcast();
  final StreamController<List<SimulationData>> _historyController =
      StreamController<List<SimulationData>>.broadcast();

  SimulationRepository({
    this.bufferSize = 30,
    this.interval = const Duration(seconds: 2),
  });

  Stream<SimulationData> streamSimulationData() => _dataController.stream;
  Stream<List<SimulationData>> streamSimulationHistory() =>
      _historyController.stream;

  void start({SimulationData? seed}) {
    if (_timer != null && _timer!.isActive) return;

    int count = seed?.timelineDay ?? 0;
    // Optionally pre-fill buffer with seed history
    if (seed != null && _buffer.isEmpty) {
      for (int i = 0; i < 8; i++) {
        _buffer.add(
          seed.copyWith(
            timelineDay: (seed.timelineDay - (8 - i)) % 30,
            biomass: (seed.biomass - (8 - i) * 20).clamp(
              100.0,
              double.infinity,
            ),
          ),
        );
      }
      _historyController.add(List<SimulationData>.unmodifiable(_buffer));
    }

    _timer = Timer.periodic(interval, (_) {
      final data = SimulationData(
        growthStage: _pickStage(count),
        expectedYield: 6.85,
        cropHealth: (0.6 + (count % 5) * 0.08).clamp(0.0, 1.0),
        cropName: seed?.cropName ?? "Wheat",
        location: seed?.location ?? "Kafr Shukr, Egypt",
        timelineDay: count % 30,
        biomass: 1200 + (count * 12.0),
        soilMoisture: (18 + (count % 8) * 2).toDouble(),
        waterStress: ((count % 5) / 5.0),
        heatStress: ((count % 6) / 6.0),
      );

      _dataController.add(data);
      _buffer.add(data);
      if (_buffer.length > bufferSize) _buffer.removeAt(0);
      _historyController.add(List<SimulationData>.unmodifiable(_buffer));

      count++;
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> dispose() async {
    stop();
    await _dataController.close();
    await _historyController.close();
  }

  void feedDataFromApi(SimulationData newData) {
    _dataController.add(newData);
    _buffer.add(newData);
    if (_buffer.length > bufferSize) _buffer.removeAt(0);
    _historyController.add(List<SimulationData>.unmodifiable(_buffer));
  }

  String _pickStage(int count) {
    final stages = [
      "Germination",
      "Seedling",
      "Vegetative",
      "Flowering",
      "Ripening",
    ];
    return stages[count % stages.length];
  }
}