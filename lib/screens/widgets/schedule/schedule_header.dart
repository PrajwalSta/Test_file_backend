import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_text_styles.dart';

class ScheduleHeader extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const ScheduleHeader({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  /*
   * Keep these internal values in English.
   *
   * These values may be stored in Supabase
   * or compared with ScheduleModel.category.
   *
   * Only the text displayed to the user
   * is translated.
   */
  static const List<String> categories = <String>[
    'All',
    'Work',
    'Study',
    'Health',
    'Personal',
    'Social',
  ];

  String _localizedCategory({
    required AppLocalizations localizations,
    required String category,
  }) {
    switch (category.toLowerCase()) {
      case 'all':
        return localizations.all;

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
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final bool isDarkMode =
        theme.brightness ==
            Brightness.dark;

    /*
     * Uses the currently selected
     * ThemeProvider colour.
     */
    final Color selectedColor =
        theme.colorScheme.primary;

    final TextStyle titleStyle =
        isDarkMode
            ? AppTextStyles.screenTitleDark
            : AppTextStyles.screenTitleLight;

    final Color unselectedBackground =
        isDarkMode
            ? AppColors.scheduleInputDark
            : AppColors.scheduleInputLight;

    final Color unselectedBorder =
        isDarkMode
            ? AppColors.scheduleBorderDark
            : AppColors.scheduleBorderLight;

    final Color unselectedText =
        isDarkMode
            ? AppColors.textSecondaryDark
            : AppColors.textSecondaryLight;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          localizations.schedule,
          style: titleStyle,
        ),

        const SizedBox(
          height: 18,
        ),

        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection:
                Axis.horizontal,
            itemCount:
                categories.length,
            separatorBuilder: (
              BuildContext context,
              int index,
            ) {
              return const SizedBox(
                width: 8,
              );
            },
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              final String category =
                  categories[index];

              final bool isSelected =
                  selectedCategory
                          .trim()
                          .toLowerCase() ==
                      category
                          .trim()
                          .toLowerCase();

              final String categoryLabel =
                  _localizedCategory(
                localizations:
                    localizations,
                category:
                    category,
              );

              return ChoiceChip(
                label: Text(
                  categoryLabel,
                ),
                selected:
                    isSelected,
                onSelected: (
                  bool selected,
                ) {
                  if (!selected) {
                    return;
                  }

                  /*
                   * Pass the original English
                   * category value back.
                   */
                  onCategorySelected(
                    category,
                  );
                },
                showCheckmark:
                    false,
                selectedColor:
                    selectedColor,
                backgroundColor:
                    unselectedBackground,
                side: BorderSide(
                  color:
                      isSelected
                          ? selectedColor
                          : unselectedBorder,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    AppConstants
                        .mediumRadius,
                  ),
                ),
                labelStyle:
                    TextStyle(
                  color:
                      isSelected
                          ? theme
                              .colorScheme
                              .onPrimary
                          : unselectedText,
                  fontSize:
                      12,
                  fontWeight:
                      FontWeight.w600,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}