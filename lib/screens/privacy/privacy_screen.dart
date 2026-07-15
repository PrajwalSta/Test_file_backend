import 'package:flutter/material.dart';

import '../main_screen.dart';
import '../privacy/change_password_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/privacy/security_header.dart';
import '../widgets/privacy/security_option_tile.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() =>
      _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState
    extends State<PrivacySecurityScreen> {
  bool twoFactorAuth = true;
  bool biometricLogin = true;
  bool activityLog = false;
  bool dataSharing = false;

  final int selectedIndex = 4;

  void _showMessage(String message) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 700),
        backgroundColor: colorScheme.primary,
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => MainScreen(
          initialIndex: index,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: _handleBottomNavTap,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SecurityHeader(),

              const SizedBox(height: 24),

              ChangePasswordCard(
                onUpdatePassword: (
                  currentPassword,
                  newPassword,
                ) async {
                  await Future.delayed(
                    const Duration(seconds: 1),
                  );

                  if (!mounted) return;

                  _showMessage(
                    "Password updated successfully",
                  );
                },
              ),

              const SizedBox(height: 14),

              SecurityOptionTile(
                icon: Icons.shield_outlined,
                iconColor: Colors.deepPurpleAccent,
                title: "Two-Factor Auth",
                subtitle: "Extra login security",
                trailing: _buildSwitch(
                  value: twoFactorAuth,
                  onChanged: (value) {
                    setState(() {
                      twoFactorAuth = value;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    twoFactorAuth = !twoFactorAuth;
                  });
                },
              ),

              SecurityOptionTile(
                icon: Icons.fingerprint,
                iconColor: Colors.cyanAccent,
                title: "Biometric Login",
                subtitle: "Face ID / Fingerprint",
                trailing: _buildSwitch(
                  value: biometricLogin,
                  onChanged: (value) {
                    setState(() {
                      biometricLogin = value;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    biometricLogin = !biometricLogin;
                  });
                },
              ),

              SecurityOptionTile(
                icon: Icons.history,
                iconColor: Colors.amber,
                title: "Activity Log",
                subtitle: "Track your sessions",
                trailing: _buildSwitch(
                  value: activityLog,
                  onChanged: (value) {
                    setState(() {
                      activityLog = value;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    activityLog = !activityLog;
                  });
                },
              ),

              SecurityOptionTile(
                icon: Icons.privacy_tip_outlined,
                iconColor: Colors.pinkAccent,
                title: "Data Sharing",
                subtitle: "Share analytics with us",
                trailing: _buildSwitch(
                  value: dataSharing,
                  onChanged: (value) {
                    setState(() {
                      dataSharing = value;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    dataSharing = !dataSharing;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.white,
      activeTrackColor: colorScheme.primary,
      inactiveThumbColor: colorScheme.onSurfaceVariant,
      inactiveTrackColor:
          colorScheme.outlineVariant.withValues(alpha: 0.9),
    );
  }
}