import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_text_styles.dart';

class DurationField extends StatelessWidget {
  final TextEditingController controller;

  const DurationField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final ThemeData theme =
        Theme.of(context);

    final bool isDarkMode =
        theme.brightness ==
            Brightness.dark;

    final Color primaryColor =
        theme.colorScheme.primary;

    final Color fillColor =
        isDarkMode
            ? AppColors.scheduleInputDark
            : AppColors.scheduleInputLight;

    final Color borderColor =
        isDarkMode
            ? AppColors.scheduleBorderDark
            : AppColors.scheduleBorderLight;

    final TextStyle inputStyle =
        isDarkMode
            ? AppTextStyles.inputTextDark
            : AppTextStyles.inputTextLight;

    final Color hintColor =
        isDarkMode
            ? AppColors.textHintDark
            : AppColors.textHintLight;

    return TextFormField(
      controller: controller,
      keyboardType:
          TextInputType.number,
      textInputAction:
          TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: inputStyle,
      validator: (
        String? value,
      ) {
        final String input =
            value?.trim() ?? '';

        if (input.isEmpty) {
          return localizations
              .durationRequired;
        }

        final int? duration =
            int.tryParse(input);

        if (duration == null) {
          return localizations
              .enterValidNumber;
        }

        if (duration <
            AppConstants
                .minimumDuration) {
          return localizations
              .minimumDuration(
            AppConstants
                .minimumDuration,
          );
        }

        if (duration >
            AppConstants
                .maximumDuration) {
          return localizations
              .maximumDuration(
            AppConstants
                .maximumDuration,
          );
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: localizations
            .durationHint,
        hintStyle: TextStyle(
          color: hintColor,
          fontSize: 13,
        ),
        filled: true,
        fillColor: fillColor,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            AppConstants
                .scheduleInputRadius,
          ),
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            AppConstants
                .scheduleInputRadius,
          ),
          borderSide: BorderSide(
            color: primaryColor,
            width: 1.4,
          ),
        ),
        errorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            AppConstants
                .scheduleInputRadius,
          ),
          borderSide:
              const BorderSide(
            color: AppColors.danger,
          ),
        ),
        focusedErrorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            AppConstants
                .scheduleInputRadius,
          ),
          borderSide:
              const BorderSide(
            color: AppColors.danger,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}