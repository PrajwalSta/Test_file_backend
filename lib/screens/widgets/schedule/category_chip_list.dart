import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'category_chip.dart';

class CategoryChipList extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryChipList({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<String> categories = <String>[
    'All',
    'Work',
    'Health',
    'Study',
    'Personal',
  ];

  String _getLocalizedCategory({
    required AppLocalizations localizations,
    required String category,
  }) {
    switch (category.toLowerCase()) {
      case 'all':
        return localizations.all;

      case 'work':
        return localizations.work;

      case 'health':
        return localizations.health;

      case 'study':
        return localizations.study;

      case 'personal':
        return localizations.personal;

      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map(
          (String category) {
            final bool isSelected =
                selectedCategory.trim().toLowerCase() ==
                    category.trim().toLowerCase();

            final String localizedCategory =
                _getLocalizedCategory(
              localizations: localizations,
              category: category,
            );

            return Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: CategoryChip(
                title: localizedCategory,
                selected: isSelected,
                onTap: () {
                  /*
                   * Keep the original English value
                   * for filtering and Supabase data.
                   */
                  onCategorySelected(
                    category,
                  );
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}