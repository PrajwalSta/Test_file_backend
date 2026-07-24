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
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        final double availableWidth =
            constraints.maxWidth;

        int crossAxisCount = 3;
        double childAspectRatio = 0.95;

        if (availableWidth < 280) {
          crossAxisCount = 1;
          childAspectRatio = 1.8;
        } else if (availableWidth < 420) {
          crossAxisCount = 2;
          childAspectRatio = 1.02;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: colors.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio:
                childAspectRatio,
          ),
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            final ThemeColorModel themeColor =
                colors[index];

            final bool isSelected =
                selectedIndex == index;

            return ColorCard(
              key: ValueKey<String>(
                '${themeColor.title}-$index',
              ),
              color: themeColor,
              isSelected: isSelected,
              onTap: () {
                if (!isSelected) {
                  onSelected(index);
                }
              },
            );
          },
        );
      },
    );
  }
}