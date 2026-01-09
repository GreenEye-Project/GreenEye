import 'package:equatable/equatable.dart';

class SimulationData extends Equatable {
  final String growthStage;
  final double expectedYield;
  final double cropHealth; // 0..1
  final String cropName;
  final String location;

  final int timelineDay;
  final double biomass; // kg/ha
  final double soilMoisture; // %
  final double waterStress; // 0..1
  final double heatStress; // 0..1

  const SimulationData({
    required this.growthStage,
    required this.expectedYield,
    required this.cropHealth,
    required this.cropName,
    required this.location,
    required this.timelineDay,
    required this.biomass,
    required this.soilMoisture,
    required this.waterStress,
    required this.heatStress,
  });

  SimulationData copyWith({
    String? growthStage,
    double? expectedYield,
    double? cropHealth,
    String? cropName,
    String? location,
    int? timelineDay,
    double? biomass,
    double? soilMoisture,
    double? waterStress,
    double? heatStress,
  }) {
    return SimulationData(
      growthStage: growthStage ?? this.growthStage,
      expectedYield: expectedYield ?? this.expectedYield,
      cropHealth: cropHealth ?? this.cropHealth,
      cropName: cropName ?? this.cropName,
      location: location ?? this.location,
      timelineDay: timelineDay ?? this.timelineDay,
      biomass: biomass ?? this.biomass,
      soilMoisture: soilMoisture ?? this.soilMoisture,
      waterStress: waterStress ?? this.waterStress,
      heatStress: heatStress ?? this.heatStress,
    );
  }

  @override
  List<Object?> get props => [
    growthStage,
    expectedYield,
    cropHealth,
    cropName,
    location,
    timelineDay,
    biomass,
    soilMoisture,
    waterStress,
    heatStress,
  ];
}