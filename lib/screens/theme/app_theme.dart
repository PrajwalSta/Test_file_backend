import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme({
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    const Color scaffoldColor =
        Color(0xff08091B);

    const Color surfaceColor =
        Color(0xff15162B);

    const Color mutedTextColor =
        Color(0xff9A9BB5);

    const Color disabledButtonColor =
        Color(0xff292A42);

    return ThemeData(
      brightness: Brightness.dark,

      scaffoldBackgroundColor:
          scaffoldColor,

      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        surface: surfaceColor,
        onSurface: Colors.white,
        onSurfaceVariant:
            mutedTextColor,
      ),

      cardTheme: const CardThemeData(
        color: surfaceColor,
      ),

      // =======================================================
      // ELEVATED BUTTON THEME
      // =======================================================
      elevatedButtonTheme:
          ElevatedButtonThemeData(
        style:
            ButtonStyle(
          minimumSize:
              const WidgetStatePropertyAll(
            Size(
              double.infinity,
              50,
            ),
          ),

          backgroundColor:
              WidgetStateProperty.resolveWith(
            (
              Set<WidgetState> states,
            ) {
              if (states.contains(
                WidgetState.disabled,
              )) {
                return disabledButtonColor;
              }

              return primaryColor;
            },
          ),

          foregroundColor:
              WidgetStateProperty.resolveWith(
            (
              Set<WidgetState> states,
            ) {
              if (states.contains(
                WidgetState.disabled,
              )) {
                return Colors.white54;
              }

              return Colors.white;
            },
          ),

          overlayColor:
              WidgetStateProperty.resolveWith(
            (
              Set<WidgetState> states,
            ) {
              if (states.contains(
                WidgetState.pressed,
              )) {
                return Colors.white
                    .withValues(
                  alpha: 0.12,
                );
              }

              return null;
            },
          ),

          elevation:
              WidgetStateProperty.resolveWith(
            (
              Set<WidgetState> states,
            ) {
              if (states.contains(
                WidgetState.disabled,
              )) {
                return 0;
              }

              return 2;
            },
          ),

          shape:
              WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
          ),

          textStyle:
              const WidgetStatePropertyAll(
            TextStyle(
              fontSize: 15,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
      ),

      // =======================================================
      // FILLED BUTTON THEME
      // =======================================================
      filledButtonTheme:
          FilledButtonThemeData(
        style:
            ButtonStyle(
          minimumSize:
              const WidgetStatePropertyAll(
            Size(
              double.infinity,
              50,
            ),
          ),

          backgroundColor:
              WidgetStateProperty.resolveWith(
            (
              Set<WidgetState> states,
            ) {
              if (states.contains(
                WidgetState.disabled,
              )) {
                return disabledButtonColor;
              }

              return primaryColor;
            },
          ),

          foregroundColor:
              WidgetStateProperty.resolveWith(
            (
              Set<WidgetState> states,
            ) {
              if (states.contains(
                WidgetState.disabled,
              )) {
                return Colors.white54;
              }

              return Colors.white;
            },
          ),

          shape:
              WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
          ),
        ),
      ),

      navigationBarTheme:
          NavigationBarThemeData(
        backgroundColor:
            const Color(0xff0D0E20),

        indicatorColor:
            primaryColor.withValues(
          alpha: 0.18,
        ),

        iconTheme:
            WidgetStateProperty.resolveWith(
          (
            Set<WidgetState> states,
          ) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return IconThemeData(
                color: primaryColor,
              );
            }

            return const IconThemeData(
              color: mutedTextColor,
            );
          },
        ),

        labelTextStyle:
            WidgetStateProperty.resolveWith(
          (
            Set<WidgetState> states,
          ) {
            return TextStyle(
              color: states.contains(
                WidgetState.selected,
              )
                  ? primaryColor
                  : mutedTextColor,
            );
          },
        ),
      ),

      floatingActionButtonTheme:
          FloatingActionButtonThemeData(
        backgroundColor:
            primaryColor,
        foregroundColor:
            Colors.white,
      ),

      progressIndicatorTheme:
          ProgressIndicatorThemeData(
        color: primaryColor,
      ),
    );
  }

  static ThemeData lightTheme({
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    const Color mutedTextColor =
        Color(0xff6B7280);

    const Color disabledButtonColor =
        Color(0xffE5E7EB);

    return ThemeData(
      brightness:
          Brightness.light,

      scaffoldBackgroundColor:
          Colors.white,

      colorScheme:
          ColorScheme.light(
        primary: primaryColor,
        onPrimary:
            Colors.white,
        secondary:
            secondaryColor,
        onSecondary:
            Colors.white,
        surface:
            Colors.white,
        onSurface:
            Colors.black,
        onSurfaceVariant:
            mutedTextColor,
      ),

      cardTheme:
          const CardThemeData(
        color:
            Color(0xffF8FAFC),
      ),

      // =======================================================
      // ELEVATED BUTTON THEME
      // =======================================================
      elevatedButtonTheme:
          ElevatedButtonThemeData(
        style:
            ButtonStyle(
          minimumSize:
              const WidgetStatePropertyAll(
            Size(
              double.infinity,
              50,
            ),
          ),

          backgroundColor:
              WidgetStateProperty.resolveWith(
            (
              Set<WidgetState> states,
            ) {
              if (states.contains(
                WidgetState.disabled,
              )) {
                return disabledButtonColor;
              }

              return primaryColor;
            },
          ),

          foregroundColor:
              WidgetStateProperty.resolveWith(
            (
              Set<WidgetState> states,
            ) {
              if (states.contains(
                WidgetState.disabled,
              )) {
                return const Color(
                  0xff9CA3AF,
                );
              }

              return Colors.white;
            },
          ),

          overlayColor:
              WidgetStateProperty.resolveWith(
            (
              Set<WidgetState> states,
            ) {
              if (states.contains(
                WidgetState.pressed,
              )) {
                return Colors.white
                    .withValues(
                  alpha: 0.12,
                );
              }

              return null;
            },
          ),

          elevation:
              WidgetStateProperty.resolveWith(
            (
              Set<WidgetState> states,
            ) {
              if (states.contains(
                WidgetState.disabled,
              )) {
                return 0;
              }

              return 2;
            },
          ),

          shape:
              WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
          ),

          textStyle:
              const WidgetStatePropertyAll(
            TextStyle(
              fontSize: 15,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
      ),

      // =======================================================
      // FILLED BUTTON THEME
      // =======================================================
      filledButtonTheme:
          FilledButtonThemeData(
        style:
            ButtonStyle(
          minimumSize:
              const WidgetStatePropertyAll(
            Size(
              double.infinity,
              50,
            ),
          ),

          backgroundColor:
              WidgetStateProperty.resolveWith(
            (
              Set<WidgetState> states,
            ) {
              if (states.contains(
                WidgetState.disabled,
              )) {
                return disabledButtonColor;
              }

              return primaryColor;
            },
          ),

          foregroundColor:
              WidgetStateProperty.resolveWith(
            (
              Set<WidgetState> states,
            ) {
              if (states.contains(
                WidgetState.disabled,
              )) {
                return const Color(
                  0xff9CA3AF,
                );
              }

              return Colors.white;
            },
          ),

          shape:
              WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
          ),
        ),
      ),

      navigationBarTheme:
          NavigationBarThemeData(
        backgroundColor:
            Colors.white,

        indicatorColor:
            primaryColor.withValues(
          alpha: 0.16,
        ),

        iconTheme:
            WidgetStateProperty.resolveWith(
          (
            Set<WidgetState> states,
          ) {
            if (states.contains(
              WidgetState.selected,
            )) {
              return IconThemeData(
                color:
                    primaryColor,
              );
            }

            return const IconThemeData(
              color:
                  mutedTextColor,
            );
          },
        ),

        labelTextStyle:
            WidgetStateProperty.resolveWith(
          (
            Set<WidgetState> states,
          ) {
            return TextStyle(
              color: states.contains(
                WidgetState.selected,
              )
                  ? primaryColor
                  : mutedTextColor,
            );
          },
        ),
      ),

      floatingActionButtonTheme:
          FloatingActionButtonThemeData(
        backgroundColor:
            primaryColor,
        foregroundColor:
            Colors.white,
      ),

      progressIndicatorTheme:
          ProgressIndicatorThemeData(
        color:
            primaryColor,
      ),
    );
  }
}