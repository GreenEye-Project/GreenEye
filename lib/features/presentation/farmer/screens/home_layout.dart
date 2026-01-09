import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projects/core/theme/app_colors.dart';
import 'dashboard/dashboard.dart';
import '/features/presentation/farmer/screens/market_screen.dart';
import '/features/presentation/farmer/screens/disease_detection/ui/disease_detection_screen.dart';
import '/features/presentation/farmer/screens/community_screen.dart';
import '/features/presentation/farmer/screens/settings_screen.dart';
import '/features/presentation/farmer/screens/map/map_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    DashboardScreen(),
    MarketScreen(),
    DiseaseDetectionScreen(),
    CommunityScreen(),
    SettingsScreen(),
    MapScreen(),
  ];

  BottomNavigationBarItem _navItem({
    required String label,
    required String icon,
    required bool isActive,
  }) {
    return BottomNavigationBarItem(
      backgroundColor: const Color(0xFFF5F5F5),
      label: label,
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        child: SvgPicture.asset(
          icon,
          width: isActive ? 25 : 24,
          height: isActive ? 25 : 24,
          colorFilter: ColorFilter.mode(
            isActive ? Colors.black : Colors.black87,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black87,

        items: [
          _navItem(
            label: 'Home',
            icon: 'assets/icons/home.svg',
            isActive: currentIndex == 0,
          ),
          _navItem(
            label: 'Market',
            icon: 'assets/icons/market.svg',
            isActive: currentIndex == 1,
          ),
          BottomNavigationBarItem(
            label: 'Check plant',
            icon: Image.asset('assets/icons/scan.png', width: 24, height: 24),
          ),
          _navItem(
            label: 'Community',
            icon: 'assets/icons/community.svg',
            isActive: currentIndex == 3,
          ),
          _navItem(
            label: 'Settings',
            icon: 'assets/icons/settings.svg',
            isActive: currentIndex == 4,
          ),
        ],
      ),
    );
  }
}
