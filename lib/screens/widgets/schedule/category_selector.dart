import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
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
  final ValueChanged<ScheduleCategory>
      onCategorySelected;

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

  String _localizedCategory(
    AppLocalizations localizations,
    String category,
  ) {
    switch (category.toLowerCase()) {
      case 'work':
        return localizations.work;

      case 'study':
        return localizations.study;

      case 'health':
        return localizations.health;

      case 'personal':
        return localizations.personal;

      case 'social':
        return localizations.social;

      default:
        return category;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final bool isDarkMode =
        theme.brightness ==
            Brightness.dark;

    final Color activeColor =
        theme.colorScheme.primary;

    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        const double spacing = 8;

        final double cardWidth =
            (constraints.maxWidth -
                    (spacing * 4)) /
                5;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: categories.map(
            (
              ScheduleCategory category,
            ) {
              final bool isSelected =
                  selectedCategory.name ==
                      category.name;

              return SizedBox(
                width: cardWidth,
                child: _CategoryCard(
                  category: category,
                  title: _localizedCategory(
                    localizations,
                    category.name,
                  ),
                  isSelected:
                      isSelected,
                  isDarkMode:
                      isDarkMode,
                  activeColor:
                      activeColor,
                  onTap: () {
                    onCategorySelected(
                      category,
                    );
                  },
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ScheduleCategory category;
  final String title;
  final bool isSelected;
  final bool isDarkMode;
  final Color activeColor;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.title,
    required this.isSelected,
    required this.isDarkMode,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final Color backgroundColor =
        isSelected
            ? activeColor.withValues(
                alpha: 0.16,
              )
            : isDarkMode
                ? AppColors
                    .scheduleInputDark
                : AppColors
                    .scheduleInputLight;

    final Color borderColor =
        isSelected
            ? activeColor
            : isDarkMode
                ? AppColors
                    .scheduleBorderDark
                : AppColors
                    .scheduleBorderLight;

    final Color textColor =
        isSelected
            ? activeColor
            : isDarkMode
                ? AppColors
                    .textSecondaryDark
                : AppColors
                    .textSecondaryLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(
          AppConstants
              .scheduleCategoryRadius,
        ),
        child: AnimatedContainer(
          duration:
              AppConstants.shortAnimation,
          curve:
              Curves.easeInOut,
          height:
              AppConstants
                  .scheduleCategoryHeight,
          padding:
              const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color:
                backgroundColor,
            borderRadius:
                BorderRadius.circular(
              AppConstants
                  .scheduleCategoryRadius,
            ),
            border: Border.all(
              color:
                  borderColor,
              width:
                  isSelected
                      ? 1.4
                      : 1,
            ),
            boxShadow:
                isSelected
                    ? [
                        BoxShadow(
                          color:
                              activeColor
                                  .withValues(
                            alpha:
                                0.16,
                          ),
                          blurRadius:
                              10,
                          offset:
                              const Offset(
                            0,
                            3,
                          ),
                        ),
                      ]
                    : null,
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Text(
                category.emoji,
                style:
                    const TextStyle(
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                title,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                textAlign:
                    TextAlign.center,
                style:
                    AppTextStyles.chipText
                        .copyWith(
                  color:
                      textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}