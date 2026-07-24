import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/schedule_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_text_styles.dart';
import 'schedule_card.dart';

class ScheduleList extends StatelessWidget {
  final String title;
  final List<ScheduleModel> tasks;

  final ValueChanged<ScheduleModel>?
      onScheduleTap;

  final ValueChanged<ScheduleModel>?
      onScheduleDelete;

  final void Function(
    ScheduleModel schedule,
    bool completed,
  )? onCompletedChanged;

  const ScheduleList({
    super.key,
    required this.title,
    required this.tasks,
    this.onScheduleTap,
    this.onScheduleDelete,
    this.onCompletedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final bool isDarkMode =
        Theme.of(context).brightness ==
            Brightness.dark;

    final TextStyle titleStyle =
        isDarkMode
            ? AppTextStyles
                .sectionTitleDark
            : AppTextStyles
                .sectionTitleLight;

    final Color emptyTextColor =
        isDarkMode
            ? AppColors
                .textSecondaryDark
            : AppColors
                .textSecondaryLight;

    final Color emptyBackground =
        isDarkMode
            ? AppColors
                .scheduleInputDark
            : AppColors
                .scheduleInputLight;

    final Color emptyBorder =
        isDarkMode
            ? AppColors
                .scheduleBorderDark
            : AppColors
                .scheduleBorderLight;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: titleStyle,
          ),
          const SizedBox(
            height: 14,
          ),
        ],

        if (tasks.isEmpty)
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            decoration: BoxDecoration(
              color: emptyBackground,
              borderRadius:
                  BorderRadius.circular(
                AppConstants.largeRadius,
              ),
              border: Border.all(
                color: emptyBorder,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.event_busy_outlined,
                  size: 32,
                  color: emptyTextColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  localizations
                      .noSchedulesAvailable,
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color:
                        emptyTextColor,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: List.generate(
              tasks.length,
              (int index) {
                final ScheduleModel
                    schedule =
                    tasks[index];

                return Padding(
                  padding:
                      EdgeInsets.only(
                    bottom:
                        index ==
                                tasks.length -
                                    1
                            ? 0
                            : AppConstants
                                .itemSpacing,
                  ),
                  child: ScheduleCard(
                    schedule:
                        schedule,
                    onTap:
                        onScheduleTap ==
                                null
                            ? null
                            : () {
                                onScheduleTap!(
                                  schedule,
                                );
                              },
                    onDelete:
                        onScheduleDelete ==
                                null
                            ? null
                            : () {
                                onScheduleDelete!(
                                  schedule,
                                );
                              },
                    onCompletedChanged:
                        onCompletedChanged ==
                                null
                            ? null
                            : (
                                bool
                                    completed,
                              ) {
                                onCompletedChanged!(
                                  schedule,
                                  completed,
                                );
                              },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}