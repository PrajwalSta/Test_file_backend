import 'package:shared_preferences/shared_preferences.dart';

class BiometricSettingService {
  BiometricSettingService._();

  static final BiometricSettingService instance =
      BiometricSettingService._();

  static const String _enabledKey =
      'biometric_login_enabled';

  Future<bool> isEnabled() async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();

    return preferences.getBool(
          _enabledKey,
        ) ??
        false;
  }

  Future<void> setEnabled(
    bool enabled,
  ) async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();

    await preferences.setBool(
      _enabledKey,
      enabled,
    );
  }

  Future<void> clear() async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();

    await preferences.remove(
      _enabledKey,
    );
  }
}