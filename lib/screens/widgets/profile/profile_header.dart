import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onEditPressed;

  const ProfileHeader({
    super.key,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: MaterialLocalizations.of(
            context,
          ).backButtonTooltip,
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        Expanded(
          child: Text(
            localizations.profile,
            textAlign: TextAlign.center,
            style:
                theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: onEditPressed,
          tooltip: localizations.editProfile,
          icon: const Icon(
            Icons.edit,
          ),
        ),
      ],
    );
  }
}