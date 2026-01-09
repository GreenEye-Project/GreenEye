import 'package:flutter/material.dart';
import 'package:projects/core/theme/app_colors.dart';
import '/core/network/session_manager.dart';
import '/features/auth/login/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color _tileBg = AppColors.secondaryColor;
  static const Color _sectionColor = AppColors.darkGrey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.greenishBlack,
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _userCard(context),
            const SizedBox(height: 24),

            _sectionTitle('Account'),
            _tile(icon: Icons.person_outlined, title: 'Profile', onTap: () {}),
            _tile(
              icon: Icons.password_outlined,
              title: 'Change Password',
              onTap: () {},
            ),

            const SizedBox(height: 4),
            _sectionTitle('Farming & Subscription'),
            _tile(
              icon: Icons.agriculture_outlined,
              title: 'Add farm',
              onTap: () {},
            ),
            _tile(
              icon: Icons.receipt_long_outlined,
              title: 'Manage Subscription',
              onTap: () {},
            ),

            const SizedBox(height: 4),
            _sectionTitle('Your Activity'),
            _tile(icon: Icons.bookmark_border, title: 'Saved', onTap: () {}),
            _tile(
              icon: Icons.groups_outlined,
              title: 'Community activities',
              onTap: () {},
            ),

            const SizedBox(height: 4),
            _sectionTitle('General'),
            _tile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────── USER CARD ─────────────────

  Widget _userCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            height: 72,
            width: 72,
            child: const CircleAvatar(
              radius: 26,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UserName',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGreenish,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'UserName@gmail.com',
                  style: TextStyle(color: AppColors.darkGrey),
                ),
                SizedBox(height: 2),
                Text('3 Farms', style: TextStyle(color: AppColors.darkGrey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.critical),
            onPressed: () async {
              await SessionManager.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ───────────────── SECTION TITLE ─────────────────

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: _sectionColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ───────────────── TILE ─────────────────

  Widget _tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _tileBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.darkGreenish),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.darkGreenish,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
