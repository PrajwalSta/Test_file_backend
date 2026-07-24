import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
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

  /*
   * Keep these internal values in English.
   * They can be safely saved to Supabase
   * and used for comparisons.
   */
  static const List<String> focusModes = <String>[
    'Study Mode',
    'Work Mode',
    'Sleep Mode',
    'Exercise Mode',
    'Custom',
  ];

  String _localizedMode(
    AppLocalizations localizations,
    String mode,
  ) {
    switch (mode.trim().toLowerCase()) {
      case 'study mode':
        return localizations.studyMode;

      case 'work mode':
        return localizations.workMode;

      case 'sleep mode':
        return localizations.sleepMode;

      case 'exercise mode':
        return localizations.exerciseMode;

      case 'custom':
        return localizations.custom;

      default:
        return mode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final bool isDarkMode =
        theme.brightness == Brightness.dark;

    final Color activeColor =
        theme.colorScheme.primary;

    return Column(
      children: focusModes.map(
        (String mode) {
          final bool isSelected =
              selectedMode == mode;

          return Padding(
            padding: const EdgeInsets.only(
              bottom: 9,
            ),
            child: _FocusModeTile(
              title: _localizedMode(
                localizations,
                mode,
              ),
              isSelected: isSelected,
              isDarkMode: isDarkMode,
              activeColor: activeColor,
              onTap: () {
                /*
                 * Return the original English value
                 * instead of the translated label.
                 */
                onModeSelected(mode);
              },
            ),
          );
        },
      ).toList(),
    );
  }
}

class _FocusModeTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool isDarkMode;
  final Color activeColor;
  final VoidCallback onTap;

  const _FocusModeTile({
    required this.title,
    required this.isSelected,
    required this.isDarkMode,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isSelected
            ? activeColor.withValues(
                alpha: 0.14,
              )
            : isDarkMode
                ? AppColors.scheduleInputDark
                : AppColors.scheduleInputLight;

    final Color borderColor =
        isSelected
            ? activeColor
            : isDarkMode
                ? AppColors.scheduleBorderDark
                : AppColors.scheduleBorderLight;

    final Color textColor =
        isSelected
            ? activeColor
            : isDarkMode
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight;

    final Color iconColor =
        isSelected
            ? activeColor
            : isDarkMode
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight;

    return Semantics(
      button: true,
      selected: isSelected,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            AppConstants.mediumRadius,
          ),
          child: AnimatedContainer(
            duration:
                AppConstants.shortAnimation,
            width: double.infinity,
            height: 50,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius:
                  BorderRadius.circular(
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
                  color: iconColor,
                  size: 18,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}