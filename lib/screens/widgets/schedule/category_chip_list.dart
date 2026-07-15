import 'package:flutter/material.dart';

import 'category_chip.dart';

class CategoryChipList extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryChipList({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      "All",
      "Work",
      "Health",
      "Study",
      "Personal",
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CategoryChip(
              title: category,
              selected: selectedCategory == category,
              onTap: () {
                onCategorySelected(category);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}