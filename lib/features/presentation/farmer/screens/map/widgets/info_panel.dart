import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:projects/core/theme/app_colors.dart';
import '/features/presentation/farmer/screens/map/map_controller.dart';
import '/features/presentation/farmer/widgets/plant_growth_loader.dart';

class LandInfoPanel extends StatefulWidget {
  final LatLng? selectedPoint;
  final ScrollController scrollController;

  const LandInfoPanel({
    super.key,
    required this.selectedPoint,
    required this.scrollController,
  });

  @override
  State<LandInfoPanel> createState() => _LandInfoPanelState();
}

class _LandInfoPanelState extends State<LandInfoPanel> {
  ClassificationResponse? _classificationData;
  ForecastResponse? _forecastData;
  CropRecommendationResponse? _cropData;

  bool _isLoading = false;
  bool _isCropLoading = false;
  bool _showCropRecommendations = false;

  String? _errorMessage;

  @override
  void didUpdateWidget(LandInfoPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedPoint != oldWidget.selectedPoint &&
        widget.selectedPoint != null) {
      _showCropRecommendations = false;
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    if (widget.selectedPoint == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _classificationData = null;
      _forecastData = null;
    });

    final lat = widget.selectedPoint!.latitude;
    final lng = widget.selectedPoint!.longitude;

    try {
      final results = await Future.wait<dynamic>([
        DesertificationApiController.getClassification(
          latitude: lat,
          longitude: lng,
        ),
        DesertificationApiController.getForecast(latitude: lat, longitude: lng),
      ]);

      setState(() {
        _classificationData = results[0] as ClassificationResponse?;
        _forecastData = results[1] as ForecastResponse?;
        _isLoading = false;

        if (_classificationData == null && _forecastData == null) {
          _errorMessage = 'Failed to load data for this location';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Network error: ${e.toString()}';
      });
    }
  }

  Future<void> _fetchCropRecommendations() async {
    if (widget.selectedPoint == null) return;

    setState(() {
      _showCropRecommendations = true;
      _isCropLoading = true;
      _cropData = null;
    });

    final lat = widget.selectedPoint!.latitude;
    final lng = widget.selectedPoint!.longitude;

    try {
      final result = await DesertificationApiController.getCropRecommendation(
        latitude: lat,
        longitude: lng,
      );

      setState(() {
        _cropData = result;
        _isCropLoading = false;
      });
    } catch (e) {
      setState(() {
        _isCropLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedPoint == null) return const SizedBox.shrink();

    if (_showCropRecommendations) {
      return _CropRecommendationView(
        isLoading: _isCropLoading,
        crops: _cropData?.data?.recommendedCrops ?? [],
        onBack: () => setState(() => _showCropRecommendations = false),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _DragHandle(),
            const SizedBox(height: 20),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: PlantGrowthLoader(
                    message: 'Analyzing location...',
                    subtitle: 'Fetching environmental data',
                    size: 100,
                  ),
                ),
              )
            else if (_errorMessage != null)
              Center(child: Text(_errorMessage!))
            else ...[
              _LocationHeader(
                locationName:
                    _forecastData?.data?.locationName ??
                    _classificationData?.data?.metadata.locationName ??
                    'Selected Location',
                coordinates: widget.selectedPoint!,
              ),
              const SizedBox(height: 24),

              _LandFeaturesSection(
                prediction: _classificationData?.data?.prediction,
                forecast: _forecastData?.data?.forecasts.isNotEmpty == true
                    ? _forecastData!.data!.forecasts.first
                    : null,
              ),

              if (_forecastData?.data?.forecasts.isNotEmpty == true) ...[
                const SizedBox(height: 24),
                _EnvironmentalDataSection(
                  forecast: _forecastData!.data!.forecasts.first,
                ),
              ],

              const SizedBox(height: 24),
              _GoToCropRecommendationCard(onTap: _fetchCropRecommendations),
            ],
          ],
        ),
      ),
    );
  }
}

