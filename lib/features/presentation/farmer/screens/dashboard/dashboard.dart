import 'package:flutter/material.dart';
import '../../widgets/plant_growth_loader.dart';
import '/core/theme/app_colors.dart';
import '/features/presentation/farmer/screens/map/map_screen.dart';
import '/features/presentation/farmer/screens/community_screen.dart';
import 'package:intl/intl.dart';
import 'dashboard_controller.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardController(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: controller.isLoading
            ? const Center(child: PlantGrowthLoader())
            : controller.error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(controller.error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.loadDashboard,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: controller.loadDashboard,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      _WeatherHeader(data: controller.data!),
                      const SizedBox(height: 24),
                      _AlertsSection(data: controller.data!),
                      const SizedBox(height: 24),
                      _FarmStatusSection(data: controller.data!),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: const _FloatingButtons(),
    );
  }
}

// ───────────────── WEATHER HEADER ─────────────────
class _WeatherHeader extends StatelessWidget {
  final EnvironmentData data;

  const _WeatherHeader({required this.data});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return AppColors.good;
      case 'good':
        return AppColors.primaryColor;
      case 'fair':
        return AppColors.medium;
      case 'poor':
        return AppColors.critical;
      case 'critical':
      case 'dry':
        return Colors.red;
      default:
        return AppColors.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEE dd MMM yyyy').format(now);

