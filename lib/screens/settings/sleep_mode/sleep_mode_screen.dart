import 'package:flutter/material.dart';

import '../../../services/sleep_setting_service.dart';
import '../../widgets/settings/sleep_mode/sleep_mode_switch_card.dart';
import '../../widgets/settings/sleep_mode/sleep_save_button.dart';
import '../../widgets/settings/sleep_mode/sleep_time_card.dart';

class SleepModeScreen extends StatefulWidget {
  const SleepModeScreen({super.key});

  @override
  State<SleepModeScreen> createState() =>
      _SleepModeScreenState();
}

class _SleepModeScreenState extends State<SleepModeScreen> {
  final SleepSettingService _sleepSettingService =
      SleepSettingService();

  TimeOfDay _sleepTime = const TimeOfDay(
    hour: 22,
    minute: 0,
  );

  TimeOfDay _wakeTime = const TimeOfDay(
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
    final List<String> parts = value.split(':');

    if (parts.length < 2) {
      return fallback;
    }

    final int? hour = int.tryParse(parts[0]);
    final int? minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) {
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
        time.hour.toString().padLeft(2, '0');

    final String minute =
        time.minute.toString().padLeft(2, '0');

    return '$hour:$minute:00';
  }

  Future<void> _loadSettings() async {
    try {
      final Map<String, dynamic> settings =
          await _sleepSettingService
              .getSleepSettings();

      if (!mounted) {
        return;
      }

      setState(() {
        _sleepTime = _parseDatabaseTime(
          settings['sleep_time']?.toString() ??
              '22:00:00',
          const TimeOfDay(
            hour: 22,
            minute: 0,
          ),
        );

        _wakeTime = _parseDatabaseTime(
          settings['wake_time']?.toString() ??
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
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      _showMessage(
        'Unable to load Sleep Mode settings: $error',
      );
    }
  }

  Future<void> _selectSleepTime() async {
    final TimeOfDay? selected =
        await showTimePicker(
      context: context,
      initialTime: _sleepTime,
      helpText: 'Select bedtime',
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _sleepTime = selected;
    });
  }

  Future<void> _selectWakeTime() async {
    final TimeOfDay? selected =
        await showTimePicker(
      context: context,
      initialTime: _wakeTime,
      helpText: 'Select wake-up time',
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _wakeTime = selected;
    });
  }

  Future<void> _saveSettings() async {
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

      _showMessage(
        'Sleep Mode settings saved.',
      );

      // Return true to SettingsScreen.
      // SettingsScreen then tells MainScreen/HomeScreen
      // to refresh Sleep Mode.
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to save Sleep Mode settings: $error',
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
        .showSnackBar(
      SnackBar(
        content: Text(message),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor:
            theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title:
              const Text('Sleep Mode'),
        ),
        body: const Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            theme.scaffoldBackgroundColor,
        title:
            const Text('Sleep Mode'),
      ),
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.all(20),
          children: [
            Text(
              'Sleep Schedule',
              style: theme
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    fontWeight:
                        FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 8),

            Text(
              'Set your bedtime and wake-up time to maintain a consistent sleep routine.',
              style:
                  theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            SleepModeSwitchCard(
              enabled: _enabled,
              onChanged: (value) {
                setState(() {
                  _enabled = value;
                });
              },
            ),

            const SizedBox(height: 16),

            SleepTimeCard(
              icon:
                  Icons.bedtime_rounded,
              title: 'Bedtime',
              time:
                  _sleepTime.format(
                context,
              ),
              onTap:
                  _selectSleepTime,
            ),

            const SizedBox(height: 16),

            SleepTimeCard(
              icon:
                  Icons.wb_sunny_rounded,
              title: 'Wake-up Time',
              time:
                  _wakeTime.format(
                context,
              ),
              onTap:
                  _selectWakeTime,
            ),

            const SizedBox(height: 32),

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