/* ───────────── Widgets ───────────── */

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 48,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class _LocationHeader extends StatelessWidget {
  final String locationName;
  final LatLng coordinates;

  const _LocationHeader({
    required this.locationName,
    required this.coordinates,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/location.svg',
          width: 16,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.darkGreenish,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            locationName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.greenishBlack,
            ),
          ),
        ),
        const Icon(Icons.push_pin, color: Colors.black, size: 34),
      ],
    );
  }
}

class _LandFeaturesSection extends StatelessWidget {
  final Prediction? prediction;
  final ForecastItem? forecast;

  const _LandFeaturesSection({this.prediction, this.forecast});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/icons/land_features.png',
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 10),
            const Text(
              "Land Features",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGreenish,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Top Row: Plant Health & Desertification Class
        Row(
          children: [
            Expanded(
              child: _PlantHealthCard(
                prediction: prediction,
                forecast: forecast,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _DesertificationCard(prediction: prediction)),
          ],
        ),

        const SizedBox(height: 12),

        // Bottom: Risk Card
        if (forecast != null) _RiskCard(forecast: forecast!),
      ],
    );
  }
}

class _PlantHealthCard extends StatelessWidget {
  final Prediction? prediction;
  final ForecastItem? forecast;

  const _PlantHealthCard({this.prediction, this.forecast});

