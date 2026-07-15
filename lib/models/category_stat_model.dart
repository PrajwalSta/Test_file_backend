import 'package:flutter/material.dart';

class CategoryStatModel {
  final String title;
  final double percentage;
  final Color color;

  const CategoryStatModel({
    required this.title,
    required this.percentage,
    required this.color,
  });
}