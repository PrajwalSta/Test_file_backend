import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../l10n/app_localizations.dart';

import '../../../models/schedule_model.dart';
import '../../../services/schedule_service.dart';
import '../../../services/schedule/schedule_csv_import_service.dart';
import '../../../services/schedule/schedule_template_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_text_styles.dart';
import 'category_selector.dart';
import 'duration_field.dart';
import 'focus_mode_selector.dart';
import 'save_schedule_button.dart';
import 'schedule_upload_card.dart';
import 'time_picker_field.dart';
import 'title_text_field.dart';

typedef ScheduleSavedCallback = Future<void> Function(
  ScheduleModel schedule,
);

class AddScheduleSheet extends StatefulWidget {
  final ScheduleSavedCallback onScheduleSaved;
  final VoidCallback onClose;

  const AddScheduleSheet({
    super.key,
    required this.onScheduleSaved,
    required this.onClose,
  });

  static Future<void> show({
    required BuildContext context,
    required ScheduleSavedCallback onScheduleSaved,
    VoidCallback? onClose,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return AddScheduleSheet(
          onScheduleSaved: onScheduleSaved,
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _durationController =
      TextEditingController(
    text: '60',
  );

  final ScheduleService _scheduleService =
      ScheduleService();

  final ScheduleCsvImportService _csvImportService =
      ScheduleCsvImportService();

  final ScheduleTemplateService _templateService =
      ScheduleTemplateService();

  ScheduleCategory _selectedCategory =
      CategorySelector.categories.first;

  String _selectedFocusMode = 'Study Mode';

  late TimeOfDay _selectedTime;
  late DateTime _selectedDate;

  bool _isSaving = false;
  bool _isImporting = false;
  bool _isDownloadingTemplate = false;

  String? _selectedFileName;

  bool get _isBusy {
    return _isSaving ||
        _isImporting ||
        _isDownloadingTemplate;
  }

  @override
  void initState() {
    super.initState();

    final DateTime defaultDateTime =
        DateTime.now().add(
      const Duration(
        minutes: 10,
      ),
    );

    _selectedDate = DateTime(
      defaultDateTime.year,
      defaultDateTime.month,
      defaultDateTime.day,
    );

    _selectedTime = TimeOfDay(
      hour: defaultDateTime.hour,
      minute: defaultDateTime.minute,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    if (_isBusy) {
      return;
    }

    final ThemeData theme =
        Theme.of(context);

    final Color activeColor =
        theme.colorScheme.primary;

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
              primary: activeColor,
              secondary: activeColor,
            ),
            timePickerTheme:
                TimePickerThemeData(
              dialHandColor:
                  activeColor,
              hourMinuteColor:
                  activeColor.withValues(
                alpha: 0.15,
              ),
              hourMinuteTextColor:
                  theme.colorScheme
                      .onSurface,
              dayPeriodColor:
                  activeColor.withValues(
                alpha: 0.15,
              ),
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
      _selectedTime =
          selectedTime;
    });
  }

  Future<void> _selectDate() async {
    if (_isBusy) {
      return;
    }

    final ThemeData theme =
        Theme.of(context);

    final Color activeColor =
        theme.colorScheme.primary;

    final DateTime today =
        DateTime.now();

    final DateTime firstDate =
        DateTime(
      today.year,
      today.month,
      today.day,
    );

    final DateTime? selectedDate =
        await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
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
              primary: activeColor,
              secondary: activeColor,
            ),
            datePickerTheme:
                DatePickerThemeData(
              todayBorder:
                  BorderSide(
                color: activeColor,
              ),
              todayForegroundColor:
                  WidgetStatePropertyAll<Color>(
                activeColor,
              ),
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
      _selectedDate =
          selectedDate;
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
        time.minute
            .toString()
            .padLeft(
              2,
              '0',
            );

    final String period =
        time.period == DayPeriod.am
            ? AppLocalizations.of(context)!.am
            : AppLocalizations.of(context)!.pm;

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

  String _cleanError(
    Object error,
  ) {
    return error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );
  }

  ScheduleCategory? _findCategory(
    String categoryName,
  ) {
    final String normalisedName =
        categoryName.trim().toLowerCase();

    for (
      final ScheduleCategory category
      in CategorySelector.categories
    ) {
      if (category.name.trim().toLowerCase() ==
          normalisedName) {
        return category;
      }
    }

    return null;
  }

  Future<void> _downloadCsvTemplate() async {
    if (_isBusy) {
      return;
    }

    setState(() {
      _isDownloadingTemplate = true;
    });

    try {
      await _templateService.downloadTemplate();

      if (!mounted) {
        return;
      }

      _showMessage(
        AppLocalizations.of(context)!.csvTemplateReady,
      );
    } catch (error, stackTrace) {
      debugPrint(
        'CSV TEMPLATE ERROR: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        AppLocalizations.of(context)!.unableToPrepareTemplate(
          _cleanError(error),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloadingTemplate = false;
        });
      }
    }
  }

