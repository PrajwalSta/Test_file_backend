import 'package:flutter/material.dart';

class StatModel {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatModel({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
}