import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_text_styles.dart';

class SaveScheduleButton
    extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const SaveScheduleButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final ThemeData theme =
        Theme.of(context);

    final Color primaryColor =
        theme.colorScheme.primary;

    final Color secondaryColor =
        theme.colorScheme.secondary;

    final Color buttonTextColor =
        theme.colorScheme.onPrimary;

    return SizedBox(
      width: double.infinity,
      height:
          AppConstants.scheduleButtonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          /*
           * The gradient now changes
           * with the selected theme.
           */
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              primaryColor,
              secondaryColor,
            ],
          ),
          borderRadius:
              BorderRadius.circular(
            AppConstants.mediumRadius,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  primaryColor.withValues(
                alpha: 0.28,
              ),
              blurRadius: 14,
              offset: const Offset(
                0,
                5,
              ),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed:
              isLoading
                  ? null
                  : onPressed,
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                Colors.transparent,
            disabledBackgroundColor:
                Colors.transparent,
            shadowColor:
                Colors.transparent,
            foregroundColor:
                buttonTextColor,
            disabledForegroundColor:
                buttonTextColor.withValues(
              alpha: 0.70,
            ),
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                AppConstants.mediumRadius,
              ),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color:
                        buttonTextColor,
                  ),
                )
              : Text(
                  localizations
                      .saveSchedule,
                  style: AppTextStyles
                      .buttonText
                      .copyWith(
                    color:
                        buttonTextColor,
                  ),
                ),
        ),
      ),
    );
  }
}