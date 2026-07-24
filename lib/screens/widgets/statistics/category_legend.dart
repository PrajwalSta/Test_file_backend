import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';

class CategoryLegend extends StatelessWidget {
  final Map<String, double> categoryData;

  const CategoryLegend({
    super.key,
    required this.categoryData,
  });

  String _localizedCategory(
    AppLocalizations localizations,
    String category,
  ) {
    switch (category.trim().toLowerCase()) {
      case 'work':
        return localizations.work;

      case 'study':
        return localizations.study;

      case 'health':
        return localizations.health;

      case 'personal':
        return localizations.personal;

      case 'social':
        return localizations.social;

      case 'exercise':
        return localizations.exercise;

      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final List<MapEntry<String, double>> entries =
        categoryData.entries
            .where(
              (MapEntry<String, double> entry) =>
                  entry.value > 0,
            )
            .toList();

    if (entries.isEmpty) {
      return Center(
        child: Text(
          localizations.noData,
          style: TextStyle(
            color:
                colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      );
    }

    final double total =
        entries.fold<double>(
      0,
      (
        double sum,
        MapEntry<String, double> entry,
      ) {
        return sum + entry.value;
      },
    );

    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: List.generate(
        entries.length,
        (int index) {
          final MapEntry<String, double> entry =
              entries[index];

          final int percentage =
              total == 0
                  ? 0
                  : ((entry.value / total) * 100)
                      .round();

          return Padding(
            padding:
                const EdgeInsets.symmetric(
              vertical: 3,
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getCategoryColor(
                      entry.key,
                      index,
                      theme,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: Text(
                    _localizedCategory(
                      localizations,
                      entry.key,
                    ),
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme
                          .onSurfaceVariant,
                      fontSize: 9,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    color:
                        colorScheme.onSurface,
                    fontSize: 9,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getCategoryColor(
    String category,
    int index,
    ThemeData theme,
  ) {
    switch (category.trim().toLowerCase()) {
      case 'work':
        return AppColors.scheduleWork;

      case 'study':
        return AppColors.scheduleStudy;

      case 'health':
        return AppColors.scheduleHealth;

      case 'personal':
        return AppColors.schedulePersonal;

      case 'social':
        return AppColors.scheduleSocial;

      case 'exercise':
        return Colors.redAccent;

      default:
        final List<Color> colors =
            <Color>[
          theme.colorScheme.primary,
          theme.colorScheme.secondary,
          theme.colorScheme.tertiary,
          Colors.pinkAccent,
          Colors.amber,
          Colors.teal,
        ];

        return colors[
            index % colors.length];
    }
  }
}