    return Container(
      margin: const EdgeInsets.all(16),
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/farm_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Color(0xFF002F20).withOpacity(0.8),
              Colors.white.withOpacity(0.3),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('h:mm').format(now),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.notifications_outlined, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 48,
                      width: 48,
                      child: const CircleAvatar(
                        radius: 8,
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Text(
              dateStr,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              '${data.temperatureC.toStringAsFixed(0)} C°',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _WeatherInfo(
                  icon: Icons.cloud_outlined,
                  text: 'A little cloudy',
                ),
                const SizedBox(width: 16),
                _WeatherInfo(icon: Icons.air, text: 'Wind Speed\n19 Km/h'),
                const SizedBox(width: 16),
                _WeatherInfo(
                  icon: Icons.water_drop_outlined,
                  text:
                      'Humidity\n${data.relativeHumidityPercent.toStringAsFixed(0)}% RH',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _WeatherInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

// ───────────────── ALERTS SECTION ─────────────────
class _AlertsSection extends StatelessWidget {
  final EnvironmentData data;

  const _AlertsSection({required this.data});

  @override
  Widget build(BuildContext context) {
    // Generate alerts based on data
    final alerts = <Widget>[];

    // Check soil moisture (using ndvi as proxy)
    if (data.ndvi < 0.3) {
      alerts.add(
        _AlertCard(
          title: 'Critical',
          subtitle: 'Field02',
          message: 'Severe water stress detected — irrigate immediately',
          color: const Color(0xFFB85450),
        ),
      );
    }

    // Check pH levels
    if (data.ph < 6.5 || data.ph > 7.5) {
      alerts.add(
        _AlertCard(
          title: 'Warning',
          subtitle: 'Field01',
          message:
              'pH value is ${data.ph < 6.5 ? 'lower' : 'higher'} than expected',
          color: const Color(0xFFD4A650),
        ),
      );
    }

    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Alerts',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('See all')),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: alerts
                  .map(
                    (alert) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SizedBox(width: 260, child: alert),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String message;
  final Color color;

  const _AlertCard({
    required this.title,
    required this.subtitle,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 10, backgroundColor: color),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 12),
          const Text(
            'More details',
            style: TextStyle(color: AppColors.primaryColor, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ───────────────── FARM STATUS SECTION ─────────────────
class _FarmStatusSection extends StatelessWidget {
  final EnvironmentData data;

  const _FarmStatusSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {},
              ),
              Column(
                children: [
                  const Text(
                    'Field 01',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data.locationName,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Farm status',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatusCard(
                  icon: '🌱',
                  title: 'soil status',
                  items: [
                    _StatusItem(
                      'Moisture',
                      '${(data.ndvi * 100).toStringAsFixed(0)}%',
                      data.ndvi < 0.3 ? 'dry' : 'good',
                    ),
                    _StatusItem(
                      'Clay level',
                      '${data.clay.toStringAsFixed(0)}%',
                      'normal',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatusCard(
                  icon: '🌿',
                  title: 'Plant Health',
                  items: [
                    _StatusItem(
                      '',
                      '${_calculatePlantHealth(data).toStringAsFixed(0)}%',
                      _getPlantHealthStatus(data),
                    ),
                  ],
                  large: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatusCard(
                  icon: '🌡️',
                  title: 'Temperature',
                  items: [
                    _StatusItem(
                      '',
                      '${data.temperatureC.toStringAsFixed(0)}°C',
                      'normal',
                    ),
                  ],
                  large: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatusCard(
                  icon: '💧',
                  title: 'Humidity',
                  items: [
                    _StatusItem(
                      '',
                      '${data.relativeHumidityPercent.toStringAsFixed(0)}%',
                      'normal',
                    ),
                  ],
                  large: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ───────────────── HELPER FUNCTIONS ─────────────────
double _calculatePlantHealth(EnvironmentData data) {
  // Calculate plant health based on multiple factors
  double healthScore = 0;

  // NDVI contribution (0-30 points) - measures vegetation greenness
  // NDVI ranges from -1 to 1, healthy vegetation is typically 0.2-0.8
  double ndviScore = 0;
  if (data.ndvi < 0) {
    ndviScore = 0;
  } else if (data.ndvi > 0.8) {
    ndviScore = 30;
  } else {
    ndviScore = (data.ndvi / 0.8) * 30;
  }
  healthScore += ndviScore;

  // Soil pH contribution (0-20 points) - optimal range 6.0-7.5
  double phScore = 0;
  if (data.ph >= 6.0 && data.ph <= 7.5) {
    phScore = 20;
  } else if (data.ph >= 5.5 && data.ph <= 8.0) {
    phScore = 15;
  } else if (data.ph >= 5.0 && data.ph <= 8.5) {
    phScore = 10;
  } else {
    phScore = 5;
  }
  healthScore += phScore;

  // Soil organic carbon (SOC) contribution (0-15 points) - higher is better
  double socScore = 0;
  if (data.features.soc >= 2.0) {
    socScore = 15;
  } else if (data.features.soc >= 1.0) {
    socScore = 12;
  } else if (data.features.soc >= 0.5) {
    socScore = 8;
  } else {
    socScore = 4;
  }
  healthScore += socScore;

  // NPK levels contribution (0-20 points)
  double npkScore = 0;
  // Nitrogen (optimal: 0.1-0.3%)
  if (data.nitrogen >= 0.1 && data.nitrogen <= 0.3) {
    npkScore += 7;
  } else if (data.nitrogen >= 0.05) {
    npkScore += 4;
  }

  // Phosphorus (optimal: 10-30 mg/kg)
  if (data.phosphorus >= 10 && data.phosphorus <= 30) {
    npkScore += 7;
  } else if (data.phosphorus >= 5) {
    npkScore += 4;
  }

  // Potassium (optimal: 100-200 mg/kg)
  if (data.potassium >= 100 && data.potassium <= 200) {
    npkScore += 6;
  } else if (data.potassium >= 80) {
    npkScore += 3;
  }
  healthScore += npkScore;

  // CEC contribution (0-15 points) - higher is better for nutrient retention
  double cecScore = 0;
  if (data.features.cec >= 15) {
    cecScore = 15;
  } else if (data.features.cec >= 10) {
    cecScore = 12;
  } else if (data.features.cec >= 5) {
    cecScore = 8;
  } else {
    cecScore = (data.features.cec / 5) * 8;
  }
  healthScore += cecScore;

  // Ensure score is between 0 and 100
  return healthScore.clamp(0, 100);
}

String _getPlantHealthStatus(EnvironmentData data) {
  double health = _calculatePlantHealth(data);

  if (health >= 80) {
    return 'excellent';
  } else if (health >= 60) {
    return 'good';
  } else if (health >= 40) {
    return 'fair';
  } else if (health >= 20) {
    return 'poor';
  } else {
    return 'critical';
  }
}

// ───────────────── STATUS CARD ─────────────────
class _StatusCard extends StatelessWidget {
  final String icon;
  final String title;
  final List<_StatusItem> items;
  final bool large;

  const _StatusCard({
    required this.icon,
    required this.title,
    required this.items,
    this.large = false,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return const Color(0xFF2E7D32);
      case 'good':
        return AppColors.primaryColor;
      case 'fair':
        return const Color(0xFFF57C00);
      case 'poor':
        return const Color(0xFFE64A19);
      case 'critical':
      case 'dry':
        return Colors.red;
      default:
        return AppColors.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => _buildItem(item, large)),
        ],
      ),
    );
  }

  Widget _buildItem(_StatusItem item, bool isLarge) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: isLarge
          ? Column(
              children: [
                Text(
                  item.value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: _getStatusColor(item.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.label,
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
                Row(
                  children: [
                    Text(
                      item.value,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${item.status})',
                      style: TextStyle(
                        color: _getStatusColor(item.status),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _StatusItem {
  final String label;
  final String value;
  final String status;

  _StatusItem(this.label, this.value, this.status);
}

// ───────────────── FLOATING BUTTONS ─────────────────
class _FloatingButtons extends StatelessWidget {
  const _FloatingButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Community FAB
        SizedBox(
          width: 52,
          height: 52,
          child: FloatingActionButton(
            heroTag: 'fab_community',
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CommunityScreen()),
              );
            },
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 42),
          ),
        ),

        const SizedBox(height: 12),

        // Map FAB
        SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            heroTag: 'fab_map',
            backgroundColor: AppColors.lightGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MapScreen()),
              );
            },
            child: const Icon(
              Icons.map_outlined,
              size: 24,
              color: AppColors.greenishBlack,
            ),
          ),
        ),
      ],
    );
  }
}
