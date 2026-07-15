import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 118,
      height: 118,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 35,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.bolt_rounded,
          size: 62,
          color: AppColors.primaryLight,
        ),
      ),
    );
  }
}