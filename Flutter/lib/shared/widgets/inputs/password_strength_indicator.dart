import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  PasswordStrength _getStrength() {
    if (password.isEmpty) return PasswordStrength.none;

    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final strength = _getStrength();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: strength.index >= 1
                      ? strength.color
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: strength.index >= 2
                      ? strength.color
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: strength.index >= 3
                      ? strength.color
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          strength.label,
          style: TextStyle(
            fontSize: 12,
            color: strength.color,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _buildRequirements(),
      ],
    );
  }

  Widget _buildRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequirement('At least 8 characters', password.length >= 8),
        _buildRequirement(
          'Contains uppercase letter',
          RegExp(r'[A-Z]').hasMatch(password),
        ),
        _buildRequirement(
          'Contains lowercase letter',
          RegExp(r'[a-z]').hasMatch(password),
        ),
        _buildRequirement(
          'Contains number',
          RegExp(r'[0-9]').hasMatch(password),
        ),
      ],
    );
  }

  Widget _buildRequirement(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: met ? AppColors.primaryColor : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: met ? AppColors.primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

enum PasswordStrength {
  none('', Colors.grey),
  weak('Weak password', Colors.red),
  medium('Medium password', Colors.orange),
  strong('Strong password', Colors.green);

  final String label;
  final Color color;
  const PasswordStrength(this.label, this.color);
}
