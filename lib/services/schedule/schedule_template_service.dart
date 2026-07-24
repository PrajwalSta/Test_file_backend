import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ScheduleTemplateService {
  Future<void> downloadTemplate() async {
    final Directory temporaryDirectory =
        await getTemporaryDirectory();

    // Ensure the macOS cache/temp directory exists.
    if (!await temporaryDirectory.exists()) {
      await temporaryDirectory.create(
        recursive: true,
      );
    }

    final File templateFile =
        File(
      '${temporaryDirectory.path}/'
      'focus_glow_schedule_template.csv',
    );

    const String csvContent =
        'title,date,time,duration_minutes,category,focus_mode\n'
        'Morning Study,2026-07-23,15:30,60,Study,Study Mode\n'
        'Team Meeting,2026-07-24,14:30,45,Work,Work Mode\n'
        'Gym Session,2026-07-24,18:00,60,Health,Normal Mode\n';

    // Creates the file and any required parent folders.
    await templateFile.create(
      recursive: true,
    );

    await templateFile.writeAsString(
      csvContent,
      flush: true,
    );

    final bool fileExists =
        await templateFile.exists();

    if (!fileExists) {
      throw Exception(
        'CSV template could not be created.',
      );
    }

    await SharePlus.instance.share(
      ShareParams(
        title: 'Focus Glow schedule template',
        subject: 'Focus Glow CSV schedule template',
        text:
            'Download and edit this CSV file, then upload it into Focus Glow.',
        files: <XFile>[
          XFile(
            templateFile.path,
            mimeType: 'text/csv',
          ),
        ],
        fileNameOverrides: const <String>[
          'focus_glow_schedule_template.csv',
        ],
      ),
    );
  }
}