import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSmallScreen;

  const AuthHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(14),
          child: Icon(icon, color: AppColors.primary, size: isSmallScreen ? 28 : 34),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: AppTextStyles.heading,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: AppTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
