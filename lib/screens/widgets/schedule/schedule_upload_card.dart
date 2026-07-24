import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';

class ScheduleUploadCard extends StatelessWidget {
  final bool isDarkMode;
  final bool isImporting;
  final bool isDownloading;
  final String? selectedFileName;
  final VoidCallback? onUploadPressed;
  final VoidCallback? onDownloadPressed;

  const ScheduleUploadCard({
    super.key,
    required this.isDarkMode,
    required this.isImporting,
    required this.isDownloading,
    required this.selectedFileName,
    required this.onUploadPressed,
    required this.onDownloadPressed,
  });

  bool get _isBusy {
    return isImporting || isDownloading;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final Color activeColor =
        colorScheme.primary;

    final Color activeTextColor =
        colorScheme.onPrimary;

    final Color cardColor = isDarkMode
        ? AppColors.scheduleInputDark
        : theme.cardColor;

    final Color titleColor = isDarkMode
        ? AppColors.textPrimaryDark
        : colorScheme.onSurface;

    final Color subtitleColor = isDarkMode
        ? AppColors.textSecondaryDark
        : colorScheme.onSurfaceVariant;

    final bool hasSelectedFile =
        selectedFileName != null &&
            selectedFileName!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: activeColor.withValues(
            alpha: 0.18,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDarkMode ? 0.12 : 0.06,
            ),
            blurRadius: 16,
            offset: const Offset(
              0,
              6,
            ),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          final bool useVerticalLayout =
              constraints.maxWidth < 520;

          final Widget uploadButton =
              ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: useVerticalLayout
                  ? double.infinity
                  : 120,
              maxWidth: useVerticalLayout
                  ? double.infinity
                  : 140,
            ),
            child: SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: _isBusy
                    ? null
                    : onUploadPressed,
                style: FilledButton.styleFrom(
                  backgroundColor:
                      activeColor,
                  foregroundColor:
                      activeTextColor,
                  disabledBackgroundColor:
                      activeColor.withValues(
                    alpha: 0.45,
                  ),
                  disabledForegroundColor:
                      activeTextColor.withValues(
                    alpha: 0.70,
                  ),
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      13,
                    ),
                  ),
                  elevation: 0,
                ),
                child: isImporting
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2.3,
                          color:
                              activeTextColor,
                        ),
                      )
                    : Text(
                        localizations.uploadFile,
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          color:
                              activeTextColor,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
              ),
            ),
          );

          final Widget informationSection =
              Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: activeColor.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
                child: Stack(
                  alignment:
                      Alignment.center,
                  children: [
                    Icon(
                      Icons
                          .description_outlined,
                      color: activeColor,
                      size: 38,
                    ),
                    Positioned(
                      right: 7,
                      bottom: 7,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration:
                            BoxDecoration(
                          color:
                              activeColor,
                          shape:
                              BoxShape.circle,
                        ),
                        child: Icon(
                          Icons
                              .file_upload_outlined,
                          color:
                              activeTextColor,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations
                          .importSchedule,
                      style: TextStyle(
                        color:
                            titleColor,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      hasSelectedFile
                          ? localizations
                              .selectedFile(
                              selectedFileName!,
                            )
                          : localizations
                              .uploadCsvDescription,
                      maxLines: 3,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                            subtitleColor,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                    if (onDownloadPressed !=
                        null) ...[
                      const SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: _isBusy
                            ? null
                            : onDownloadPressed,
                        borderRadius:
                            BorderRadius.circular(
                          6,
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 3,
                          ),
                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              if (isDownloading)
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth:
                                        2,
                                    color:
                                        activeColor,
                                  ),
                                )
                              else
                                Icon(
                                  Icons
                                      .download_rounded,
                                  color:
                                      activeColor,
                                  size: 16,
                                ),
                              const SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  isDownloading
                                      ? localizations
                                          .preparingTemplate
                                      : localizations
                                          .downloadTemplate,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,
                                  style:
                                      TextStyle(
                                    color:
                                        activeColor,
                                    fontSize:
                                        12,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );

          if (useVerticalLayout) {
            return Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                informationSection,
                const SizedBox(
                  height: 16,
                ),
                uploadButton,
              ],
            );
          }

          return Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              Expanded(
                child: informationSection,
              ),
              const SizedBox(
                width: 14,
              ),
              uploadButton,
            ],
          );
        },
      ),
    );
  }
}