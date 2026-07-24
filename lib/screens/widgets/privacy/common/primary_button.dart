import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool loading;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed:
            loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              colorScheme.primary,
          foregroundColor:
              colorScheme.onPrimary,
          disabledBackgroundColor:
              colorScheme.primary.withValues(
            alpha: 0.65,
          ),
          disabledForegroundColor:
              colorScheme.onPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
        ),
        child: loading
            ? SizedBox(
                height: 22,
                width: 22,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                  color:
                      colorScheme.onPrimary,
                ),
              )
            : Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                  Text(
                    title,
                    style:
                        const TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}