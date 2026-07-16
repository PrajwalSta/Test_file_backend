import 'package:flutter/material.dart';

class SleepSaveButton
    extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onPressed;

  const SleepSaveButton({
    super.key,
    required this.isSaving,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
              ? 'Saving...'
              : 'Save Settings',
        ),
      ),
    );
  }
}