  Future<void> _importCsvFile() async {
    if (_isBusy) {
      return;
    }

    FocusScope.of(context).unfocus();

    final User? currentUser =
        Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      _showMessage(
        AppLocalizations.of(context)!.loginBeforeImportingSchedules,
      );
      return;
    }

    try {
      final CsvScheduleParseResult? result =
          await _csvImportService.pickCsvFile();

      if (result == null || !mounted) {
        return;
      }

      setState(() {
        _selectedFileName = result.fileName;
      });

      final List<CsvScheduleData> validSchedules =
          <CsvScheduleData>[];

      final List<String> allErrors =
          List<String>.from(
        result.errors,
      );

      for (
        final CsvScheduleData schedule
        in result.schedules
      ) {
        final ScheduleCategory? category =
            _findCategory(
          schedule.category,
        );

        if (category == null) {
          allErrors.add(
            AppLocalizations.of(context)!
                .unknownCategoryAtRow(
              schedule.rowNumber,
              schedule.category,
            ),
          );
          continue;
        }

        validSchedules.add(
          schedule,
        );
      }

      if (validSchedules.isEmpty) {
        await _showImportErrors(
          allErrors,
        );
        return;
      }

      final bool confirmed =
          await _showImportPreview(
        fileName: result.fileName,
        schedules: validSchedules,
        skippedCount: allErrors.length,
      );

      if (!confirmed || !mounted) {
        return;
      }

      setState(() {
        _isImporting = true;
      });

      int importedCount = 0;

      ScheduleModel? lastImportedSchedule;

      final List<String> databaseErrors =
          <String>[];

      for (
        final CsvScheduleData csvSchedule
        in validSchedules
      ) {
        try {
          final ScheduleCategory? category =
              _findCategory(
            csvSchedule.category,
          );

          if (category == null) {
            throw Exception(
              AppLocalizations.of(context)!.unknownCategory,
            );
          }

          final TimeOfDay importedTime =
              TimeOfDay.fromDateTime(
            csvSchedule.scheduleDateTime,
          );

          final String formattedTime =
              _formatTime(
            importedTime,
          );

          final Map<String, dynamic> insertedRow =
              await _scheduleService.addSchedule(
            title: csvSchedule.title,
            time: formattedTime,
            scheduleDateTime:
                csvSchedule.scheduleDateTime,
            durationMinutes:
                csvSchedule.durationMinutes,
            category: category.name,
            focusMode: csvSchedule.focusMode,
          );

          final String? scheduleId =
              insertedRow['id']?.toString();

          if (scheduleId == null ||
              scheduleId.isEmpty) {
            throw Exception(
              AppLocalizations.of(context)!.scheduleIdNotReturned,
            );
          }

          final ScheduleModel newSchedule =
              ScheduleModel(
            id: scheduleId,
            emoji: category.emoji,
            title: csvSchedule.title,
            time: formattedTime,
            scheduleDate:
                csvSchedule.scheduleDateTime,
            category: category.name,
            categoryColor: category.color,
            focusMode: csvSchedule.focusMode,
            durationMinutes:
                csvSchedule.durationMinutes,
            completed:
                insertedRow['completed'] == true,
            notificationId:
                _parseNotificationId(
              insertedRow['notification_id'],
            ),
          );

          lastImportedSchedule =
              newSchedule;

          importedCount++;
        } catch (error) {
          databaseErrors.add(
            AppLocalizations.of(context)!
                .rowError(
              csvSchedule.rowNumber,
              _cleanError(error),
            ),
          );
        }
      }

      allErrors.addAll(
        databaseErrors,
      );

      if (!mounted) {
        return;
      }

      if (allErrors.isNotEmpty) {
        await _showImportErrors(
          allErrors,
        );
      }

      if (!mounted) {
        return;
      }

      if (importedCount == 0 ||
          lastImportedSchedule == null) {
        _showMessage(
          AppLocalizations.of(context)!.noSchedulesImported,
        );
        return;
      }

      await widget.onScheduleSaved(
        lastImportedSchedule,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        allErrors.isEmpty
            ? AppLocalizations.of(context)!
                .schedulesImportedSuccessfully(
                importedCount,
              )
            : AppLocalizations.of(context)!
                .schedulesImportedWithSkipped(
                importedCount,
                allErrors.length,
              ),
      );

      widget.onClose();
    } catch (error, stackTrace) {
      debugPrint(
        'CSV IMPORT ERROR: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        AppLocalizations.of(context)!.unableToImportCsv(
          _cleanError(error),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  Future<bool> _showImportPreview({
    required String fileName,
    required List<CsvScheduleData> schedules,
    required int skippedCount,
  }) async {
    final bool? confirmed =
        await showDialog<bool>(
      context: context,
      builder: (
        BuildContext dialogContext,
      ) {
        final AppLocalizations localizations =
            AppLocalizations.of(dialogContext)!;

        final int previewCount =
            schedules.length > 5
                ? 5
                : schedules.length;

        return AlertDialog(
          title: Text(
            localizations.importSchedulesQuestion,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  localizations.validSchedulesFound(
                    schedules.length,
                  ),
                ),
                if (skippedCount > 0) ...[
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    localizations.rowsWillBeSkipped(
                      skippedCount,
                    ),
                    style: const TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                ],
                const SizedBox(
                  height: 12,
                ),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxHeight: 340,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: previewCount,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                    ) {
                      final CsvScheduleData
                          schedule =
                          schedules[index];

                      return ListTile(
                        contentPadding:
                            EdgeInsets.zero,
                        leading:
                            const CircleAvatar(
                          child: Icon(
                            Icons
                                .event_note_rounded,
                          ),
                        ),
                        title: Text(
                          schedule.title,
                        ),
                        subtitle: Text(
                          '${_formatDisplayDate(
                            schedule
                                .scheduleDateTime,
                          )} • '
                          '${_formatTime(
                            TimeOfDay
                                .fromDateTime(
                              schedule
                                  .scheduleDateTime,
                            ),
                          )}\n'
                          '${schedule.category} • '
                          '${localizations.minutesShort(
                            schedule.durationMinutes,
                          )}',
                        ),
                        isThreeLine: true,
                      );
                    },
                  ),
                ),
                if (schedules.length >
                    previewCount) ...[
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    localizations.andMore(
                      schedules.length - previewCount,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: Text(
                localizations.cancel,
              ),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              icon: const Icon(
                Icons.upload_rounded,
              ),
              label: Text(
                localizations.importCount(
                  schedules.length,
                ),
              ),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  Future<void> _showImportErrors(
    List<String> errors,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (
        BuildContext dialogContext,
      ) {
        final AppLocalizations localizations =
            AppLocalizations.of(dialogContext)!;

        return AlertDialog(
          title: Text(
            localizations.importProblems,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: errors.isEmpty
                ? Text(
                    localizations.noValidSchedulesFound,
                  )
                : ConstrainedBox(
                    constraints:
                        const BoxConstraints(
                      maxHeight: 420,
                    ),
                    child:
                        ListView.separated(
                      shrinkWrap: true,
                      itemCount:
                          errors.length,
                      separatorBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        return const Divider();
                      },
                      itemBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        return Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Icon(
                              Icons
                                  .error_outline_rounded,
                              color:
                                  Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                errors[index],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },
              child: Text(
                localizations.close,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveSchedule() async {
    if (_isBusy) {
      return;
    }

    FocusScope.of(context).unfocus();

    final FormState? formState =
        _formKey.currentState;

    if (formState == null ||
        !formState.validate()) {
      return;
    }

    final String title =
        _titleController.text.trim();

    if (title.isEmpty) {
      _showMessage(
        AppLocalizations.of(context)!.enterScheduleTitle,
      );
      return;
    }

    final int? duration =
        int.tryParse(
      _durationController.text.trim(),
    );

    if (duration == null ||
        duration <= 0) {
      _showMessage(
        AppLocalizations.of(context)!.enterValidDuration,
      );
      return;
    }

    final User? currentUser =
        Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      _showMessage(
        AppLocalizations.of(context)!.loginBeforeSavingSchedule,
      );
      return;
    }

    final DateTime scheduleDateTime =
        _buildScheduleDateTime();

    if (!scheduleDateTime.isAfter(
      DateTime.now(),
    )) {
      _showMessage(
        AppLocalizations.of(context)!.selectFutureDateTime,
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final String formattedTime =
          _formatTime(
        _selectedTime,
      );

      debugPrint(
        'Saving schedule...',
      );
      debugPrint(
        'User ID: ${currentUser.id}',
      );
      debugPrint(
        'Title: $title',
      );
      debugPrint(
        'Time: $formattedTime',
      );
      debugPrint(
        'Scheduled at: '
        '${scheduleDateTime.toIso8601String()}',
      );
      debugPrint(
        'Duration: $duration',
      );
      debugPrint(
        'Category: '
        '${_selectedCategory.name}',
      );
      debugPrint(
        'Focus mode: '
        '$_selectedFocusMode',
      );

      final Map<String, dynamic> insertedRow =
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

      debugPrint(
        'Inserted schedule: '
        '$insertedRow',
      );

      final String? scheduleId =
          insertedRow['id']?.toString();

      if (scheduleId == null ||
          scheduleId.isEmpty) {
        throw Exception(
          AppLocalizations.of(context)!.scheduleIdNotReturned,
        );
      }

      final ScheduleModel newSchedule =
          ScheduleModel(
        id: scheduleId,
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
          insertedRow['notification_id'],
        ),
      );

      if (!mounted) {
        return;
      }

      await widget.onScheduleSaved(
        newSchedule,
      );

      if (!mounted) {
        return;
      }

      widget.onClose();
    } on PostgrestException catch (error, stackTrace) {
      debugPrint(
        'SUPABASE SAVE ERROR: '
        '${error.message}',
      );
      debugPrint(
        'SUPABASE ERROR CODE: '
        '${error.code}',
      );
      debugPrint(
        'SUPABASE ERROR DETAILS: '
        '${error.details}',
      );
      debugPrint(
        'SUPABASE ERROR HINT: '
        '${error.hint}',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        AppLocalizations.of(context)!.databaseError(
          error.message,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'SCHEDULE SAVE ERROR: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        AppLocalizations.of(context)!.unableToSaveSchedule(
          _cleanError(error),
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

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final bool isDarkMode =
        theme.brightness ==
            Brightness.dark;

    final Color activeColor =
        theme.colorScheme.primary;

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
            ? AppColors
                .textSecondaryDark
            : AppColors
                .textSecondaryLight;

    final Color closeButtonColor =
        isDarkMode
            ? AppColors
                .scheduleInputDark
            : AppColors
                .scheduleInputLight;

    final Color inputColor =
        isDarkMode
            ? AppColors
                .scheduleInputDark
            : AppColors
                .scheduleInputLight;

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
              screenHeight * 0.92,
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
                  const Offset(
                0,
                -8,
              ),
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
                      localizations.addSchedule,
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
                        _isBusy
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
                      ScheduleUploadCard(
                        isDarkMode:
                            isDarkMode,
                        isImporting:
                            _isImporting,
                        isDownloading:
                            _isDownloadingTemplate,
                        selectedFileName:
                            _selectedFileName,
                        onUploadPressed:
                            _isBusy
                                ? null
                                : _importCsvFile,
                        onDownloadPressed:
                            _isBusy
                                ? null
                                : _downloadCsvTemplate,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: labelColor
                                  .withValues(
                                alpha: 0.25,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 12,
                            ),
                            child: Text(
                              localizations.orAddManually,
                              style: TextStyle(
                                color:
                                    labelColor,
                                fontSize: 11,
                                fontWeight:
                                    FontWeight
                                        .bold,
                                letterSpacing:
                                    0.7,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: labelColor
                                  .withValues(
                                alpha: 0.25,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      _SectionLabel(
                        text: localizations.title,
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
                        text: localizations.category,
                        color: labelColor,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CategorySelector(
                        selectedCategory:
                            _selectedCategory,
                        onCategorySelected:
                            (
                          ScheduleCategory
                              category,
                        ) {
                          if (_isBusy) {
                            return;
                          }

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
                        text: localizations.date,
                        color: labelColor,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap:
                            _isBusy
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
                              color: activeColor
                                  .withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons
                                    .calendar_month_rounded,
                                color:
                                    activeColor,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Text(
                                  _formatDisplayDate(
                                    _selectedDate,
                                  ),
                                  style: TextStyle(
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
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                _SectionLabel(
                                  text:
                                      localizations.startTime,
                                  color:
                                      labelColor,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TimePickerField(
                                  selectedTime:
                                      _selectedTime,
                                  onTap:
                                      _isBusy
                                          ? () {}
                                          : _selectTime,
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
                                      localizations.durationMinutes,
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
                        text: localizations.focusMode,
                        color: labelColor,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FocusModeSelector(
                        selectedMode:
                            _selectedFocusMode,
                        onModeSelected:
                            (
                          String mode,
                        ) {
                          if (_isBusy) {
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
                            _isBusy
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
