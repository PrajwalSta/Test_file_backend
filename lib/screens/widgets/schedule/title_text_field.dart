import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_text_styles.dart';

class TitleTextField extends StatelessWidget {
  final TextEditingController controller;

  const TitleTextField({
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
      textInputAction: TextInputAction.next,
      style: inputStyle,
      validator: (value) {
        final String title = value?.trim() ?? '';

        if (title.isEmpty) {
          return 'Please enter a schedule title';
        }

        if (title.length < AppConstants.minimumTitleLength) {
          return 'Title must contain at least 3 characters';
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: 'e.g. Deep Work Session',
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