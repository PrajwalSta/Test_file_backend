import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../../services/MFA Auth/activity_log_service.dart';
import '../../services/MFA Auth/biometric_auth_service.dart';
import '../../services/MFA Auth/biometric_setting_service.dart';
import '../../services/MFA Auth/security_settings_service.dart';
import '../main_screen.dart';
import '../privacy/activity_log_screen.dart';
import '../privacy/change_password_card.dart';
import '../privacy/two_factor_auth_screen.dart';
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
      BiometricAuthService.instance;

  final BiometricSettingService
      _biometricSettingService =
      BiometricSettingService.instance;

  final ActivityLogService _activityLogService =
      ActivityLogService();

  bool twoFactorAuth = false;
  bool biometricLogin = false;
  bool activityLog = false;
  bool dataSharing = false;

  bool _isLoadingSettings = true;
  bool _isUpdatingBiometric = false;
  bool _isOpeningTwoFactor = false;

  bool _biometricAvailable = false;
  bool _faceIdAvailable = false;
  bool _fingerprintAvailable = false;

  final int selectedIndex = 4;

  AppLocalizations get _localizations =>
      AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  // ==========================================================
  // INITIALIZE SCREEN
  // ==========================================================
  Future<void> _initializeScreen() async {
    await _loadSecuritySettings();
    await _checkBiometricAvailability();
  }

  // ==========================================================
  // LOAD SECURITY SETTINGS
  // ==========================================================
  Future<void> _loadSecuritySettings() async {
    try {
      final Map<String, dynamic> settings =
          await _securityService.getSettings();

      final bool supabaseBiometricEnabled =
          settings['biometric_enabled']
                  as bool? ??
              false;

      final bool localBiometricEnabled =
          await _biometricSettingService
              .isEnabled();

      /*
       * Supabase stores the account setting.
       * SharedPreferences stores the setting for
       * the current device.
       *
       * Both must be enabled for biometric login
       * to work on this device.
       */
      final bool biometricEnabled =
          supabaseBiometricEnabled &&
              localBiometricEnabled;

      /*
       * Synchronize inconsistent settings.
       */
      if (supabaseBiometricEnabled !=
          biometricEnabled) {
        await _securityService.updateBiometric(
          biometricEnabled,
        );
      }

      if (localBiometricEnabled !=
          biometricEnabled) {
        await _biometricSettingService.setEnabled(
          biometricEnabled,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        twoFactorAuth =
            settings['two_factor_enabled']
                    as bool? ??
                false;

        biometricLogin =
            biometricEnabled;

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
    } catch (error, stackTrace) {
      debugPrint(
        'Unable to load security settings: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingSettings = false;
      });

      _showMessage(
        _localizations
            .unableToLoadSecuritySettings,
      );
    }
  }

  // ==========================================================
  // CHECK FACE ID / FINGERPRINT
  // ==========================================================
  Future<void> _checkBiometricAvailability() async {
    try {
      final bool available =
          await _biometricService
              .isBiometricAvailable();

      final List<BiometricType> biometrics =
          await _biometricService
              .getAvailableBiometrics();

      final bool hasFaceId =
          biometrics.contains(
        BiometricType.face,
      );

      final bool hasFingerprint =
          biometrics.contains(
                BiometricType.fingerprint,
              ) ||
              biometrics.contains(
                BiometricType.strong,
              ) ||
              biometrics.contains(
                BiometricType.weak,
              );

      if (!mounted) {
        return;
      }

      setState(() {
        _biometricAvailable = available;
        _faceIdAvailable = hasFaceId;
        _fingerprintAvailable =
            hasFingerprint;
      });

      /*
       * Disable biometric login if the user
       * removed Face ID or fingerprint from
       * the device settings.
       */
      if (biometricLogin && !available) {
        await Future.wait([
          _securityService.updateBiometric(
            false,
          ),
          _biometricSettingService.setEnabled(
            false,
          ),
        ]);

        if (!mounted) {
          return;
        }

        setState(() {
          biometricLogin = false;
        });
      }
    } catch (error, stackTrace) {
      debugPrint(
        'Biometric availability error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _biometricAvailable = false;
        _faceIdAvailable = false;
        _fingerprintAvailable = false;
      });
    }
  }

  // ==========================================================
  // BIOMETRIC DISPLAY TEXT
  // ==========================================================
  String get _biometricTitle {
    if (_faceIdAvailable) {
      return _localizations.faceIdLogin;
    }

    if (_fingerprintAvailable) {
      return _localizations.fingerprintLogin;
    }

    return _localizations.biometricLogin;
  }

  String get _biometricSubtitle {
    if (_isUpdatingBiometric) {
      return _localizations
          .checkingAuthentication;
    }

    if (_faceIdAvailable) {
      return biometricLogin
          ? _localizations.faceIdLoginEnabled
          : _localizations.unlockUsingFaceId;
    }

    if (_fingerprintAvailable) {
      return biometricLogin
          ? _localizations
              .fingerprintLoginEnabled
          : _localizations
              .unlockUsingFingerprint;
    }

    if (!_biometricAvailable) {
      return _localizations
          .biometricUnavailable;
    }

    return _localizations
        .faceIdOrFingerprint;
  }

  IconData get _biometricIcon {
    if (_faceIdAvailable) {
      return Icons.face_rounded;
    }

    return Icons.fingerprint_rounded;
  }

  String get _authenticationName {
    if (_faceIdAvailable) {
      return _localizations.faceId;
    }

    if (_fingerprintAvailable) {
      return _localizations.fingerprint;
    }

    return _localizations.biometric;
  }

  // ==========================================================
  // OPEN TWO-FACTOR AUTHENTICATION SCREEN
  // ==========================================================
  Future<void> _openTwoFactorAuthScreen() async {
    if (_isOpeningTwoFactor) {
      return;
    }

    setState(() {
      _isOpeningTwoFactor = true;
    });

    try {
      final bool? result =
          await Navigator.push<bool>(
        context,
        MaterialPageRoute<bool>(
          builder: (
            BuildContext context,
          ) {
            return const TwoFactorAuthScreen();
          },
        ),
      );

      if (!mounted || result == null) {
        return;
      }

      setState(() {
        twoFactorAuth = result;
      });

      _showMessage(
        result
            ? _localizations
                .emailVerificationEnabledSuccessfully
            : _localizations
                .emailVerificationDisabled,
      );

      if (activityLog) {
        try {
          await _activityLogService.addActivity(
            action: result
                ? 'Email Verification Enabled'
                : 'Email Verification Disabled',
            description: result
                ? 'Email OTP verification was enabled.'
                : 'Email OTP verification was disabled.',
            iconName: 'security',
          );
        } catch (error) {
          debugPrint(
            'Unable to save email verification activity: '
            '$error',
          );
        }
      }
    } catch (error, stackTrace) {
      debugPrint(
        'Unable to open email verification: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        _localizations
            .unableToOpenEmailVerification,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningTwoFactor = false;
        });
      }
    }
  }

  // ==========================================================
  // CHANGE PASSWORD
  // ==========================================================
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
        email == null ||
        email.isEmpty) {
      throw Exception(
        _localizations.sessionExpiredLoginAgain,
      );
    }

    if (currentPassword.isEmpty) {
      throw Exception(
        _localizations
            .enterCurrentPassword,
      );
    }

    if (newPassword.isEmpty) {
      throw Exception(
        _localizations.enterNewPassword,
      );
    }

    if (currentPassword == newPassword) {
      throw Exception(
        _localizations
            .newPasswordMustBeDifferent,
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

      if (activityLog) {
        try {
          await _activityLogService.addActivity(
            action: 'Password Changed',
            description:
                'The account password was changed.',
            iconName: 'lock',
          );
        } catch (error) {
          debugPrint(
            'Unable to save password activity: '
            '$error',
          );
        }
      }
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
          _localizations
              .currentPasswordIncorrect,
        );
      }

      debugPrint(
        'Unable to change password: '
        '${error.message}',
      );

      throw Exception(
        _localizations
            .unableToUpdatePassword,
      );
    } catch (error) {
      if (error is Exception) {
        rethrow;
      }

      throw Exception(
        _localizations
            .unableToUpdatePassword,
      );
    }
  }

  // ==========================================================
  // ENABLE OR DISABLE BIOMETRIC LOGIN
  // ==========================================================
  Future<void> _updateBiometric(
    bool value,
  ) async {
    if (_isUpdatingBiometric) {
      return;
    }

    final bool previousValue =
        biometricLogin;

    setState(() {
      _isUpdatingBiometric = true;
    });

    try {
      // ------------------------------------------------------
      // DISABLE BIOMETRIC LOGIN
      // ------------------------------------------------------
      if (!value) {
        await Future.wait([
          _securityService.updateBiometric(
            false,
          ),
          _biometricSettingService.setEnabled(
            false,
          ),
        ]);

        if (!mounted) {
          return;
        }

        setState(() {
          biometricLogin = false;
        });

        final String authenticationName =
            _authenticationName;

        _showMessage(
          _localizations.biometricLoginDisabled(
            authenticationName,
          ),
        );

        if (activityLog) {
          try {
            await _activityLogService.addActivity(
              action:
                  'Biometric Login Disabled',
              description:
                  '$authenticationName login was disabled.',
              iconName: 'fingerprint',
            );
          } catch (error) {
            debugPrint(
              'Unable to save biometric activity: '
              '$error',
            );
          }
        }

        return;
      }

      // ------------------------------------------------------
      // REQUIRE ACTIVE SUPABASE SESSION
      // ------------------------------------------------------
      final Session? session =
          Supabase.instance.client.auth
              .currentSession;

      if (session == null) {
        throw Exception(
          _localizations
              .sessionExpiredBeforeBiometric,
        );
      }

      // ------------------------------------------------------
      // CHECK DEVICE BIOMETRIC SUPPORT
      // ------------------------------------------------------
      final bool available =
          await _biometricService
              .isBiometricAvailable();

      if (!available) {
        throw Exception(
          _localizations
              .configureBiometricsFirst,
        );
      }

      final List<BiometricType> biometrics =
          await _biometricService
              .getAvailableBiometrics();

      if (biometrics.isEmpty) {
        throw Exception(
          _localizations
              .noBiometricAuthenticationEnrolled,
        );
      }

      // ------------------------------------------------------
      // VERIFY BIOMETRICS BEFORE ENABLING
      // ------------------------------------------------------
      final bool authenticated =
          await _biometricService
              .authenticateForBiometricSetup();

      if (!authenticated) {
        throw Exception(
          _localizations
              .biometricVerificationFailed,
        );
      }

      // ------------------------------------------------------
      // SAVE SETTING IN SUPABASE AND LOCAL STORAGE
      // ------------------------------------------------------
      await Future.wait([
        _securityService.updateBiometric(
          true,
        ),
        _biometricSettingService.setEnabled(
          true,
        ),
      ]);

      /*
       * Keep the service value for internal
       * activity logging, but show a localized
       * biometric name to the user.
       */
      final String serviceAuthenticationName =
          await _biometricService
              .getBiometricName();

      final bool hasFaceId =
          biometrics.contains(
        BiometricType.face,
      );

      final bool hasFingerprint =
          biometrics.contains(
                BiometricType.fingerprint,
              ) ||
              biometrics.contains(
                BiometricType.strong,
              ) ||
              biometrics.contains(
                BiometricType.weak,
              );

      if (!mounted) {
        return;
      }

      setState(() {
        biometricLogin = true;
        _biometricAvailable = true;
        _faceIdAvailable = hasFaceId;
        _fingerprintAvailable =
            hasFingerprint;
      });

      final String localizedAuthenticationName =
          hasFaceId
              ? _localizations.faceId
              : hasFingerprint
                  ? _localizations.fingerprint
                  : _localizations.biometric;

      _showMessage(
        _localizations.biometricLoginEnabled(
          localizedAuthenticationName,
        ),
      );

      if (activityLog) {
        try {
          await _activityLogService.addActivity(
            action:
                'Biometric Login Enabled',
            description:
                '$serviceAuthenticationName login was enabled.',
            iconName: 'fingerprint',
          );
        } catch (error) {
          debugPrint(
            'Unable to save biometric activity: '
            '$error',
          );
        }
      }
    } catch (error, stackTrace) {
      debugPrint(
        'Unable to update biometric login: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      /*
       * Restore both settings if the update failed.
       */
      try {
        await Future.wait([
          _securityService.updateBiometric(
            previousValue,
          ),
          _biometricSettingService.setEnabled(
            previousValue,
          ),
        ]);
      } catch (restoreError) {
        debugPrint(
          'Unable to restore biometric setting: '
          '$restoreError',
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        biometricLogin = previousValue;
      });

      _showMessage(
        _cleanLocalizedError(
          error,
          fallback: _localizations
              .unableToUpdateBiometricLogin,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingBiometric = false;
        });
      }
    }
  }

  // ==========================================================
  // UPDATE ACTIVITY LOG
  // ==========================================================
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
        await _activityLogService.addActivity(
          action: 'Activity Log Enabled',
          description:
              'Account activity tracking was enabled.',
          iconName: 'history',
        );
      }

      if (!mounted) {
        return;
      }

      _showMessage(
        value
            ? _localizations
                .activityLogEnabledMessage
            : _localizations
                .activityLogDisabledMessage,
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Unable to update activity log: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        activityLog = previousValue;
      });

      _showMessage(
        _localizations
            .unableToUpdateActivityLog,
      );
    }
  }

  // ==========================================================
  // OPEN ACTIVITY LOG
  // ==========================================================
  Future<void> _openActivityLog() async {
    if (!mounted) {
      return;
    }

    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (
          BuildContext context,
        ) {
          return const ActivityLogScreen();
        },
      ),
    );
  }

  // ==========================================================
  // UPDATE DATA SHARING
  // ==========================================================
  Future<void> _updateDataSharing(
    bool value,
  ) async {
    final bool previousValue =
        dataSharing;

    setState(() {
      dataSharing = value;
    });

    try {
      await _securityService
          .updateDataSharing(value);

      if (!mounted) {
        return;
      }

      _showMessage(
        value
            ? _localizations
                .dataSharingEnabledMessage
            : _localizations
                .dataSharingDisabledMessage,
      );

      if (activityLog) {
        try {
          await _activityLogService.addActivity(
            action: value
                ? 'Data Sharing Enabled'
                : 'Data Sharing Disabled',
            description: value
                ? 'Analytics data sharing was enabled.'
                : 'Analytics data sharing was disabled.',
            iconName: 'privacy',
          );
        } catch (error) {
          debugPrint(
            'Unable to save data sharing activity: '
            '$error',
          );
        }
      }
    } catch (error, stackTrace) {
      debugPrint(
        'Unable to update data sharing: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        dataSharing = previousValue;
      });

      _showMessage(
        _localizations
            .unableToUpdateDataSharing,
      );
    }
  }

  // ==========================================================
  // CLEAN LOCALIZED ERROR
  // ==========================================================
  String _cleanLocalizedError(
    Object error, {
    required String fallback,
  }) {
    final String message = error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        )
        .trim();

    if (message.isEmpty) {
      return fallback;
    }

    return message;
  }

  // ==========================================================
  // SHOW MESSAGE
  // ==========================================================
  void _showMessage(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    final ScaffoldMessengerState messenger =
        ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        duration: const Duration(
          milliseconds: 2000,
        ),
        behavior:
            SnackBarBehavior.floating,
        backgroundColor:
            colorScheme.primary,
      ),
    );
  }

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================
  void _handleBottomNavTap(
    int index,
  ) {
    if (index == selectedIndex) {
      Navigator.pop(context);
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (
          BuildContext context,
        ) {
          return MainScreen(
            initialIndex: index,
          );
        },
      ),
      (
        Route<dynamic> route,
      ) {
        return false;
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: _handleBottomNavTap,
      ),
      body: SafeArea(
        child: _isLoadingSettings
            ? Center(
                child:
                    CircularProgressIndicator(
                  color: theme
                      .colorScheme.primary,
                ),
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

                    // ------------------------------------------
                    // TWO-FACTOR AUTHENTICATION
                    // ------------------------------------------
                    SecurityOptionTile(
                      icon:
                          Icons.shield_outlined,
                      iconColor:
                          Colors.deepPurpleAccent,
                      title: localizations
                          .twoFactorAuth,
                      subtitle:
                          _isOpeningTwoFactor
                              ? localizations
                                  .openingEmailVerification
                              : twoFactorAuth
                                  ? localizations
                                      .emailVerificationEnabled
                                  : localizations
                                      .verifyUsingEmailOtp,
                      trailing:
                          _isOpeningTwoFactor
                              ? const SizedBox(
                                  width: 30,
                                  height: 30,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth:
                                        2.5,
                                  ),
                                )
                              : _buildSwitch(
                                  value:
                                      twoFactorAuth,
                                  onChanged:
                                      (_) async {
                                    await _openTwoFactorAuthScreen();
                                  },
                                ),
                      onTap:
                          _isOpeningTwoFactor
                              ? null
                              : _openTwoFactorAuthScreen,
                    ),

                    // ------------------------------------------
                    // FACE ID / BIOMETRIC LOGIN
                    // ------------------------------------------
                    SecurityOptionTile(
                      icon:
                          _biometricIcon,
                      iconColor:
                          Colors.cyanAccent,
                      title:
                          _biometricTitle,
                      subtitle:
                          _biometricSubtitle,
                      trailing:
                          _isUpdatingBiometric
                              ? const SizedBox(
                                  width: 30,
                                  height: 30,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth:
                                        2.5,
                                  ),
                                )
                              : _buildSwitch(
                                  value:
                                      biometricLogin,
                                  onChanged:
                                      !_biometricAvailable &&
                                              !biometricLogin
                                          ? null
                                          : _updateBiometric,
                                ),
                      onTap:
                          _isUpdatingBiometric ||
                                  (!_biometricAvailable &&
                                      !biometricLogin)
                              ? null
                              : () {
                                  _updateBiometric(
                                    !biometricLogin,
                                  );
                                },
                    ),

                    // ------------------------------------------
                    // ACTIVITY LOG
                    // ------------------------------------------
                    SecurityOptionTile(
                      icon:
                          Icons.history,
                      iconColor:
                          Colors.amber,
                      title: localizations
                          .activityLog,
                      subtitle:
                          activityLog
                              ? localizations
                                  .viewAccountActivity
                              : localizations
                                  .activityTrackingDisabled,
                      trailing:
                          _buildSwitch(
                        value:
                            activityLog,
                        onChanged:
                            _updateActivityLog,
                      ),
                      onTap:
                          _openActivityLog,
                    ),

                    // ------------------------------------------
                    // DATA SHARING
                    // ------------------------------------------
                    SecurityOptionTile(
                      icon:
                          Icons.privacy_tip_outlined,
                      iconColor:
                          Colors.pinkAccent,
                      title: localizations
                          .dataSharing,
                      subtitle:
                          dataSharing
                              ? localizations
                                  .analyticsSharingEnabled
                              : localizations
                                  .shareAnalyticsWithUs,
                      trailing:
                          _buildSwitch(
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

  // ==========================================================
  // CUSTOM SWITCH
  // ==========================================================
  Widget _buildSwitch({
    required bool value,
    ValueChanged<bool>? onChanged,
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
          colorScheme.onSurfaceVariant,
      inactiveTrackColor:
          colorScheme.outlineVariant
              .withValues(
            alpha: 0.9,
          ),
    );
  }
}