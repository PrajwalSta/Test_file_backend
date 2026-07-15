import 'package:flutter/material.dart';

import '../../../models/schedule_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_text_styles.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleModel schedule;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ScheduleCard({
    super.key,
    required this.schedule,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDarkMode
        ? AppColors.scheduleCardDark
        : AppColors.scheduleCardLight;

    final TextStyle titleStyle = isDarkMode
        ? AppTextStyles.scheduleTitleDark
        : AppTextStyles.scheduleTitleLight;

    final TextStyle subtitleStyle = isDarkMode
        ? AppTextStyles.scheduleSubtitleDark
        : AppTextStyles.scheduleSubtitleLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppConstants.scheduleCardRadius,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(
              AppConstants.scheduleCardRadius,
            ),
            border: Border.all(
              color: schedule.categoryColor.withValues(
                alpha: isDarkMode ? 0.30 : 0.20,
              ),
            ),
            boxShadow: isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: Row(
            children: [
              _EmojiBox(schedule: schedule),
              const SizedBox(width: 14),
              Expanded(
                child: _ScheduleDetails(
                  schedule: schedule,
                  titleStyle: titleStyle,
                  subtitleStyle: subtitleStyle,
                ),
              ),
              if (onDelete != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onDelete,
                  tooltip: 'Delete schedule',
                  style: IconButton.styleFrom(
                    backgroundColor:
                        AppColors.danger.withValues(alpha: 0.10),
                  ),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.danger,
                    size: 20,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmojiBox extends StatelessWidget {
  final ScheduleModel schedule;

  const _EmojiBox({
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.scheduleEmojiSize,
      height: AppConstants.scheduleEmojiSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: schedule.categoryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        schedule.emoji,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}

class _ScheduleDetails extends StatelessWidget {
  final ScheduleModel schedule;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  const _ScheduleDetails({
    required this.schedule,
    required this.titleStyle,
    required this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          schedule.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 15,
              color: subtitleStyle.color,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                '${schedule.time} • ${schedule.durationMinutes} min',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: subtitleStyle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _ScheduleChip(
              text: schedule.category,
              backgroundColor:
                  schedule.categoryColor.withValues(alpha: 0.14),
              textColor: schedule.categoryColor,
            ),
            _ScheduleChip(
              text: schedule.focusMode,
              backgroundColor:
                  AppColors.schedulePrimary.withValues(alpha: 0.14),
              textColor: AppColors.schedulePrimary,
            ),
          ],
        ),
      ],
    );
  }
}

class _ScheduleChip extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const _ScheduleChip({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.chipText.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}