import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final Color fillColor = isDarkMode
        ? AppColors.scheduleInputDark
        : AppColors.scheduleInputLight;

    final Color borderColor = isDarkMode
        ? AppColors.scheduleBorderDark
        : AppColors.scheduleBorderLight;

    final TextStyle inputStyle = isDarkMode
        ? AppTextStyles.inputTextDark
        : AppTextStyles.inputTextLight;

    final Color hintColor = isDarkMode
        ? AppColors.textHintDark
        : AppColors.textHintLight;

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: inputStyle,
      validator: (value) {
        final int? duration = int.tryParse(
          value?.trim() ?? '',
        );

        if (duration == null) {
          return 'Enter a valid number';
        }

        if (duration < AppConstants.minimumDuration) {
          return 'Minimum is 1 minute';
        }

        if (duration > AppConstants.maximumDuration) {
          return 'Maximum is 1440';
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: '60',
        hintStyle: TextStyle(
          color: hintColor,
          fontSize: 13,
        ),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.scheduleInputRadius,
          ),
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.scheduleInputRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.schedulePrimary,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.scheduleInputRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.danger,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.scheduleInputRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.danger,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}