// import 'package:flutter/material.dart';

// import 'app_colors.dart';

// class AppTheme {
//   AppTheme._();

//   static ThemeData get darkTheme {
//     return ThemeData(
//       useMaterial3: true,

//       brightness: Brightness.dark,

//       scaffoldBackgroundColor: const Color(0xff080914),

//       fontFamily: 'Poppins',

//       colorScheme: const ColorScheme.dark(
//         primary: AppColors.primary,
//       ),

//       appBarTheme: const AppBarTheme(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//     );
//   }
  

// // // Light theme configuration
// //   static ThemeData lightTheme = ThemeData(
// //     brightness: Brightness.light,
// //     scaffoldBackgroundColor: Colors.white,
// //     primaryColor: const Color(0xff6C63FF),
// //     colorScheme: ColorScheme.fromSeed(
// //       seedColor: const Color(0xff6C63FF),
// //       brightness: Brightness.light,
// //     ),
// //   );

//   // ======================================================
//   // Light Theme
//   // ======================================================

//   static ThemeData get lightTheme {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.light,

//       scaffoldBackgroundColor: AppColors.lightBackground,

//       colorScheme: const ColorScheme.light(
//         primary: AppColors.primary,
//         secondary: AppColors.secondary,
//         surface: AppColors.lightSurface,
//         error: AppColors.danger,
//       ),

//       appBarTheme: const AppBarTheme(
//         backgroundColor: AppColors.lightBackground,
//         foregroundColor: AppColors.textPrimaryLight,
//         elevation: 0,
//         centerTitle: false,
//       ),

//       cardTheme: const CardThemeData(
//         color: AppColors.lightCard,
//         elevation: 0,
//         margin: EdgeInsets.zero,
//       ),

//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: AppColors.lightInput,

//         hintStyle: const TextStyle(
//           color: AppColors.textHintLight,
//           fontSize: 13,
//         ),

//         labelStyle: const TextStyle(
//           color: AppColors.textSecondaryLight,
//         ),

//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(
//             color: AppColors.lightBorder,
//           ),
//         ),

//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(
//             color: AppColors.primary,
//             width: 1.4,
//           ),
//         ),

//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(
//             color: AppColors.danger,
//           ),
//         ),

//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: const BorderSide(
//             color: AppColors.danger,
//             width: 1.4,
//           ),
//         ),
//       ),

//       floatingActionButtonTheme:
//           const FloatingActionButtonThemeData(
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),

//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ),
//       ),

//       dividerColor: AppColors.lightBorder,

//       snackBarTheme: const SnackBarThemeData(
//         backgroundColor: AppColors.textPrimaryLight,
//         contentTextStyle: TextStyle(
//           color: Colors.white,
//         ),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

// //statistics screen theme configuration
// }
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // ======================================================
  // Dark Theme
  // ======================================================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',

      scaffoldBackgroundColor: const Color(0xFF090B1A),

      cardColor: const Color(0xFF15182B),

      dividerColor: const Color(0xFF252A42),

      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF7C5CFF),
        secondary: Color(0xFF22D3EE),

        surface: Color(0xFF15182B),

        onSurface: Color(0xFFF5F5FA),
        onSurfaceVariant: Color(0xFF8F96B3),

        outline: Color(0xFF30354D),
        outlineVariant: Color(0xFF252A42),

        error: AppColors.danger,

        surfaceContainerLowest: Color(0xFF090B1A),
        surfaceContainerLow: Color(0xFF101326),
        surfaceContainer: Color(0xFF15182B),
        surfaceContainerHigh: Color(0xFF1A1E33),
        surfaceContainerHighest: Color(0xFF20243A),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFF5F5FA),
        elevation: 0,
        centerTitle: false,
      ),

      cardTheme: const CardThemeData(
        color: Color(0xFF15182B),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF15182B),

        hintStyle: const TextStyle(
          color: Color(0xFF7F86A3),
          fontSize: 13,
        ),

        labelStyle: const TextStyle(
          color: Color(0xFF8F96B3),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF252A42),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF7C5CFF),
            width: 1.4,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.danger,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.danger,
            width: 1.4,
          ),
        ),
      ),

      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xFF101326),
        indicatorColor: Color(0xFF2B205B),
        height: 72,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            color: Color(0xFF8F96B3),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(
            color: Color(0xFF8F96B3),
            size: 21,
          ),
        ),
      ),

      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF7C5CFF),
        foregroundColor: Colors.white,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7C5CFF),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF20243A),
        contentTextStyle: TextStyle(
          color: Color(0xFFF5F5FA),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ======================================================
  // Light Theme
  // ======================================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Poppins',

      scaffoldBackgroundColor: AppColors.lightBackground,

      cardColor: AppColors.lightCard,

      dividerColor: AppColors.lightBorder,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,

        surface: AppColors.lightSurface,

        onSurface: AppColors.textPrimaryLight,
        onSurfaceVariant: AppColors.textSecondaryLight,

        outline: AppColors.lightBorder,
        outlineVariant: AppColors.lightBorder,

        error: AppColors.danger,

        surfaceContainerLowest: AppColors.lightBackground,
        surfaceContainerLow: AppColors.lightSurface,
        surfaceContainer: AppColors.lightCard,
        surfaceContainerHigh: AppColors.lightInput,
        surfaceContainerHighest: AppColors.lightInput,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
      ),

      cardTheme: const CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightInput,

        hintStyle: const TextStyle(
          color: AppColors.textHintLight,
          fontSize: 13,
        ),

        labelStyle: const TextStyle(
          color: AppColors.textSecondaryLight,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.lightBorder,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.4,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.danger,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.danger,
            width: 1.4,
          ),
        ),
      ),

      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.lightCard,
        indicatorColor: Color(0xFFE9E3FF),
        height: 72,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(
            color: AppColors.textSecondaryLight,
            size: 21,
          ),
        ),
      ),

      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.textPrimaryLight,
        contentTextStyle: TextStyle(
          color: Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}