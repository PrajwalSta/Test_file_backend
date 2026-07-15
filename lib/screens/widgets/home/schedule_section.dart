import 'package:flutter/material.dart';

import '../../../models/schedule_model.dart';

class ScheduleSection extends StatelessWidget {
  final List<ScheduleModel> schedules;
  final ValueChanged<ScheduleModel> onScheduleTap;

  const ScheduleSection({
    super.key,
    required this.schedules,
    required this.onScheduleTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

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
              .withValues(alpha: 0.35),
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.event_available_rounded,
              size: 36,
            ),
            SizedBox(height: 10),
            Text(
              'No schedules for today',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Press Add to create a schedule.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: schedules.map((schedule) {
        return Padding(
          padding:
              const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onScheduleTap(schedule);
              },
              borderRadius:
                  BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius:
                      BorderRadius.circular(18),
                  border: Border.all(
                    color: schedule.categoryColor
                        .withValues(alpha: 0.28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: 0.06),
                      blurRadius: 14,
                      offset:
                          const Offset(0, 5),
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
                            .withValues(alpha: 0.15),
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      child: Text(
                        schedule.emoji,
                        style: const TextStyle(
                          fontSize: 23,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

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
                              color: colorScheme
                                  .onSurface,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Row(
                            children: [
                              Icon(
                                Icons
                                    .access_time_rounded,
                                size: 15,
                                color: colorScheme
                                    .onSurfaceVariant,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  '${schedule.time} • '
                                  '${schedule.durationMinutes} min',
                                  maxLines: 1,
                                  overflow: TextOverflow
                                      .ellipsis,
                                  style: TextStyle(
                                    color: colorScheme
                                        .onSurfaceVariant,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),

                          Text(
                            '${schedule.category} • '
                            '${schedule.focusMode}',
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              color: schedule
                                  .categoryColor,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme
                          .onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}