import 'package:flutter/material.dart';

import '../../../routes/auth_service.dart';
import 'social_login_button.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialLoginButton(
          icon: Icons.g_mobiledata_rounded,
          onTap: authService.loginWithGoogle,
        ),
        const SizedBox(width: 22),
        SocialLoginButton(
          icon: Icons.apple,
          onTap: authService.loginWithApple,
        ),
        const SizedBox(width: 22),
        SocialLoginButton(
          icon: Icons.facebook,
          onTap: authService.loginWithFacebook,
        ),
      ],
    );
  }
}