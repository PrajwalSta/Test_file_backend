import 'package:flutter/material.dart';

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

  static const List<String> categories = [
    'All',
    'Work',
    'Study',
    'Health',
    'Personal',
    'Social',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final TextStyle titleStyle = isDarkMode
        ? AppTextStyles.screenTitleDark
        : AppTextStyles.screenTitleLight;

    final Color unselectedBackground = isDarkMode
        ? AppColors.scheduleInputDark
        : AppColors.scheduleInputLight;

    final Color unselectedBorder = isDarkMode
        ? AppColors.scheduleBorderDark
        : AppColors.scheduleBorderLight;

    final Color unselectedText = isDarkMode
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule',
          style: titleStyle,
        ),

        const SizedBox(height: 18),

        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) {
              return const SizedBox(width: 8);
            },
            itemBuilder: (context, index) {
              final String category = categories[index];
              final bool isSelected =
                  selectedCategory == category;

              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) {
                  onCategorySelected(category);
                },
                showCheckmark: false,
                selectedColor: AppColors.schedulePrimary,
                backgroundColor: unselectedBackground,
                side: BorderSide(
                  color: isSelected
                      ? AppColors.schedulePrimary
                      : unselectedBorder,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.mediumRadius,
                  ),
                ),
                labelStyle: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : unselectedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}