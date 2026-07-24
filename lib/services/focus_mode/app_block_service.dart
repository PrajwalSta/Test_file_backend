import 'dart:io';

import 'package:flutter/services.dart';

class AppBlockService {
  AppBlockService._();

  static const MethodChannel _channel =
      MethodChannel('focus_glow/app_blocker');

  static Future<bool> requestPermission() async {
    if (!Platform.isIOS) {
      return false;
    }

    try {
      return await _channel.invokeMethod<bool>(
            'requestAuthorization',
          ) ??
          false;
    } on PlatformException catch (error) {
      throw Exception(
        error.message ?? 'Unable to request Screen Time permission',
      );
    }
  }

  static Future<void> openAppPicker() async {
    if (!Platform.isIOS) {
      return;
    }

    await _channel.invokeMethod<void>('openAppPicker');
  }

  static Future<void> blockSelectedApps() async {
    if (!Platform.isIOS) {
      return;
    }

    await _channel.invokeMethod<void>('blockSelectedApps');
  }

  static Future<void> unblockAllApps() async {
    if (!Platform.isIOS) {
      return;
    }

    await _channel.invokeMethod<void>('unblockAllApps');
  }
}