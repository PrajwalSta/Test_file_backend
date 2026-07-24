import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/language_model.dart';
import '../../../providers/language_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../theme/app_durations.dart';
import '../../theme/app_spacing.dart';
import '../../main_screen.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/settings/language/language_app_bar.dart';
import '../../widgets/settings/language/language_header.dart';
import '../../widgets/settings/language/language_list.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({
    super.key,
  });

  @override
  State<LanguageScreen> createState() =>
      _LanguageScreenState();
}

class _LanguageScreenState
    extends State<LanguageScreen> {
  bool _isSaving = false;

  Future<void> _changeLanguage(
    LanguageModel language,
  ) async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await context
          .read<LanguageProvider>()
          .changeLanguage(
            language.code,
          );

      if (!mounted) {
        return;
      }

      final AppLocalizations localizations =
          AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              localizations.languageChanged,
            ),
            duration: AppDurations.snackBar,
            behavior: SnackBarBehavior.floating,
          ),
        );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text(
              'Unable to save language selection.',
            ),
            behavior: SnackBarBehavior.floating,
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

  void _handleBottomNavTap(
    int index,
  ) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => MainScreen(
          initialIndex: index,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final LanguageProvider languageProvider =
        context.watch<LanguageProvider>();

    final List<LanguageModel> localizedLanguageList = [
      LanguageModel(
        name: localizations.english,
        code: 'en',
      ),
      LanguageModel(
        name: localizations.nepali,
        code: 'ne',
      ),
      LanguageModel(
        name: localizations.hindi,
        code: 'hi',
      ),
    ];

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: _handleBottomNavTap,
      ),
      body: SafeArea(
        child: Padding(
          padding:
              AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              LanguageAppBar(
                title: localizations.language,
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              LanguageHeader(
                subtitle: localizations.selectLanguage,
              ),

              const SizedBox(
                height: AppSpacing.md,
              ),

              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      physics:
                          const BouncingScrollPhysics(),
                      child: LanguageList(
                        languages:
                            localizedLanguageList,
                        selectedLanguageCode:
                            languageProvider
                                .languageCode,
                        onLanguageSelected:
                            _changeLanguage,
                      ),
                    ),

                    if (_isSaving)
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child:
                            LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}