// 
import 'package:flutter/material.dart';

class ThemeColorModel {
  final String title;
  final String keyName;
  final Color primaryColor;
  final Color secondaryColor;
  final List<Color>? gradient;

  const ThemeColorModel({
    required this.title,
    required this.keyName,
    required this.primaryColor,
    required this.secondaryColor,
    this.gradient,
  });

  // Keeps existing code compatible.
  Color get color => primaryColor;
}