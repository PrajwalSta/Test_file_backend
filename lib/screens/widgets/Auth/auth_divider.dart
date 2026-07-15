import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.18))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "OR Continue with",
            style: TextStyle(color: AppColors.textGrey),
          ),
        ),
        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.18))),
      ],
    );
  }
}