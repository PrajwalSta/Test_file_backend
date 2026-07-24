import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/sleep_setting_service.dart';
import '../../widgets/settings/sleep_mode/sleep_mode_switch_card.dart';
import '../../widgets/settings/sleep_mode/sleep_save_button.dart';
import '../../widgets/settings/sleep_mode/sleep_time_card.dart';

class SleepModeScreen extends StatefulWidget {
  const SleepModeScreen({
    super.key,
  });

  @override
  State<SleepModeScreen> createState() =>
      _SleepModeScreenState();
}

class _SleepModeScreenState
    extends State<SleepModeScreen> {
  final SleepSettingService
      _sleepSettingService =
      SleepSettingService();

  TimeOfDay _sleepTime =
      const TimeOfDay(
    hour: 22,
    minute: 0,
  );

  TimeOfDay _wakeTime =
      const TimeOfDay(
    hour: 7,
    minute: 0,
  );

  bool _enabled = true;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  TimeOfDay _parseDatabaseTime(
    String value,
    TimeOfDay fallback,
  ) {
    final List<String> parts =
        value.split(':');

    if (parts.length < 2) {
      return fallback;
    }

    final int? hour =
        int.tryParse(parts[0]);

    final int? minute =
        int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return fallback;
    }

    return TimeOfDay(
      hour: hour,
      minute: minute,
    );
  }

  String _formatDatabaseTime(
    TimeOfDay time,
  ) {
    final String hour =
        time.hour
            .toString()
            .padLeft(
              2,
              '0',
            );

    final String minute =
        time.minute
            .toString()
            .padLeft(
              2,
              '0',
            );

    return '$hour:$minute:00';
  }

  Future<void> _loadSettings() async {
    try {
      final Map<String, dynamic>
          settings =
          await _sleepSettingService
              .getSleepSettings();

      if (!mounted) {
        return;
      }

      setState(() {
        _sleepTime =
            _parseDatabaseTime(
          settings['sleep_time']
                  ?.toString() ??
              '22:00:00',
          const TimeOfDay(
            hour: 22,
            minute: 0,
          ),
        );

        _wakeTime =
            _parseDatabaseTime(
          settings['wake_time']
                  ?.toString() ??
              '07:00:00',
          const TimeOfDay(
            hour: 7,
            minute: 0,
          ),
        );

        _enabled =
            settings['enabled'] == true;

        _isLoading = false;
      });
    } catch (error) {
      debugPrint(
        'Unable to load Sleep Mode settings: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      final AppLocalizations localizations =
          AppLocalizations.of(context)!;

      _showMessage(
        localizations
            .unableToLoadSleepModeSettings,
      );
    }
  }

  Future<void> _selectSleepTime() async {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final TimeOfDay? selected =
        await showTimePicker(
      context: context,
      initialTime: _sleepTime,
      helpText:
          localizations.selectBedtime,
      cancelText:
          localizations.cancel,
      confirmText:
          localizations.ok,
    );

    if (selected == null ||
        !mounted) {
      return;
    }

    setState(() {
      _sleepTime = selected;
    });
  }

  Future<void> _selectWakeTime() async {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final TimeOfDay? selected =
        await showTimePicker(
      context: context,
      initialTime: _wakeTime,
      helpText:
          localizations.selectWakeUpTime,
      cancelText:
          localizations.cancel,
      confirmText:
          localizations.ok,
    );

    if (selected == null ||
        !mounted) {
      return;
    }

    setState(() {
      _wakeTime = selected;
    });
  }

  Future<void> _saveSettings() async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _sleepSettingService
          .saveSleepSettings(
        sleepTime:
            _formatDatabaseTime(
          _sleepTime,
        ),
        wakeTime:
            _formatDatabaseTime(
          _wakeTime,
        ),
        enabled: _enabled,
      );

      if (!mounted) {
        return;
      }

      final AppLocalizations localizations =
          AppLocalizations.of(context)!;

      _showMessage(
        localizations
            .sleepModeSettingsSaved,
      );

      Navigator.pop(
        context,
        true,
      );
    } catch (error) {
      debugPrint(
        'Unable to save Sleep Mode settings: $error',
      );

      if (!mounted) {
        return;
      }

      final AppLocalizations localizations =
          AppLocalizations.of(context)!;

      _showMessage(
        localizations
            .unableToSaveSleepModeSettings,
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
    final ScaffoldMessengerState messenger =
        ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
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

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor:
            theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor:
              theme.scaffoldBackgroundColor,
          title: Text(
            localizations.sleepMode,
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(
            color:
                colorScheme.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            theme.scaffoldBackgroundColor,
        title: Text(
          localizations.sleepMode,
        ),
      ),
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior
                  .onDrag,
          padding:
              const EdgeInsets.all(
            20,
          ),
          children: [
            Text(
              localizations.sleepSchedule,
              style: theme
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                color:
                    colorScheme.onSurface,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              localizations
                  .sleepScheduleDescription,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: colorScheme
                    .onSurfaceVariant,
                height: 1.45,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            SleepModeSwitchCard(
              enabled: _enabled,
              onChanged: (
                bool value,
              ) {
                setState(() {
                  _enabled = value;
                });
              },
            ),

            const SizedBox(
              height: 16,
            ),

            SleepTimeCard(
              icon:
                  Icons.bedtime_rounded,
              title:
                  localizations.bedtime,
              time:
                  _sleepTime.format(
                context,
              ),
              onTap:
                  _selectSleepTime,
            ),

            const SizedBox(
              height: 16,
            ),

            SleepTimeCard(
              icon:
                  Icons.wb_sunny_rounded,
              title: localizations
                  .wakeUpTime,
              time:
                  _wakeTime.format(
                context,
              ),
              onTap:
                  _selectWakeTime,
            ),

            const SizedBox(
              height: 32,
            ),

            SleepSaveButton(
              isSaving: _isSaving,
              onPressed:
                  _saveSettings,
            ),
          ],
        ),
      ),
    );
  }
}