
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/schedule_model.dart';
import '../../../services/schedule_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_text_styles.dart';
import 'category_selector.dart';
import 'duration_field.dart';
import 'focus_mode_selector.dart';
import 'save_schedule_button.dart';
import 'time_picker_field.dart';
import 'title_text_field.dart';

class AddScheduleSheet extends StatefulWidget {
  final ValueChanged<ScheduleModel> onScheduleSaved;
  final VoidCallback onClose;

  const AddScheduleSheet({
    super.key,
    required this.onScheduleSaved,
    required this.onClose,
  });

  static Future<void> show({
    required BuildContext context,
    required ValueChanged<ScheduleModel> onScheduleSaved,
    VoidCallback? onClose,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return AddScheduleSheet(
          onScheduleSaved: (ScheduleModel newSchedule) {
            onScheduleSaved(newSchedule);

            Navigator.of(sheetContext).pop();
          },
          onClose: () {
            onClose?.call();

            Navigator.of(sheetContext).pop();
          },
        );
      },
    );
  }

  @override
  State<AddScheduleSheet> createState() {
    return _AddScheduleSheetState();
  }
}

class _AddScheduleSheetState extends State<AddScheduleSheet> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _durationController =
      TextEditingController(
    text: '60',
  );

  final ScheduleService _scheduleService =
      ScheduleService();

  ScheduleCategory _selectedCategory =
      CategorySelector.categories.first;

  String _selectedFocusMode = 'Study Mode';

  TimeOfDay _selectedTime = const TimeOfDay(
    hour: 9,
    minute: 0,
  );

  DateTime _selectedDate = DateTime.now();

  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();

    super.dispose();
  }

  Future<void> _selectTime() async {
    final ThemeData theme =
        Theme.of(context);

    final TimeOfDay? selectedTime =
        await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (
        BuildContext context,
        Widget? child,
      ) {
        return Theme(
          data: theme.copyWith(
            colorScheme:
                theme.colorScheme.copyWith(
              primary:
                  AppColors.schedulePrimary,
              secondary:
                  AppColors.scheduleSecondary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime == null ||
        !mounted) {
      return;
    }

    setState(() {
      _selectedTime = selectedTime;
    });
  }

  Future<void> _selectDate() async {
    final ThemeData theme =
        Theme.of(context);

    final DateTime today =
        DateTime.now();

    final DateTime? selectedDate =
        await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(
        today.year,
        today.month,
        today.day,
      ),
      lastDate: DateTime(
        today.year + 10,
        12,
        31,
      ),
      builder: (
        BuildContext context,
        Widget? child,
      ) {
        return Theme(
          data: theme.copyWith(
            colorScheme:
                theme.colorScheme.copyWith(
              primary:
                  AppColors.schedulePrimary,
              secondary:
                  AppColors.scheduleSecondary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null ||
        !mounted) {
      return;
    }

    setState(() {
      _selectedDate = selectedDate;
    });
  }

  String _formatTime(
    TimeOfDay time,
  ) {
    final int hour =
        time.hourOfPeriod == 0
            ? 12
            : time.hourOfPeriod;

    final String minute =
        time.minute.toString().padLeft(
              2,
              '0',
            );

    final String period =
        time.period == DayPeriod.am
            ? 'AM'
            : 'PM';

    return '${hour.toString().padLeft(2, '0')}:'
        '$minute $period';
  }

  String _formatDisplayDate(
    DateTime date,
  ) {
    final String day =
        date.day.toString().padLeft(
              2,
              '0',
            );

    final String month =
        date.month.toString().padLeft(
              2,
              '0',
            );

    return '$day/$month/${date.year}';
  }

  DateTime _buildScheduleDateTime() {
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
  }

  int? _parseNotificationId(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString(),
    );
  }

  Future<void> _saveSchedule() async {
    FocusScope.of(context).unfocus();

    final bool isValid =
        _formKey.currentState?.validate() ??
            false;

    if (!isValid) {
      return;
    }

    final int? duration =
        int.tryParse(
      _durationController.text.trim(),
    );

    if (duration == null ||
        duration <= 0) {
      _showMessage(
        'Please enter a valid duration.',
      );

      return;
    }

    final User? currentUser =
        Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      _showMessage(
        'Please log in before saving a schedule.',
      );

      return;
    }

    final DateTime scheduleDateTime =
        _buildScheduleDateTime();

    if (!scheduleDateTime.isAfter(
      DateTime.now(),
    )) {
      _showMessage(
        'Please select a future date and time.',
      );

      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final String title =
          _titleController.text.trim();

      final String formattedTime =
          _formatTime(
        _selectedTime,
      );

      final Map<String, dynamic>
          insertedRow =
          await _scheduleService.addSchedule(
        title: title,
        time: formattedTime,
        scheduleDateTime:
            scheduleDateTime,
        durationMinutes:
            duration,
        category:
            _selectedCategory.name,
        focusMode:
            _selectedFocusMode,
      );

      final ScheduleModel newSchedule =
          ScheduleModel(
        id: insertedRow['id']?.toString(),
        emoji:
            _selectedCategory.emoji,
        title: title,
        time: formattedTime,
        scheduleDate:
            scheduleDateTime,
        category:
            _selectedCategory.name,
        categoryColor:
            _selectedCategory.color,
        focusMode:
            _selectedFocusMode,
        durationMinutes:
            duration,
        completed:
            insertedRow['completed'] ==
                true,
        notificationId:
            _parseNotificationId(
          insertedRow[
              'notification_id'],
        ),
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        'Schedule and reminder saved successfully.',
      );

      widget.onScheduleSaved(
        newSchedule,
      );
    } on PostgrestException catch (error) {
      debugPrint(
        'Supabase message: ${error.message}',
      );

      debugPrint(
        'Supabase code: ${error.code}',
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        'Database error: ${error.message}',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Schedule save error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to save schedule: $error',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool isDarkMode =
        Theme.of(context).brightness ==
            Brightness.dark;

    final MediaQueryData mediaQuery =
        MediaQuery.of(context);

    final double keyboardHeight =
        mediaQuery.viewInsets.bottom;

    final double screenHeight =
        mediaQuery.size.height;

    final Color sheetColor =
        isDarkMode
            ? AppColors
                .scheduleBottomSheetDark
            : AppColors
                .scheduleBottomSheetLight;

    final Color handleColor =
        isDarkMode
            ? AppColors
                .scheduleDragHandleDark
            : AppColors
                .scheduleDragHandleLight;

    final Color titleColor =
        isDarkMode
            ? AppColors.textPrimaryDark
            : AppColors.textPrimaryLight;

    final Color labelColor =
        isDarkMode
            ? AppColors.textSecondaryDark
            : AppColors.textSecondaryLight;

    final Color closeButtonColor =
        isDarkMode
            ? AppColors.scheduleInputDark
            : AppColors.scheduleInputLight;

    final Color inputColor =
        isDarkMode
            ? AppColors.scheduleInputDark
            : AppColors.scheduleInputLight;

    return AnimatedPadding(
      duration: const Duration(
        milliseconds: 200,
      ),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: keyboardHeight,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight:
              screenHeight * 0.86,
        ),
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius:
              const BorderRadius.vertical(
            top: Radius.circular(
              AppConstants
                  .bottomSheetRadius,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(
                alpha: 0.28,
              ),
              blurRadius: 24,
              offset:
                  const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 4,
              margin:
                  const EdgeInsets.only(
                top: 10,
              ),
              decoration: BoxDecoration(
                color: handleColor,
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                18,
                12,
                14,
                12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add Schedule',
                      style: AppTextStyles
                          .sectionTitleDark
                          .copyWith(
                        color: titleColor,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed:
                        _isSaving
                            ? null
                            : widget.onClose,
                    style:
                        IconButton.styleFrom(
                      backgroundColor:
                          closeButtonColor,
                    ),
                    icon: Icon(
                      Icons.close_rounded,
                      color: labelColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior
                        .onDrag,
                padding:
                    const EdgeInsets
                        .fromLTRB(
                  18,
                  4,
                  18,
                  24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      _SectionLabel(
                        text: 'Title',
                        color: labelColor,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TitleTextField(
                        controller:
                            _titleController,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      _SectionLabel(
                        text: 'Category',
                        color: labelColor,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CategorySelector(
                        selectedCategory:
                            _selectedCategory,
                        onCategorySelected:
                            (ScheduleCategory
                                category) {
                          setState(() {
                            _selectedCategory =
                                category;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      _SectionLabel(
                        text: 'Date',
                        color: labelColor,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap:
                            _isSaving
                                ? null
                                : _selectDate,
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                        child: Container(
                          width:
                              double.infinity,
                          height: 54,
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 14,
                          ),
                          decoration:
                              BoxDecoration(
                            color: inputColor,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                            border:
                                Border.all(
                              color: AppColors
                                  .schedulePrimary
                                  .withValues(
                                alpha: 0.20,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons
                                    .calendar_month_rounded,
                                color: AppColors
                                    .schedulePrimary,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Text(
                                  _formatDisplayDate(
                                    _selectedDate,
                                  ),
                                  style:
                                      TextStyle(
                                    color:
                                        titleColor,
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight
                                            .w500,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons
                                    .keyboard_arrow_down_rounded,
                                color:
                                    labelColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                _SectionLabel(
                                  text:
                                      'Start Time',
                                  color:
                                      labelColor,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TimePickerField(
                                  selectedTime:
                                      _selectedTime,
                                  onTap: _isSaving
                                      ? () {}
                                      : () => _selectTime(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                _SectionLabel(
                                  text:
                                      'Duration (min)',
                                  color:
                                      labelColor,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                DurationField(
                                  controller:
                                      _durationController,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      _SectionLabel(
                        text: 'Focus Mode',
                        color: labelColor,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FocusModeSelector(
                        selectedMode:
                            _selectedFocusMode,
                        onModeSelected:
                            (String mode) {
                          if (_isSaving) {
                            return;
                          }

                          setState(() {
                            _selectedFocusMode =
                                mode;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      SaveScheduleButton(
                        isLoading:
                            _isSaving,
                        onPressed:
                            _isSaving
                                ? null
                                : _saveSchedule,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel
    extends StatelessWidget {
  final String text;
  final Color color;

  const _SectionLabel({
    required this.text,
    required this.color,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Text(
      text,
      style: AppTextStyles
          .inputLabelDark
          .copyWith(
        color: color,
      ),
    );
  }
}
