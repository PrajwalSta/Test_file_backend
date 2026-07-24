import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/schedule_model.dart';

class ScheduleSection extends StatelessWidget {
  final List<ScheduleModel> schedules;
  final ValueChanged<ScheduleModel> onScheduleTap;

  const ScheduleSection({
    super.key,
    required this.schedules,
    required this.onScheduleTap,
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
    final ThemeData theme = Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    if (schedules.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 28,
        ),
        decoration: BoxDecoration(
          color: colorScheme
              .surfaceContainerHighest
              .withValues(
            alpha: 0.35,
          ),
          borderRadius: BorderRadius.circular(
            18,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.event_available_rounded,
              size: 36,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              localizations.noSchedulesForToday,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              localizations.pressAddToCreateSchedule,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: schedules.map(
        (ScheduleModel schedule) {
          final String localizedCategory =
              _localizedCategory(
            localizations,
            schedule.category,
          );

          final String localizedFocusMode =
              _localizedFocusMode(
            localizations,
            schedule.focusMode,
          );

          final String durationText =
              localizations.minutesShort(
            schedule.durationMinutes,
          );

          return Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  onScheduleTap(
                    schedule,
                  );
                },
                borderRadius: BorderRadius.circular(
                  18,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                    border: Border.all(
                      color: schedule.categoryColor
                          .withValues(
                        alpha: 0.28,
                      ),
                    ),
                    boxShadow: theme.brightness ==
                            Brightness.dark
                        ? null
                        : <BoxShadow>[
                            BoxShadow(
                              color: Colors.black
                                  .withValues(
                                alpha: 0.06,
                              ),
                              blurRadius: 14,
                              offset: const Offset(
                                0,
                                5,
                              ),
                            ),
                          ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: schedule.categoryColor
                              .withValues(
                            alpha: 0.15,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                        child: Text(
                          schedule.emoji,
                          style: const TextStyle(
                            fontSize: 23,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              schedule.title,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                    colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 15,
                                  color: colorScheme
                                      .onSurfaceVariant,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Text(
                                    '${schedule.time} • '
                                    '$durationText',
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: colorScheme
                                          .onSurfaceVariant,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '$localizedCategory • '
                              '$localizedFocusMode',
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                    schedule.categoryColor,
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color:
                            colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}