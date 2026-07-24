import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class SleepSaveButton extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onPressed;

  const SleepSaveButton({
    super.key,
    required this.isSaving,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed:
            isSaving ? null : onPressed,
        icon: isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Icon(
                Icons.save_rounded,
              ),
        label: Text(
          isSaving
              ? localizations.saving
              : localizations.saveSettings,
        ),
      ),
    );
  }
}