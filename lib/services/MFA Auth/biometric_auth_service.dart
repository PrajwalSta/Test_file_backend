import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  BiometricAuthService._();

  static final BiometricAuthService instance =
      BiometricAuthService._();

  final LocalAuthentication _localAuth =
      LocalAuthentication();

  // ==========================================================
  // CHECK PLATFORM SUPPORT
  // ==========================================================
  bool get isSupportedPlatform {
    if (kIsWeb) {
      return false;
    }

    return Platform.isIOS ||
        Platform.isAndroid ||
        Platform.isMacOS ||
        Platform.isWindows;
  }

  // ==========================================================
  // CHECK DEVICE BIOMETRIC SUPPORT
  // ==========================================================
  Future<bool> isBiometricAvailable() async {
    if (!isSupportedPlatform) {
      return false;
    }

    try {
      final bool isDeviceSupported =
          await _localAuth.isDeviceSupported();

      if (!isDeviceSupported) {
        return false;
      }

      final bool canCheckBiometrics =
          await _localAuth.canCheckBiometrics;

      if (!canCheckBiometrics) {
        return false;
      }

      final List<BiometricType> biometrics =
          await getAvailableBiometrics();

      return biometrics.isNotEmpty;
    } on PlatformException catch (error) {
      debugPrint(
        'Biometric availability error: '
        '${error.code} - ${error.message}',
      );

      return false;
    } catch (error, stackTrace) {
      debugPrint(
        'Unexpected biometric availability error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  // ==========================================================
  // GET AVAILABLE BIOMETRICS
  // ==========================================================
  Future<List<BiometricType>>
      getAvailableBiometrics() async {
    if (!isSupportedPlatform) {
      return <BiometricType>[];
    }

    try {
      final List<BiometricType> biometrics =
          await _localAuth
              .getAvailableBiometrics();

      debugPrint(
        'Available biometrics: $biometrics',
      );

      return biometrics;
    } on PlatformException catch (error) {
      debugPrint(
        'Get biometric types error: '
        '${error.code} - ${error.message}',
      );

      return <BiometricType>[];
    } catch (error, stackTrace) {
      debugPrint(
        'Unexpected biometric types error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      return <BiometricType>[];
    }
  }

  // ==========================================================
  // CHECK FACE ID
  // ==========================================================
  Future<bool> hasFaceId() async {
    final List<BiometricType> biometrics =
        await getAvailableBiometrics();

    return biometrics.contains(
      BiometricType.face,
    );
  }

  // ==========================================================
  // CHECK FINGERPRINT / TOUCH ID
  // ==========================================================
  Future<bool> hasFingerprint() async {
    final List<BiometricType> biometrics =
        await getAvailableBiometrics();

    return biometrics.contains(
          BiometricType.fingerprint,
        ) ||
        biometrics.contains(
          BiometricType.strong,
        ) ||
        biometrics.contains(
          BiometricType.weak,
        );
  }

  // ==========================================================
  // GET DISPLAY NAME
  // ==========================================================
  Future<String> getBiometricName() async {
    final List<BiometricType> biometrics =
        await getAvailableBiometrics();

    if (biometrics.contains(
      BiometricType.face,
    )) {
      return Platform.isIOS
          ? 'Face ID'
          : 'Face Recognition';
    }

    if (biometrics.contains(
          BiometricType.fingerprint,
        ) ||
        biometrics.contains(
          BiometricType.strong,
        ) ||
        biometrics.contains(
          BiometricType.weak,
        )) {
      if (Platform.isMacOS ||
          Platform.isIOS) {
        return 'Touch ID';
      }

      return 'Fingerprint';
    }

    return 'Biometric Login';
  }

  // ==========================================================
  // GET BIOMETRIC ICON
  // ==========================================================
  Future<String> getBiometricDescription() async {
    final String name =
        await getBiometricName();

    switch (name) {
      case 'Face ID':
        return 'Use Face ID to access Focus Glow';

      case 'Touch ID':
        return 'Use Touch ID to access Focus Glow';

      case 'Fingerprint':
        return 'Use your fingerprint to access Focus Glow';

      case 'Face Recognition':
        return 'Use face recognition to access Focus Glow';

      default:
        return 'Use biometrics to access Focus Glow';
    }
  }

  // ==========================================================
  // AUTHENTICATE USER
  // ==========================================================
  Future<bool> authenticate({
    String? reason,
  }) async {
    if (!isSupportedPlatform) {
      throw Exception(
        'Biometric authentication is not supported on this platform.',
      );
    }

    try {
      final bool supported =
          await _localAuth.isDeviceSupported();

      if (!supported) {
        throw Exception(
          'This device does not support biometric authentication.',
        );
      }

      final bool canCheckBiometrics =
          await _localAuth.canCheckBiometrics;

      if (!canCheckBiometrics) {
        throw Exception(
          'Biometric authentication is not available on this device.',
        );
      }

      final List<BiometricType> biometrics =
          await getAvailableBiometrics();

      if (biometrics.isEmpty) {
        throw Exception(
          Platform.isIOS
              ? 'Face ID or Touch ID is not enrolled. '
                  'Configure it in iPhone Settings.'
              : 'No biometric authentication is enrolled. '
                  'Configure biometrics in device settings.',
        );
      }

      final String authenticationReason =
          reason ??
              await getBiometricDescription();

      final bool authenticated =
          await _localAuth.authenticate(
        localizedReason:
            authenticationReason,
        options:
            const AuthenticationOptions(
          biometricOnly: true,

          /*
           * Keeps authentication active when the
           * app briefly moves to the background.
           */
          stickyAuth: true,

          /*
           * Displays system error dialogs when
           * biometric authentication is unavailable.
           */
          useErrorDialogs: true,

          /*
           * Prevents Android from displaying a
           * confirmation button after successful
           * passive biometric authentication.
           */
          sensitiveTransaction: true,
        ),
      );

      debugPrint(
        'Biometric authentication result: '
        '$authenticated',
      );

      return authenticated;
    } on PlatformException catch (error) {
      debugPrint(
        'Local authentication error: '
        '${error.code} - ${error.message}',
      );

      throw Exception(
        _getAuthenticationErrorMessage(
          error.code,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Biometric authentication failed: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (error is Exception) {
        rethrow;
      }

      throw Exception(
        'Biometric authentication failed.',
      );
    }
  }

  // ==========================================================
  // AUTHENTICATE SPECIFICALLY WITH FACE ID
  // ==========================================================
  Future<bool> authenticateWithFaceId() async {
    if (!Platform.isIOS) {
      return authenticate();
    }

    final bool faceIdAvailable =
        await hasFaceId();

    if (!faceIdAvailable) {
      throw Exception(
        'Face ID is not available or has not been enrolled.',
      );
    }

    return authenticate(
      reason:
          'Use Face ID to securely access Focus Glow',
    );
  }

  // ==========================================================
  // AUTHENTICATE FOR LOGIN
  // ==========================================================
  Future<bool> authenticateForLogin() async {
    final String biometricName =
        await getBiometricName();

    return authenticate(
      reason:
          'Use $biometricName to log in to Focus Glow',
    );
  }

  // ==========================================================
  // AUTHENTICATE WHEN ENABLING BIOMETRICS
  // ==========================================================
  Future<bool>
      authenticateForBiometricSetup() async {
    final String biometricName =
        await getBiometricName();

    return authenticate(
      reason:
          'Use $biometricName to enable biometric login',
    );
  }

  // ==========================================================
  // CANCEL AUTHENTICATION
  // ==========================================================
  Future<void> cancelAuthentication() async {
    try {
      await _localAuth
          .stopAuthentication();
    } on PlatformException catch (error) {
      debugPrint(
        'Cancel authentication error: '
        '${error.code} - ${error.message}',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Unexpected cancel authentication error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    }
  }

  // ==========================================================
  // USER-FRIENDLY ERROR MESSAGE
  // ==========================================================
  String _getAuthenticationErrorMessage(
    String code,
  ) {
    switch (code.toLowerCase()) {
      case 'notavailable':
      case 'notsupported':
      case 'no_hardware':
        return 'This device does not support biometric authentication.';

      case 'notenrolled':
      case 'no_biometrics':
        if (Platform.isIOS) {
          return 'Face ID or Touch ID is not enrolled. '
              'Configure it in iPhone Settings.';
        }

        return 'No biometric authentication is enrolled. '
            'Configure it in device settings.';

      case 'lockedout':
      case 'temporarylockout':
        return 'Biometric authentication is temporarily locked. '
            'Unlock your device with its passcode and try again.';

      case 'permanentlylockedout':
      case 'biometriclockout':
        return 'Biometric authentication is locked. '
            'Use your device passcode to unlock it first.';

      case 'usercanceled':
      case 'usercancel':
      case 'auth_in_progress':
        return 'Biometric authentication was cancelled.';

      case 'userfallback':
        return 'Please log in using your email and password.';

      case 'systemcanceled':
      case 'systemcancel':
        return 'Biometric authentication was interrupted.';

      case 'authfailed':
      case 'notrecognized':
        return 'Biometric authentication was not recognised. '
            'Please try again.';

      case 'passcodenotset':
      case 'passcode_not_set':
        return 'Set a device passcode before enabling biometric login.';

      default:
        return 'Biometric authentication was unsuccessful.';
    }
  }
}