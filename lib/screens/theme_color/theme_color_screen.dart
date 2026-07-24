import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/theme_color_model.dart';
import '../../providers/theme_provider.dart';
import '../main_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/theme_color/color_grid.dart';
import '../widgets/theme_color/live_preview_card.dart';
import '../widgets/theme_color/theme_header.dart';

class ThemeColorScreen extends StatefulWidget {
  const ThemeColorScreen({
    super.key,
  });

  @override
  State<ThemeColorScreen> createState() =>
      _ThemeColorScreenState();
}

class _ThemeColorScreenState
    extends State<ThemeColorScreen> {
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    /*
     * Load the saved backend theme after
     * the screen is added to the widget tree.
     */
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (!mounted) {
          return;
        }

        final ThemeProvider themeProvider =
            context.read<ThemeProvider>();

        await themeProvider.loadTheme();
      },
    );
  }

  /*
   * Creates the theme colour list using
   * localized display names.
   *
   * keyName remains in English because it is
   * the internal value stored in Supabase.
   */
  List<ThemeColorModel> _getThemeColors(
    AppLocalizations localizations,
  ) {
    return <ThemeColorModel>[
      ThemeColorModel(
        title: localizations.purple,
        keyName: 'purple',
        primaryColor:
            const Color(0xff7B61FF),
        secondaryColor:
            const Color(0xff20C8F6),
        gradient: const <Color>[
          Color(0xff7B61FF),
          Color(0xff20C8F6),
        ],
      ),
      ThemeColorModel(
        title: localizations.ocean,
        keyName: 'ocean',
        primaryColor:
            const Color(0xff20C8F6),
        secondaryColor:
            const Color(0xff2563EB),
        gradient: const <Color>[
          Color(0xff20C8F6),
          Color(0xff2563EB),
        ],
      ),
      ThemeColorModel(
        title: localizations.sunset,
        keyName: 'sunset',
        primaryColor:
            const Color(0xffFF6B6B),
        secondaryColor:
            const Color(0xffFF9F43),
        gradient: const <Color>[
          Color(0xffFF6B6B),
          Color(0xffFF9F43),
        ],
      ),
      ThemeColorModel(
        title: localizations.forest,
        keyName: 'forest',
        primaryColor:
            const Color(0xff22C55E),
        secondaryColor:
            const Color(0xff14B8A6),
        gradient: const <Color>[
          Color(0xff22C55E),
          Color(0xff14B8A6),
        ],
      ),
      ThemeColorModel(
        title: localizations.rose,
        keyName: 'rose',
        primaryColor:
            const Color(0xffEC4899),
        secondaryColor:
            const Color(0xffF43F5E),
        gradient: const <Color>[
          Color(0xffEC4899),
          Color(0xffF43F5E),
        ],
      ),
      ThemeColorModel(
        title: localizations.gold,
        keyName: 'gold',
        primaryColor:
            const Color(0xffF59E0B),
        secondaryColor:
            const Color(0xffF97316),
        gradient: const <Color>[
          Color(0xffF59E0B),
          Color(0xffF97316),
        ],
      ),
    ];
  }

  int _getSelectedIndex({
    required List<ThemeColorModel> colors,
    required String selectedColor,
  }) {
    final String normalizedSelectedColor =
        selectedColor.trim().toLowerCase();

    final int index = colors.indexWhere(
      (ThemeColorModel theme) {
        return theme.keyName
                .trim()
                .toLowerCase() ==
            normalizedSelectedColor;
      },
    );

    if (index == -1) {
      return 0;
    }

    return index;
  }

  Future<void> _selectThemeColor({
    required int index,
    required List<ThemeColorModel> colors,
    required AppLocalizations localizations,
  }) async {
    if (isSaving ||
        index < 0 ||
        index >= colors.length) {
      return;
    }

    final ThemeColorModel selectedTheme =
        colors[index];

    /*
     * Save keyName instead of the localized title.
     *
     * Example:
     * title   = बैजनी
     * keyName = purple
     */
    final String colorName =
        selectedTheme.keyName
            .trim()
            .toLowerCase();

    setState(() {
      isSaving = true;
    });

    try {
      await context
          .read<ThemeProvider>()
          .changeThemeColor(
            colorName,
          );

      if (!mounted) {
        return;
      }

      final ScaffoldMessengerState messenger =
          ScaffoldMessenger.of(context);

      messenger.hideCurrentSnackBar();

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            localizations.themeApplied(
              selectedTheme.title,
            ),
          ),
          duration: const Duration(
            seconds: 2,
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      debugPrint(
        'Unable to save theme colour: $error',
      );

      if (!mounted) {
        return;
      }

      final ScaffoldMessengerState messenger =
          ScaffoldMessenger.of(context);

      messenger.hideCurrentSnackBar();

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            localizations
                .unableToSaveThemeColor,
          ),
          duration: const Duration(
            seconds: 4,
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void _handleBottomNavTap(
    int index,
  ) {
    if (index == 4) {
      Navigator.pop(context);
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (
          BuildContext context,
        ) {
          return MainScreen(
            initialIndex: index,
          );
        },
      ),
      (
        Route<dynamic> route,
      ) {
        return false;
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final ThemeProvider themeProvider =
        context.watch<ThemeProvider>();

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final List<ThemeColorModel> themeColors =
        _getThemeColors(
      localizations,
    );

    final int selectedIndex =
        _getSelectedIndex(
      colors: themeColors,
      selectedColor:
          themeProvider.selectedThemeColor,
    );

    final double screenWidth =
        MediaQuery.sizeOf(context).width;

    final double horizontalPadding =
        screenWidth < 380 ? 14 : 20;

    final bool showLoadingOverlay =
        isSaving ||
        themeProvider.isLoading;

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: _handleBottomNavTap,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                30,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const ThemeHeader(),

                  const SizedBox(
                    height: 18,
                  ),

                  ColorGrid(
                    colors: themeColors,
                    selectedIndex:
                        selectedIndex,
                    onSelected: (
                      int index,
                    ) {
                      _selectThemeColor(
                        index: index,
                        colors: themeColors,
                        localizations:
                            localizations,
                      );
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: LivePreviewCard(
                      selectedTheme:
                          themeColors[
                              selectedIndex],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),

            if (showLoadingOverlay)
              Positioned.fill(
                child: AbsorbPointer(
                  child: ColoredBox(
                    color: const Color(
                      0x33000000,
                    ),
                    child: Center(
                      child:
                          CircularProgressIndicator(
                        color: theme
                            .colorScheme
                            .primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}