  @override
  Widget build(BuildContext context) {
    // Use NDVI from forecast as plant health indicator
    // NDVI typically ranges from -1 to 1, but for vegetation it's usually 0.2 to 0.8
    final ndvi = forecast?.ndvi ?? 0.0;

    double healthPercentage;
    if (ndvi < 0) {
      healthPercentage = 0.0;
    } else if (ndvi < 0.2) {
      healthPercentage = (ndvi / 0.2) * 0.2;
    } else {
      healthPercentage = 0.2 + ((ndvi - 0.2) / 0.6) * 0.8;
      healthPercentage = healthPercentage.clamp(0.0, 1.0);
    }

    final healthStatus = healthPercentage >= 0.7
        ? 'Good'
        : healthPercentage >= 0.4
        ? 'Moderate'
        : 'Poor';

    final healthColor = healthPercentage >= 0.7
        ? AppColors.good
        : healthPercentage >= 0.4
        ? AppColors.medium
        : AppColors.critical;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  'assets/icons/plant.svg',
                  width: 20,
                  height: 28,
                ),
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'Plant Health',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 6),
              Text(
                '${(healthPercentage * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreenish,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                healthStatus,
                style: TextStyle(
                  fontSize: 15,
                  color: healthColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DesertificationCard extends StatelessWidget {
  final Prediction? prediction;

  const _DesertificationCard({this.prediction});

  @override
  Widget build(BuildContext context) {
    final level = prediction?.displayLevel ?? 'Unknown';
    final color = prediction?.levelColor ?? AppColors.grey;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Desertification',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Center(
            child: Text(
              'Class',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  level,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGreenish,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskCard extends StatelessWidget {
  final ForecastItem forecast;

  const _RiskCard({required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: forecast.riskColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Risk',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    forecast.riskTimeframe,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreenish,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────── NEW: Environmental Data Section ───────────── */

class _EnvironmentalDataSection extends StatelessWidget {
  final ForecastItem forecast;

  const _EnvironmentalDataSection({required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 32,
              color: AppColors.darkGreenish,
            ),
            const SizedBox(width: 10),
            const Text(
              "Environmental Data",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGreenish,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row 1: Temperature & Humidity
        Row(
          children: [
            Expanded(
              child: _DataCard(
                icon: Icons.thermostat,
                label: 'Temperature',
                value: '${forecast.t2mC.toStringAsFixed(1)}°C',
                subtitle: forecast.t2mC > 35
                    ? 'High'
                    : forecast.t2mC > 25
                    ? 'Moderate'
                    : 'Low',
                color: forecast.t2mC > 35
                    ? AppColors.critical
                    : forecast.t2mC > 25
                    ? AppColors.medium
                    : AppColors.good,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DataCard(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: '${forecast.rhPct.toStringAsFixed(1)}%',
                subtitle: forecast.rhPct < 30
                    ? 'Low'
                    : forecast.rhPct < 60
                    ? 'Moderate'
                    : 'High',
                color: forecast.rhPct < 30
                    ? AppColors.critical
                    : forecast.rhPct < 60
                    ? AppColors.medium
                    : AppColors.good,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Row 2: Precipitation & NDVI
        Row(
          children: [
            Expanded(
              child: _DataCard(
                icon: Icons.grain,
                label: 'Precipitation',
                value: '${(forecast.tpM * 1000).toStringAsFixed(1)} mm',
                subtitle: forecast.tpM < 0.01
                    ? 'Very Low'
                    : forecast.tpM < 0.05
                    ? 'Low'
                    : 'Adequate',
                color: forecast.tpM < 0.01
                    ? AppColors.critical
                    : forecast.tpM < 0.05
                    ? AppColors.medium
                    : AppColors.good,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DataCard(
                icon: Icons.eco,
                label: 'NDVI',
                value: forecast.ndvi.toStringAsFixed(3),
                subtitle: 'Vegetation Index',
                color: forecast.ndvi > 0.5
                    ? AppColors.good
                    : forecast.ndvi > 0.3
                    ? AppColors.medium
                    : AppColors.critical,
              ),
            ),
          ],
        ),

        // Optional: Dewpoint Temperature if available
        if (forecast.td2mC != null) ...[
          const SizedBox(height: 12),
          _DataCard(
            icon: Icons.ac_unit,
            label: 'Dew Point',
            value: '${forecast.td2mC!.toStringAsFixed(1)}°C',
            subtitle: 'Moisture indicator',
            color: AppColors.darkGreenish,
            fullWidth: true,
          ),
        ],

        // Solar Radiation if available
        if (forecast.ssrdJm2 != null) ...[
          const SizedBox(height: 12),
          _DataCard(
            icon: Icons.wb_sunny,
            label: 'Solar Radiation',
            value: '${(forecast.ssrdJm2! / 1000000).toStringAsFixed(2)} MJ/m²',
            subtitle: 'Surface radiation',
            color: AppColors.darkGreenish,
            fullWidth: true,
          ),
        ],
      ],
    );
  }
}

class _DataCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;
  final bool fullWidth;

  const _DataCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreenish,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ───────────── NAV CARD ───────────── */

class _GoToCropRecommendationCard extends StatelessWidget {
  final VoidCallback onTap;

  const _GoToCropRecommendationCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: const [
            Icon(Icons.agriculture, color: AppColors.darkGreenish),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'View Crop Recommendations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGreenish,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}

/* ───────────── CROP VIEW ───────────── */

class _CropRecommendationView extends StatelessWidget {
  final bool isLoading;
  final List<String> crops;
  final VoidCallback onBack;

  const _CropRecommendationView({
    required this.isLoading,
    required this.crops,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBack,
            child: Row(
              children: const [
                Icon(Icons.arrow_back_ios, size: 18),
                SizedBox(width: 6),
                Text(
                  'Back',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Recommended Crops',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGreenish,
            ),
          ),
          const SizedBox(height: 20),
          if (isLoading)
            const Center(child: PlantGrowthLoader())
          else if (crops.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No suitable crops found for this land',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: crops.length,
              itemBuilder: (_, index) => _CropCard(cropName: crops[index]),
            ),
        ],
      ),
    );
  }
}

class _CropCard extends StatelessWidget {
  final String cropName;

  const _CropCard({required this.cropName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.eco, size: 32, color: AppColors.primaryColor),
          const SizedBox(height: 12),
          Text(
            cropName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreenish,
            ),
          ),
        ],
      ),
    );
  }
}
