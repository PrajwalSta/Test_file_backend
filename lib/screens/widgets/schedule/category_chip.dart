import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final bool isDarkMode =
        theme.brightness == Brightness.dark;

    final Color selectedColor =
        theme.colorScheme.primary;

    final Color unselectedColor = isDarkMode
        ? const Color(0xff1B1C2E)
        : const Color(0xffF3F4F8);

    final Color selectedTextColor =
        theme.colorScheme.onPrimary;

    final Color unselectedTextColor =
        isDarkMode
            ? Colors.white70
            : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 250,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? selectedColor
              : unselectedColor,
          borderRadius:
              BorderRadius.circular(30),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected
                ? selectedTextColor
                : unselectedTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}