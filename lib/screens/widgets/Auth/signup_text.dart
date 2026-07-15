import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';

class SignupText extends StatelessWidget {
  final VoidCallback onTap;

  const SignupText({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        const Text(
          "Don’t have an account? ",
          style: AppTextStyles.small,
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            "Sign Up",
            style: AppTextStyles.link,
          ),
        ),
      ],
    );
  }
}