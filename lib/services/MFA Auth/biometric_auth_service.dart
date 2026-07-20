import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuth =
      LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    try {
      final bool canCheckBiometrics =
          await _localAuth.canCheckBiometrics;

      final bool isDeviceSupported =
          await _localAuth.isDeviceSupported();

      return canCheckBiometrics &&
          isDeviceSupported;
    } on PlatformException {
      return false;
    }
  }

  Future<List<BiometricType>>
      getAvailableBiometrics() async {
    try {
      return await _localAuth
          .getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  Future<bool> authenticate() async {
    try {
      final bool available =
          await isBiometricAvailable();

      if (!available) {
        throw Exception(
          'Biometric authentication is not available on this device.',
        );
      }

      return await _localAuth.authenticate(
        localizedReason:
            'Authenticate to enable biometric login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (error) {
      throw Exception(
        error.message ??
            'Biometric authentication failed.',
      );
    }
  }
}