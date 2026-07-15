import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ======================================================
  // Brand Colors
  // ======================================================

  static const Color primary = Color(0xFF7C5CFC);
  static const Color primaryLight = Color(0xFFA76CFF);
  static const Color secondary = Color(0xFF24D5FF);
  static const Color accent = Color(0xFF0ECDD7);

  static const Color cyan = Color(0xFF00CFE8);
  static const Color blue = Color(0xFF00D9FF);
  static const Color purple = Color(0xFF7C5CFC);

  // ======================================================
  // Status Colors
  // ======================================================

  static const Color success = Color(0xFF2ECC71);
  static const Color danger = Color(0xFFFF4D6A);
  static const Color error = Color(0xFFE74C3C);
  static const Color yellow = Color(0xFFFFD166);
  static const Color red = Color(0xFFFF6B6B);
  static const Color orange = Color(0xFFFF8A4C);
  static const Color pink = Color(0xFFFF4FA2);

  // ======================================================
  // Dark Theme Colors
  // ======================================================

  /// Main dark page background.
  static const Color darkBackground = Color(0xFF090B1A);

  /// Lower-level dark surface.
  static const Color darkSurface = Color(0xFF101326);

  /// Standard cards.
  static const Color darkCard = Color(0xFF15182B);

  /// Higher or highlighted cards.
  static const Color darkCardHigh = Color(0xFF1A1E33);

  /// Input fields.
  static const Color darkInput = Color(0xFF20243A);

  /// Borders and dividers.
  static const Color darkBorder = Color(0xFF252A42);

  /// Bottom navigation.
  static const Color darkNavigation = Color(0xFF101326);

  /// Selected bottom navigation item.
  static const Color darkNavigationSelected = Color(0xFF2B205D);

  // ======================================================
  // Light Theme Colors
  // ======================================================

  static const Color lightBackground = Color(0xFFF7F7FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightInput = Color(0xFFF1F2F8);
  static const Color lightBorder = Color(0xFFE1E3EC);

  // ======================================================
  // Dark Theme Text Colors
  // ======================================================

  static const Color textPrimaryDark = Color(0xFFF5F5FA);
  static const Color textSecondaryDark = Color(0xFF8F96B3);
  static const Color textHintDark = Color(0xFF747990);

  // ======================================================
  // Light Theme Text Colors
  // ======================================================

  static const Color textPrimaryLight = Color(0xFF1A1B2E);
  static const Color textSecondaryLight = Color(0xFF6E7185);
  static const Color textHintLight = Color(0xFF9295A5);

  // ======================================================
  // Legacy Colors
  // ======================================================
  //
  // These names are kept so your existing files do not
  // produce errors. New widgets should use Theme.of(context).

  static const Color bg = darkBackground;
  static const Color background = darkBackground;
  static const Color card = darkCard;
  static const Color surface = darkCard;
  static const Color border = darkBorder;

  static const Color text = textPrimaryDark;
  static const Color subText = textSecondaryDark;
  static const Color textPrimary = textPrimaryDark;
  static const Color textSecondary = textSecondaryDark;

  static const Color white = Colors.white;
  static const Color grey = Color(0xFF8A8FA3);
  static const Color subtitle = Color(0xFF8B90B8);
  static const Color hint = Color(0xFF7D8098);
  static const Color icon = Color(0xFFA4A6C2);

  static const Color divider = darkBorder;
  static const Color navBar = darkNavigation;
  static const Color navigationBackground = darkNavigation;
  static const Color navigationSelected = darkNavigationSelected;

  // ======================================================
  // Gradient Colors
  // ======================================================

  static const Color primaryPurple = Color(0xFF7C5CFF);
  static const Color primaryBlue = Color(0xFF00D4FF);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryLight,
      primary,
    ],
  );

  static const LinearGradient darkPurpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF241653),
      Color(0xFF3D237D),
    ],
  );

  static const LinearGradient lightPurpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF2EEFF),
      Color(0xFFE4DBFF),
    ],
  );

  // ======================================================
  // Statistics Category Colors
  // ======================================================

  static const Color work = Color(0xFF7C5CFF);
  static const Color study = Color(0xFF2AD4FF);
  static const Color health = Color(0xFFFF7A45);
  static const Color personal = Color(0xFFFFC857);

  // ======================================================
  // Statistics Chart Colors
  // ======================================================

  static const Color cardBackground = darkCardHigh;
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFF8A8FA3);
  static const Color tooltipBg = Color(0xFF1E1E2E);
  static const Color chartTooltipBg = Color(0xFF1E1E2E);

  static Color textMuted = Colors.white.withValues(alpha: 0.38);

  static Color gridLine = Colors.white.withValues(alpha: 0.05);
  static Color dotStroke = Colors.white.withValues(alpha: 0.24);
  static Color chartGrid = Colors.white.withValues(alpha: 0.05);
  static Color chartDotStroke =
      Colors.white.withValues(alpha: 0.20);

  // ======================================================
  // Schedule Category Colors
  // ======================================================

  static const Color scheduleWork = Color(0xFF6C63FF);
  static const Color scheduleStudy = Color(0xFF3B82F6);
  static const Color scheduleHealth = Color(0xFF22C55E);
  static const Color schedulePersonal = Color(0xFFF59E0B);
  static const Color scheduleSocial = Color(0xFFEC4899);

  // ======================================================
  // Schedule Dark Colors
  // ======================================================

  static const Color scheduleCardDark = darkCard;
  static const Color scheduleInput = darkInput;
  static const Color scheduleBottomSheet = darkSurface;

  static const Color scheduleBackgroundDark = darkBackground;
  static const Color scheduleInputDark = darkInput;
  static const Color scheduleBorderDark = darkBorder;
  static const Color scheduleBottomSheetDark = darkSurface;
  static const Color scheduleDragHandleDark = Color(0xFF373A55);

  // ======================================================
  // Schedule Light Colors
  // ======================================================

  static const Color scheduleBackgroundLight = lightBackground;
  static const Color scheduleCardLight = lightCard;
  static const Color scheduleInputLight = lightInput;
  static const Color scheduleBorderLight = lightBorder;
  static const Color scheduleBottomSheetLight = Colors.white;
  static const Color scheduleDragHandleLight = Color(0xFFD5D7E0);

  static const Color schedulePrimary = primary;
  static const Color scheduleSecondary = secondary;

  // ======================================================
  // Settings Colors
  // ======================================================

  static const Color signOut = Color(0xFF351627);
  static const Color badge = Color(0xFF211D45);

  // ======================================================
  // Theme Selection Colors
  // ======================================================

  static const Color ocean = Color(0xFF17B9E9);
  static const Color sunset = Color(0xFFFF6B42);
  static const Color forest = Color(0xFF22C55E);
  static const Color rose = Color(0xFFEC4899);
  static const Color gold = Color(0xFFF59E0B);

  // ======================================================
  // Focus Mode Colors
  // ======================================================

  static const Color cardDark = Color(0xFF0F1224);
  static const Color purpleDark = Color(0xFF2C1E63);
}