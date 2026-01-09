import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/models/simulation_data.dart';
import '../data/simulation_repository.dart';
import '../bloc/simulation_bloc.dart';
import '../bloc/simulation_event.dart';
import '../bloc/simulation_state.dart';
import './widgets/simulation_header.dart';
import './widgets/timeline_section.dart';
import './widgets/general_info_section.dart';
import './widgets/yield_prediction_section.dart';
import './widgets/crop_status_section.dart';
import './widgets/growth_trends_section.dart';
import './widgets/stress_factors_section.dart';
import './widgets/soil_quality_section.dart';
import './widgets/fertilizer_needs_section.dart';

class SimulationScreen extends StatefulWidget {
  final SimulationData? seed;
  const SimulationScreen({super.key, this.seed});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  late final SimulationRepository _repo;
  late final SimulationBloc _bloc;

  @override
  void initState() {
    super.initState();
    _repo = SimulationRepository();
    _bloc = SimulationBloc(_repo);
    // start with optional seed
    _bloc.add(SimulationStarted(seed: widget.seed));
  }

  @override
  void dispose() {
    _bloc.add(SimulationStopped());
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: const Color(0xfff8fdf9),
        body: SafeArea(
          child: BlocBuilder<SimulationBloc, SimulationState>(
            builder: (context, state) {
              if (state is SimulationLoading || state is SimulationInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SimulationLoaded) {
                final data = state.data;
                final history = state.history;
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: SimulationHeader(data: data)),
                    SliverToBoxAdapter(
                      child: TimelineSection(day: data.timelineDay),
                    ),
                    SliverToBoxAdapter(child: GeneralInfoSection()),
                    SliverToBoxAdapter(
                      child: YieldPredictionSection(data: data),
                    ),
                    SliverToBoxAdapter(child: CropStatusSection(data: data)),
                    SliverToBoxAdapter(
                      child: GrowthTrendsSection(data: data, history: history),
                    ),
                    SliverToBoxAdapter(
                      child: StressFactorsSection(data: data, history: history),
                    ),
                    SliverToBoxAdapter(child: SoilQualitySection(data: data)),
                    SliverToBoxAdapter(
                      child: FertilizerNeedsSection(data: data),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                );
              } else if (state is SimulationError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'map',
              onPressed: () {},
              backgroundColor: Colors.white,
              child: const Icon(Icons.map, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'edit',
              onPressed: () {},
              backgroundColor: Colors.white,
              child: const Icon(Icons.edit, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
