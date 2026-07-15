import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Common text styles used across the app.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle screenTitle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardValue = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle statNumber = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle statLabel = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

//schedule screen text styles
  static const heading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const body = TextStyle(
    fontSize: 15,
  );

  static const caption = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  static const sectionTitle = TextStyle(
    color: AppColors.grey,
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: .4,
  );

  //privacy screen text styles
  static const TextStyle tileTitle = TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.w700,
    fontSize: 15,
  );

  static const TextStyle tileSubtitle = TextStyle(
    color: AppColors.grey,
    fontSize: 11,
  );

  static TextStyle? get buttonText => null;

  //theme screen text styles
  static const button = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  //focus mode screen text styles
static const TextStyle heading2 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
);

  static const TextStyle titleMedium = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
);

static const TextStyle bodySmall = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w400,
);

static const TextStyle bodyMedium = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

//login screen text styles
  static const TextStyle textField = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static const TextStyle hint = TextStyle(
    fontSize: 16,
    color: AppColors.hint,
  );

  static const TextStyle small = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle link = TextStyle(
    fontSize: 15,
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
  );

  //scheduler screen text styles
  // ======================================================
  // Main Screen Text
  // ======================================================

  static const TextStyle screenTitleDark = TextStyle(
    color: AppColors.textPrimaryDark,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle screenTitleLight = TextStyle(
    color: AppColors.textPrimaryLight,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  // ======================================================
  // Section Text
  // ======================================================

  static const TextStyle sectionTitleDark = TextStyle(
    color: AppColors.textPrimaryDark,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle sectionTitleLight = TextStyle(
    color: AppColors.textPrimaryLight,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  // ======================================================
  // Schedule Card Text
  // ======================================================

  static const TextStyle scheduleTitleDark = TextStyle(
    color: AppColors.textPrimaryDark,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle scheduleTitleLight = TextStyle(
    color: AppColors.textPrimaryLight,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle scheduleSubtitleDark = TextStyle(
    color: AppColors.textSecondaryDark,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle scheduleSubtitleLight = TextStyle(
    color: AppColors.textSecondaryLight,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // ======================================================
  // Form Labels
  // ======================================================

  static const TextStyle inputLabelDark = TextStyle(
    color: AppColors.textSecondaryDark,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle inputLabelLight = TextStyle(
    color: AppColors.textSecondaryLight,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  // ======================================================
  // Input Text
  // ======================================================

  static const TextStyle inputTextDark = TextStyle(
    color: AppColors.textPrimaryDark,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle inputTextLight = TextStyle(
    color: AppColors.textPrimaryLight,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // ======================================================
  // Small Text
  // ======================================================

  static const TextStyle chipText = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

//statistics screen text styles
  static const TextStyle screenSubtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle focusValue = TextStyle(
    color: AppColors.white,
    fontSize: 30,
    height: 1,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle statisticValue = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle navigationLabel = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle chartLabel = TextStyle(
    color: AppColors.textMuted,
    fontSize: 9,
    fontWeight: FontWeight.w500,
  );

  static TextStyle? get statisticLabel => null;
}

  

