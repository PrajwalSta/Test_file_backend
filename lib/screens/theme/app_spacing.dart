import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // Screen Padding
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 20,
  );

  // Horizontal Padding
  static const EdgeInsets horizontalPadding =
      EdgeInsets.symmetric(
    horizontal: 24,
  );

  // Vertical Padding
  static const EdgeInsets verticalPadding =
      EdgeInsets.symmetric(
    vertical: 20,
  );

  // Spacing
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
}