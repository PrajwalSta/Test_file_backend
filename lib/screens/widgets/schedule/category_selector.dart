import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_text_styles.dart';

class ScheduleCategory {
  final String name;
  final String emoji;
  final Color color;

  const ScheduleCategory({
    required this.name,
    required this.emoji,
    required this.color,
  });
}

class CategorySelector extends StatelessWidget {
  final ScheduleCategory selectedCategory;
  final ValueChanged<ScheduleCategory> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<ScheduleCategory> categories = [
    ScheduleCategory(
      name: 'Work',
      emoji: '💼',
      color: AppColors.scheduleWork,
    ),
    ScheduleCategory(
      name: 'Study',
      emoji: '📚',
      color: AppColors.scheduleStudy,
    ),
    ScheduleCategory(
      name: 'Health',
      emoji: '🏃',
      color: AppColors.scheduleHealth,
    ),
    ScheduleCategory(
      name: 'Personal',
      emoji: '✨',
      color: AppColors.schedulePersonal,
    ),
    ScheduleCategory(
      name: 'Social',
      emoji: '👥',
      color: AppColors.scheduleSocial,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 8;

        final double cardWidth =
            (constraints.maxWidth - (spacing * 4)) / 5;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: categories.map((category) {
            final bool isSelected =
                selectedCategory.name == category.name;

            return SizedBox(
              width: cardWidth,
              child: _CategoryCard(
                category: category,
                isSelected: isSelected,
                isDarkMode: isDarkMode,
                onTap: () {
                  onCategorySelected(category);
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ScheduleCategory category;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isSelected
        ? category.color.withValues(alpha: 0.16)
        : isDarkMode
            ? AppColors.scheduleInputDark
            : AppColors.scheduleInputLight;

    final Color borderColor = isSelected
        ? category.color
        : isDarkMode
            ? AppColors.scheduleBorderDark
            : AppColors.scheduleBorderLight;

    final Color textColor = isSelected
        ? category.color
        : isDarkMode
            ? AppColors.textSecondaryDark
            : AppColors.textSecondaryLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppConstants.scheduleCategoryRadius,
        ),
        child: AnimatedContainer(
          duration: AppConstants.shortAnimation,
          curve: Curves.easeInOut,
          height: AppConstants.scheduleCategoryHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              AppConstants.scheduleCategoryRadius,
            ),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                category.emoji,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.chipText.copyWith(
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}