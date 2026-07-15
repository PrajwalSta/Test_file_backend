import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/schedule_model.dart';
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
      builder: (sheetContext) {
        return AddScheduleSheet(
          onScheduleSaved: (newSchedule) {
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
      TextEditingController(text: '60');

  ScheduleCategory _selectedCategory =
      CategorySelector.categories.first;

  String _selectedFocusMode = 'Study Mode';

  TimeOfDay _selectedTime = const TimeOfDay(
    hour: 9,
    minute: 0,
  );

  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final ThemeData theme = Theme.of(context);

    final TimeOfDay? selectedTime =
        await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.schedulePrimary,
              secondary: AppColors.scheduleSecondary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime == null || !mounted) {
      return;
    }

    setState(() {
      _selectedTime = selectedTime;
    });
  }

  String _formatTime(TimeOfDay time) {
    final int hour =
        time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;

    final String minute =
        time.minute.toString().padLeft(2, '0');

    final String period =
        time.period == DayPeriod.am ? 'AM' : 'PM';

    return '${hour.toString().padLeft(2, '0')}:'
        '$minute $period';
  }

  Future<void> _saveSchedule() async {
    FocusScope.of(context).unfocus();

    final bool isValid =
        _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final int? duration = int.tryParse(
      _durationController.text.trim(),
    );

    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid duration',
          ),
        ),
      );
      return;
    }

    final SupabaseClient supabase =
        Supabase.instance.client;

    final User? currentUser =
        supabase.auth.currentUser;

    debugPrint(
      'Current Supabase user: ${currentUser?.email}',
    );

    debugPrint(
      'Current Supabase user ID: ${currentUser?.id}',
    );

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please log in before saving a schedule',
          ),
        ),
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
          _formatTime(_selectedTime);

      await supabase.from('schedules').insert({
        'user_id': currentUser.id,
        'title': title,
        'time': formattedTime,
        'duration_minutes': duration,
        'category': _selectedCategory.name,
        'focus_mode': _selectedFocusMode,
        'completed': false,
      });

      debugPrint(
        'Schedule inserted successfully',
      );

      final ScheduleModel newSchedule =
          ScheduleModel(
        emoji: _selectedCategory.emoji,
        title: title,
        time: formattedTime,
        category: _selectedCategory.name,
        categoryColor:
            _selectedCategory.color,
        focusMode: _selectedFocusMode,
        durationMinutes: duration,
      );

      if (!mounted) {
        return;
      }

      widget.onScheduleSaved(newSchedule);
    } on PostgrestException catch (error) {
      debugPrint(
        'Supabase message: ${error.message}',
      );

      debugPrint(
        'Supabase code: ${error.code}',
      );

      debugPrint(
        'Supabase details: ${error.details}',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Database error: ${error.message}',
          ),
        ),
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to save schedule: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Theme.of(context).brightness ==
            Brightness.dark;

    final MediaQueryData mediaQuery =
        MediaQuery.of(context);

    final double keyboardHeight =
        mediaQuery.viewInsets.bottom;

    final double screenHeight =
        mediaQuery.size.height;

    final Color sheetColor = isDarkMode
        ? AppColors.scheduleBottomSheetDark
        : AppColors.scheduleBottomSheetLight;

    final Color handleColor = isDarkMode
        ? AppColors.scheduleDragHandleDark
        : AppColors.scheduleDragHandleLight;

    final Color titleColor = isDarkMode
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    final Color labelColor = isDarkMode
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    final Color closeButtonColor = isDarkMode
        ? AppColors.scheduleInputDark
        : AppColors.scheduleInputLight;

    return AnimatedPadding(
      duration:
          const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: keyboardHeight,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.82,
        ),
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius:
              const BorderRadius.vertical(
            top: Radius.circular(
              AppConstants.bottomSheetRadius,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.28,
              ),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 4,
              margin:
                  const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: handleColor,
                borderRadius:
                    BorderRadius.circular(20),
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
                    onPressed: _isSaving
                        ? null
                        : widget.onClose,
                    style: IconButton.styleFrom(
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
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior
                        .onDrag,
                padding:
                    const EdgeInsets.fromLTRB(
                  18,
                  4,
                  18,
                  24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _SectionLabel(
                        text: 'Title',
                        color: labelColor,
                      ),
                      const SizedBox(height: 8),
                      TitleTextField(
                        controller:
                            _titleController,
                      ),
                      const SizedBox(height: 18),
                      _SectionLabel(
                        text: 'Category',
                        color: labelColor,
                      ),
                      const SizedBox(height: 10),
                      CategorySelector(
                        selectedCategory:
                            _selectedCategory,
                        onCategorySelected:
                            (category) {
                          setState(() {
                            _selectedCategory =
                                category;
                          });
                        },
                      ),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                _SectionLabel(
                                  text: 'Start Time',
                                  color: labelColor,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TimePickerField(
                                  selectedTime:
                                      _selectedTime,
                                  onTap: _selectTime,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                _SectionLabel(
                                  text:
                                      'Duration (min)',
                                  color: labelColor,
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
                      const SizedBox(height: 18),
                      _SectionLabel(
                        text: 'Focus Mode',
                        color: labelColor,
                      ),
                      const SizedBox(height: 10),
                      FocusModeSelector(
                        selectedMode:
                            _selectedFocusMode,
                        onModeSelected: (mode) {
                          setState(() {
                            _selectedFocusMode =
                                mode;
                          });
                        },
                      ),
                      const SizedBox(height: 18),
                      SaveScheduleButton(
                        isLoading: _isSaving,
                        onPressed: _isSaving
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

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;

  const _SectionLabel({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          AppTextStyles.inputLabelDark.copyWith(
        color: color,
      ),
    );
  }
}