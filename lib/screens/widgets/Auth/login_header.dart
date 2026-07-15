import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          "Welcome Back",
          style: AppTextStyles.heading,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          "Login to continue your focus journey",
          style: AppTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}