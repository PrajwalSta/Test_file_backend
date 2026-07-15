import 'package:flutter/material.dart';

import '../../../models/theme_color_model.dart';
import 'color_card.dart';

class ColorGrid extends StatelessWidget {
  final List<ThemeColorModel> colors;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ColorGrid({
    super.key,
    required this.colors,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;

        if (constraints.maxWidth < 360) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: colors.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            return ColorCard(
              color: colors[index],
              isSelected: selectedIndex == index,
              onTap: () => onSelected(index),
            );
          },
        );
      },
    );
  }
}