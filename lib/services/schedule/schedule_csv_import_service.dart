import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ScheduleCsvImportService {
  static const List<String> _expectedHeaders =
      <String>[
    'title',
    'date',
    'time',
    'duration_minutes',
    'category',
    'focus_mode',
  ];

  Future<CsvScheduleParseResult?>
      pickCsvFile() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>[
        'csv',
      ],
      withData: true,
    );

    if (result == null ||
        result.files.isEmpty) {
      return null;
    }

    final PlatformFile file =
        result.files.first;

    final String csvText;

    if (file.bytes != null) {
      csvText = utf8.decode(
        file.bytes!,
        allowMalformed: false,
      );
    } else if (file.path != null) {
      csvText = await File(
        file.path!,
      ).readAsString();
    } else {
      throw Exception(
        'Unable to read the selected CSV file.',
      );
    }

    return _parseCsvContent(
      csvText,
      file.name,
    );
  }

  CsvScheduleParseResult _parseCsvContent(
    String csvText,
    String fileName,
  ) {
    final List<String> errors =
        <String>[];

    final List<CsvScheduleData>
        schedules =
        <CsvScheduleData>[];

    try {
      final String cleanedCsvText =
          csvText.replaceFirst(
        '\uFEFF',
        '',
      );

      final List<List<dynamic>> rows =
          Csv().decode(
        cleanedCsvText,
      );

      if (rows.isEmpty) {
        errors.add(
          'CSV file is empty.',
        );

        return CsvScheduleParseResult(
          fileName: fileName,
          schedules: schedules,
          errors: errors,
        );
      }

      final List<String> header =
          rows.first
              .map(
                (
                  dynamic value,
                ) =>
                    value
                        .toString()
                        .trim()
                        .toLowerCase(),
              )
              .toList();

      if (!_validateHeader(
        header,
        errors,
      )) {
        return CsvScheduleParseResult(
          fileName: fileName,
          schedules: schedules,
          errors: errors,
        );
      }

      for (
        int index = 1;
        index < rows.length;
        index++
      ) {
        final List<dynamic> row =
            rows[index];

        final int rowNumber =
            index + 1;

        final bool isEmptyRow =
            row.every(
          (
            dynamic field,
          ) {
            return field == null ||
                field
                    .toString()
                    .trim()
                    .isEmpty;
          },
        );

        if (isEmptyRow) {
          continue;
        }

        if (row.length <
            _expectedHeaders.length) {
          errors.add(
            'Row $rowNumber: '
            'Missing one or more columns.',
          );

          continue;
        }

        final String title =
            row[0]
                .toString()
                .trim();

        final String dateText =
            row[1]
                .toString()
                .trim();

        final String timeText =
            row[2]
                .toString()
                .trim();

        final String durationText =
            row[3]
                .toString()
                .trim();

        final String category =
            row[4]
                .toString()
                .trim();

        final String focusMode =
            row[5]
                .toString()
                .trim();

        if (title.isEmpty) {
          errors.add(
            'Row $rowNumber: '
            'Title is required.',
          );

          continue;
        }

        if (dateText.isEmpty) {
          errors.add(
            'Row $rowNumber: '
            'Date is required.',
          );

          continue;
        }

        if (timeText.isEmpty) {
          errors.add(
            'Row $rowNumber: '
            'Time is required.',
          );

          continue;
        }

        if (durationText.isEmpty) {
          errors.add(
            'Row $rowNumber: '
            'Duration is required.',
          );

          continue;
        }

        if (category.isEmpty) {
          errors.add(
            'Row $rowNumber: '
            'Category is required.',
          );

          continue;
        }

        final DateTime? date =
            _parseDate(
          dateText,
        );

        if (date == null) {
          errors.add(
            'Row $rowNumber: '
            'Invalid date "$dateText". '
            'Use YYYY-MM-DD, MM/DD/YY, '
            'or MM/DD/YYYY.',
          );

          continue;
        }

        final TimeOfDay? time =
            _parseTime(
          timeText,
        );

        if (time == null) {
          errors.add(
            'Row $rowNumber: '
            'Invalid time "$timeText". '
            'Use HH:mm, h:mm AM, '
            'or h:mm PM.',
          );

          continue;
        }

        final int? duration =
            int.tryParse(
          durationText,
        );

        if (duration == null ||
            duration <= 0) {
          errors.add(
            'Row $rowNumber: '
            'Duration must be a '
            'positive integer.',
          );

          continue;
        }

        final DateTime scheduleDateTime =
            DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        if (!scheduleDateTime.isAfter(
          DateTime.now(),
        )) {
          errors.add(
            'Row $rowNumber: '
            'Schedule date and time must '
            'be in the future.',
          );

          continue;
        }

        schedules.add(
          CsvScheduleData(
            rowNumber:
                rowNumber,
            title:
                title,
            scheduleDateTime:
                scheduleDateTime,
            durationMinutes:
                duration,
            category:
                category,
            focusMode:
                focusMode.isEmpty
                    ? 'Normal Mode'
                    : focusMode,
          ),
        );
      }
    } on FormatException catch (error) {
      errors.add(
        'The selected CSV file contains '
        'invalid text or formatting: '
        '${error.message}',
      );
    } catch (error) {
      errors.add(
        'Unable to parse CSV file: '
        '$error',
      );
    }

    return CsvScheduleParseResult(
      fileName: fileName,
      schedules: schedules,
      errors: errors,
    );
  }

  bool _validateHeader(
    List<String> header,
    List<String> errors,
  ) {
    if (header.length <
        _expectedHeaders.length) {
      errors.add(
        'CSV header row is incomplete. '
        'Expected columns: '
        '${_expectedHeaders.join(', ')}.',
      );

      return false;
    }

    for (
      int index = 0;
      index < _expectedHeaders.length;
      index++
    ) {
      if (header[index] !=
          _expectedHeaders[index]) {
        errors.add(
          'CSV header is invalid. '
          'Expected '
          '"${_expectedHeaders[index]}" '
          'at column ${index + 1}, '
          'but found "${header[index]}".',
        );
      }
    }

    return errors.isEmpty;
  }

  DateTime? _parseDate(
    String value,
  ) {
    final String cleanValue =
        value.trim();

    if (cleanValue.isEmpty) {
      return null;
    }

    // Format: YYYY-MM-DD
    final RegExp isoPattern =
        RegExp(
      r'^(\d{4})-(\d{1,2})-(\d{1,2})$',
    );

    final RegExpMatch? isoMatch =
        isoPattern.firstMatch(
      cleanValue,
    );

    if (isoMatch != null) {
      final int year =
          int.parse(
        isoMatch.group(1)!,
      );

      final int month =
          int.parse(
        isoMatch.group(2)!,
      );

      final int day =
          int.parse(
        isoMatch.group(3)!,
      );

      return _createValidDate(
        year: year,
        month: month,
        day: day,
      );
    }

    // Formats:
    // M/D/YY
    // MM/DD/YY
    // M/D/YYYY
    // MM/DD/YYYY
    final RegExp slashPattern =
        RegExp(
      r'^(\d{1,2})/(\d{1,2})/(\d{2}|\d{4})$',
    );

    final RegExpMatch? slashMatch =
        slashPattern.firstMatch(
      cleanValue,
    );

    if (slashMatch != null) {
      final int month =
          int.parse(
        slashMatch.group(1)!,
      );

      final int day =
          int.parse(
        slashMatch.group(2)!,
      );

      final String yearText =
          slashMatch.group(3)!;

      final int year =
          yearText.length == 2
              ? 2000 +
                  int.parse(
                    yearText,
                  )
              : int.parse(
                  yearText,
                );

      return _createValidDate(
        year: year,
        month: month,
        day: day,
      );
    }

    return null;
  }

  DateTime? _createValidDate({
    required int year,
    required int month,
    required int day,
  }) {
    if (year < 2000 ||
        year > 2100 ||
        month < 1 ||
        month > 12 ||
        day < 1 ||
        day > 31) {
      return null;
    }

    final DateTime date =
        DateTime(
      year,
      month,
      day,
    );

    // DateTime automatically changes invalid dates.
    // For example, February 31 can become March 3.
    // This check prevents that.
    if (date.year != year ||
        date.month != month ||
        date.day != day) {
      return null;
    }

    return date;
  }

  TimeOfDay? _parseTime(
    String value,
  ) {
    final String cleanValue =
        value
            .trim()
            .toUpperCase();

    if (cleanValue.isEmpty) {
      return null;
    }

    // Format: HH:mm
    final RegExp twentyFourHourPattern =
        RegExp(
      r'^(\d{1,2}):(\d{2})$',
    );

    final RegExpMatch?
        twentyFourHourMatch =
        twentyFourHourPattern.firstMatch(
      cleanValue,
    );

    if (twentyFourHourMatch != null) {
      final int hour =
          int.parse(
        twentyFourHourMatch.group(1)!,
      );

      final int minute =
          int.parse(
        twentyFourHourMatch.group(2)!,
      );

      if (hour < 0 ||
          hour > 23 ||
          minute < 0 ||
          minute > 59) {
        return null;
      }

      return TimeOfDay(
        hour: hour,
        minute: minute,
      );
    }

    // Formats:
    // 9:00 AM
    // 09:00 AM
    // 3:30 PM
    final RegExp twelveHourPattern =
        RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
    );

    final RegExpMatch?
        twelveHourMatch =
        twelveHourPattern.firstMatch(
      cleanValue,
    );

    if (twelveHourMatch == null) {
      return null;
    }

    int hour =
        int.parse(
      twelveHourMatch.group(1)!,
    );

    final int minute =
        int.parse(
      twelveHourMatch.group(2)!,
    );

    final String period =
        twelveHourMatch.group(3)!;

    if (hour < 1 ||
        hour > 12 ||
        minute < 0 ||
        minute > 59) {
      return null;
    }

    if (period == 'AM') {
      if (hour == 12) {
        hour = 0;
      }
    } else {
      if (hour != 12) {
        hour += 12;
      }
    }

    return TimeOfDay(
      hour: hour,
      minute: minute,
    );
  }
}

class CsvScheduleParseResult {
  final String fileName;
  final List<CsvScheduleData> schedules;
  final List<String> errors;

  CsvScheduleParseResult({
    required this.fileName,
    required this.schedules,
    required this.errors,
  });
}

class CsvScheduleData {
  final int rowNumber;
  final String title;
  final DateTime scheduleDateTime;
  final int durationMinutes;
  final String category;
  final String focusMode;

  CsvScheduleData({
    required this.rowNumber,
    required this.title,
    required this.scheduleDateTime,
    required this.durationMinutes,
    required this.category,
    required this.focusMode,
  });
}