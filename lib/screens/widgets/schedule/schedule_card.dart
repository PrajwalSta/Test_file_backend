import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/schedule_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_text_styles.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleModel schedule;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onCompletedChanged;

  const ScheduleCard({
    super.key,
    required this.schedule,
    this.onTap,
    this.onDelete,
    this.onCompletedChanged,
  });

  String _localizedCategory(
    AppLocalizations localizations,
    String category,
  ) {
    switch (category.trim().toLowerCase()) {
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

  String _localizedFocusMode(
    AppLocalizations localizations,
    String focusMode,
  ) {
    switch (focusMode.trim().toLowerCase()) {
      case 'study mode':
        return localizations.studyMode;

      case 'work mode':
        return localizations.workMode;

      case 'deep work':
        return localizations.deepWork;

      case 'reading mode':
        return localizations.readingMode;

      case 'exercise mode':
        return localizations.exerciseMode;

      case 'no focus mode':
      case 'none':
      case 'off':
        return localizations.noFocusMode;

      default:
        return focusMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final ThemeData theme = Theme.of(context);

    final bool isDarkMode =
        theme.brightness == Brightness.dark;

    final Color primaryColor =
        theme.colorScheme.primary;

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
        child: AnimatedOpacity(
          duration: const Duration(
            milliseconds: 180,
          ),
          opacity: schedule.completed ? 0.65 : 1,
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
                  : <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.05,
                        ),
                        blurRadius: 12,
                        offset: const Offset(
                          0,
                          5,
                        ),
                      ),
                    ],
            ),
            child: Row(
              children: [
                if (onCompletedChanged != null) ...[
                  Checkbox(
                    value: schedule.completed,
                    activeColor: primaryColor,
                    onChanged: (bool? value) {
                      if (value == null) {
                        return;
                      }

                      onCompletedChanged!(value);
                    },
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                ],
                _EmojiBox(
                  schedule: schedule,
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: _ScheduleDetails(
                    schedule: schedule,
                    titleStyle: titleStyle,
                    subtitleStyle: subtitleStyle,
                    localizedCategory:
                        _localizedCategory(
                      localizations,
                      schedule.category,
                    ),
                    localizedFocusMode:
                        _localizedFocusMode(
                      localizations,
                      schedule.focusMode,
                    ),
                    durationText:
                        localizations.minutesShort(
                      schedule.durationMinutes,
                    ),
                    focusColor: primaryColor,
                  ),
                ),
                if (onDelete != null) ...[
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    onPressed: onDelete,
                    tooltip:
                        localizations.deleteSchedule,
                    style: IconButton.styleFrom(
                      backgroundColor:
                          AppColors.danger.withValues(
                        alpha: 0.10,
                      ),
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
        color: schedule.categoryColor.withValues(
          alpha: 0.15,
        ),
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      child: Text(
        schedule.emoji,
        style: const TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }
}

class _ScheduleDetails extends StatelessWidget {
  final ScheduleModel schedule;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final String localizedCategory;
  final String localizedFocusMode;
  final String durationText;
  final Color focusColor;

  const _ScheduleDetails({
    required this.schedule,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.localizedCategory,
    required this.localizedFocusMode,
    required this.durationText,
    required this.focusColor,
  });

  @override
  Widget build(BuildContext context) {
    final TextDecoration? decoration =
        schedule.completed
            ? TextDecoration.lineThrough
            : null;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          schedule.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: titleStyle.copyWith(
            decoration: decoration,
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Row(
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 15,
              color: subtitleStyle.color,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                '${schedule.time} • $durationText',
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: subtitleStyle.copyWith(
                  decoration: decoration,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _ScheduleChip(
              text: localizedCategory,
              backgroundColor:
                  schedule.categoryColor.withValues(
                alpha: 0.14,
              ),
              textColor:
                  schedule.categoryColor,
            ),
            _ScheduleChip(
              text: localizedFocusMode,
              backgroundColor:
                  focusColor.withValues(
                alpha: 0.14,
              ),
              textColor: focusColor,
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
      constraints: const BoxConstraints(
        maxWidth: 150,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          20,
        ),
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