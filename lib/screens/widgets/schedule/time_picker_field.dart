import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_text_styles.dart';

class TimePickerField extends StatelessWidget {
  final TimeOfDay selectedTime;
  final VoidCallback onTap;

  const TimePickerField({
    super.key,
    required this.selectedTime,
    required this.onTap,
  });

  String _formatTime(TimeOfDay time) {
    final int hour =
        time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;

    final String minute =
        time.minute.toString().padLeft(2, '0');

    final String period =
        time.period == DayPeriod.am ? 'AM' : 'PM';

    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

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

    final TextStyle textStyle = isDarkMode
        ? AppTextStyles.inputTextDark
        : AppTextStyles.inputTextLight;

    final Color iconColor = isDarkMode
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppConstants.scheduleInputRadius,
        ),
        child: Container(
          height: AppConstants.scheduleInputHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(
              AppConstants.scheduleInputRadius,
            ),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _formatTime(selectedTime),
                  style: textStyle,
                ),
              ),
              Icon(
                Icons.schedule_rounded,
                color: iconColor,
                size: AppConstants.smallIconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}