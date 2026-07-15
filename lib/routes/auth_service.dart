import 'package:flutter/material.dart';

class AuthService {
  Future<void> loginWithGoogle() async {
    debugPrint("Google login clicked");
  }

  Future<void> loginWithApple() async {
    debugPrint("Apple login clicked");
  }

  Future<void> loginWithFacebook() async {
    debugPrint("Facebook login clicked");
  }
}