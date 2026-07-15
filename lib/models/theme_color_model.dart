import 'package:flutter/material.dart';

class ThemeColorModel {
  final String title;
  final Color color;
  final List<Color>? gradient;

  ThemeColorModel({
    required this.title,
    required this.color,
    this.gradient,
  });
}