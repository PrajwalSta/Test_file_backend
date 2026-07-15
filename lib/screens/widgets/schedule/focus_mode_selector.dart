import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';

class FocusModeSelector extends StatelessWidget {
  final String selectedMode;
  final ValueChanged<String> onModeSelected;

  const FocusModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeSelected,
  });

  static const List<String> focusModes = [
    'Study Mode',
    'Work Mode',
    'Sleep Mode',
    'Exercise Mode',
    'Custom',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: focusModes.map((mode) {
        final bool isSelected = selectedMode == mode;

        return Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: _FocusModeTile(
            title: mode,
            isSelected: isSelected,
            isDarkMode: isDarkMode,
            onTap: () {
              onModeSelected(mode);
            },
          ),
        );
      }).toList(),
    );
  }
}

class _FocusModeTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _FocusModeTile({
    required this.title,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isSelected
        ? AppColors.schedulePrimary.withValues(alpha: 0.14)
        : isDarkMode
            ? AppColors.scheduleInputDark
            : AppColors.scheduleInputLight;

    final Color borderColor = isSelected
        ? AppColors.schedulePrimary
        : isDarkMode
            ? AppColors.scheduleBorderDark
            : AppColors.scheduleBorderLight;

    final Color textColor = isSelected
        ? AppColors.schedulePrimary
        : isDarkMode
            ? AppColors.textPrimaryDark
            : AppColors.textPrimaryLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppConstants.mediumRadius,
        ),
        child: AnimatedContainer(
          duration: AppConstants.shortAnimation,
          width: double.infinity,
          height: 50,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              AppConstants.mediumRadius,
            ),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected
                    ? AppColors.schedulePrimary
                    : isDarkMode
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}