import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/MFA Auth/biometric_auth_service.dart';
import '../../services/MFA Auth/activity_log_service.dart';
import '../../services/MFA Auth/security_settings_service.dart';
import '../main_screen.dart';
import '../privacy/change_password_card.dart';
import '../privacy/two_factor_auth_screen.dart';
import '../privacy/activity_log_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/privacy/security_header.dart';
import '../widgets/privacy/security_option_tile.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({
    super.key,
  });

  @override
  State<PrivacySecurityScreen> createState() =>
      _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState
    extends State<PrivacySecurityScreen> {
  final SecuritySettingsService _securityService =
      SecuritySettingsService();
  final BiometricAuthService _biometricService =
      BiometricAuthService();
  final ActivityLogService _activityLogService =
    ActivityLogService();

  bool twoFactorAuth = false;
  bool biometricLogin = false;
  bool activityLog = false;
  bool dataSharing = false;

  bool _isLoadingSettings = true;

  final int selectedIndex = 4;

  @override
  void initState() {
    super.initState();
    _loadSecuritySettings();
  }

  Future<void> _loadSecuritySettings() async {
    try {
      final Map<String, dynamic> settings =
          await _securityService.getSettings();

      if (!mounted) {
        return;
      }

      setState(() {
        twoFactorAuth =
            settings['two_factor_enabled']
                    as bool? ??
                false;

        biometricLogin =
            settings['biometric_enabled']
                    as bool? ??
                false;

        activityLog =
            settings['activity_log_enabled']
                    as bool? ??
                false;

        dataSharing =
            settings['data_sharing_enabled']
                    as bool? ??
                false;

        _isLoadingSettings = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingSettings = false;
      });

      _showMessage(
        error
            .toString()
            .replaceFirst(
              'Exception: ',
              '',
            ),
      );
    }
  }

  Future<void> _openTwoFactorAuthScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const TwoFactorAuthScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoadingSettings = true;
    });

    await _loadSecuritySettings();
  }

  Future<void> _changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final SupabaseClient supabase =
        Supabase.instance.client;

    final User? currentUser =
        supabase.auth.currentUser;

    final String? email =
        currentUser?.email;

    if (currentUser == null ||
        email == null) {
      throw Exception(
        'Your session has expired. Please log in again.',
      );
    }

    if (currentPassword.isEmpty) {
      throw Exception(
        'Please enter your current password.',
      );
    }

    if (newPassword.isEmpty) {
      throw Exception(
        'Please enter a new password.',
      );
    }

    if (currentPassword == newPassword) {
      throw Exception(
        'The new password must be different from your current password.',
      );
    }

    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: currentPassword,
      );

      await supabase.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
    } on AuthException catch (error) {
      final String errorMessage =
          error.message.toLowerCase();

      if (errorMessage.contains(
            'invalid login credentials',
          ) ||
          errorMessage.contains(
            'invalid credentials',
          )) {
        throw Exception(
          'Your current password is incorrect.',
        );
      }

      throw Exception(
        error.message,
      );
    } catch (error) {
      if (error is Exception) {
        rethrow;
      }

      throw Exception(
        'Unable to update your password. Please try again.',
      );
    }
  }

  Future<void> _updateBiometric(
    bool value,
  ) async {
    final bool previousValue =
        biometricLogin;

    if (!value) {
      setState(() {
        biometricLogin = false;
      });

      try {
        await _securityService.updateBiometric(
          false,
        );

        _showMessage(
          'Biometric login disabled.',
        );
      } catch (_) {
        if (!mounted) {
          return;
        }

        setState(() {
          biometricLogin =
              previousValue;
        });

        _showMessage(
          'Unable to disable biometric login.',
        );
      }

      return;
    }

    try {
      final bool available =
          await _biometricService
              .isBiometricAvailable();

      if (!available) {
        if (!mounted) {
          return;
        }

        setState(() {
          biometricLogin =
              previousValue;
        });

        _showMessage(
          'Face ID or fingerprint is not available on this device.',
        );
        return;
      }

      final bool authenticated =
          await _biometricService.authenticate();

      if (!authenticated) {
        if (!mounted) {
          return;
        }

        setState(() {
          biometricLogin =
              previousValue;
        });

        _showMessage(
          'Biometric authentication was cancelled.',
        );
        return;
      }

      await _securityService.updateBiometric(
        true,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        biometricLogin = true;
      });

      _showMessage(
        'Biometric login enabled successfully.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        biometricLogin =
            previousValue;
      });

      _showMessage(
        error
            .toString()
            .replaceFirst(
              'Exception: ',
              '',
            ),
      );
    }
  }

  Future<void> _updateActivityLog(
  bool value,
) async {
  final bool previousValue =
      activityLog;

  setState(() {
    activityLog = value;
  });

  try {
    await _securityService.updateActivityLog(
      value,
    );

    if (value) {
      debugPrint('Calling addActivity...');

await _activityLogService.addActivity(
  action: 'Test Activity',
  description: 'Testing Activity Log',
  iconName: 'history',
);

debugPrint('Finished addActivity');
    }

    if (!mounted) {
      return;
    }

    _showMessage(
      value
          ? 'Activity log enabled.'
          : 'Activity log disabled.',
    );
  } catch (error) {
    if (!mounted) {
      return;
    }

    setState(() {
      activityLog =
          previousValue;
    });

    _showMessage(
      error
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          ),
    );
  }
}

  Future<void> _openActivityLog() async {
    if (!mounted) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ActivityLogScreen(),
      ),
    );
  }

  Future<void> _updateDataSharing(
    bool value,
  ) async {
    final bool previousValue =
        dataSharing;

    setState(() {
      dataSharing = value;
    });

    try {
      await _securityService.updateDataSharing(
        value,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        dataSharing =
            previousValue;
      });

      _showMessage(
        'Unable to save data sharing setting.',
      );
    }
  }

  void _showMessage(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        duration: const Duration(
          milliseconds: 1500,
        ),
        backgroundColor:
            colorScheme.primary,
      ),
    );
  }

  void _handleBottomNavTap(
    int index,
  ) {
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
  Widget build(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: _handleBottomNavTap,
      ),
      body: SafeArea(
        child: _isLoadingSettings
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const SecurityHeader(),

                    const SizedBox(
                      height: 24,
                    ),

                    ChangePasswordCard(
                      onUpdatePassword:
                          _changePassword,
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    SecurityOptionTile(
                      icon:
                          Icons.shield_outlined,
                      iconColor:
                          Colors.deepPurpleAccent,
                      title:
                          'Two-Factor Auth',
                      subtitle:
                          twoFactorAuth
                              ? 'Email verification enabled'
                              : 'Verify using email OTP',
                      trailing: _buildSwitch(
                        value:
                            twoFactorAuth,
                        onChanged: (_) {
                          _openTwoFactorAuthScreen();
                        },
                      ),
                      onTap: () {
                        _openTwoFactorAuthScreen();
                      },
                    ),

                    SecurityOptionTile(
                      icon:
                          Icons.fingerprint,
                      iconColor:
                          Colors.cyanAccent,
                      title:
                          'Biometric Login',
                      subtitle:
                          'Face ID / Fingerprint',
                      trailing: _buildSwitch(
                        value:
                            biometricLogin,
                        onChanged:
                            _updateBiometric,
                      ),
                      onTap: () {
                        _updateBiometric(
                          !biometricLogin,
                        );
                      },
                    ),

                    SecurityOptionTile(
                       icon: Icons.history,
                         iconColor: Colors.amber,
                          title: 'Activity Log',
                          subtitle: activityLog
                           ? 'View your account activity'
                           : 'Activity tracking is disabled',
                             trailing: _buildSwitch(
                              value: activityLog,
                             onChanged: _updateActivityLog,
                             ),
                               onTap: _openActivityLog,
                             ),

                    SecurityOptionTile(
                      icon: Icons
                          .privacy_tip_outlined,
                      iconColor:
                          Colors.pinkAccent,
                      title:
                          'Data Sharing',
                      subtitle:
                          'Share analytics with us',
                      trailing: _buildSwitch(
                        value:
                            dataSharing,
                        onChanged:
                            _updateDataSharing,
                      ),
                      onTap: () {
                        _updateDataSharing(
                          !dataSharing,
                        );
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
    required ValueChanged<bool>
        onChanged,
  }) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor:
          Colors.white,
      activeTrackColor:
          colorScheme.primary,
      inactiveThumbColor:
          colorScheme
              .onSurfaceVariant,
      inactiveTrackColor:
          colorScheme.outlineVariant
              .withValues(
            alpha: 0.9,
          ),
    );
  }
}