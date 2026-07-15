import 'package:flutter/material.dart';

import '../../../../models/language_model.dart';
import 'language_tile.dart';

class LanguageList extends StatelessWidget {
  final List<LanguageModel> languages;
  final String selectedLanguageCode;
  final ValueChanged<LanguageModel> onLanguageSelected;

  const LanguageList({
    super.key,
    required this.languages,
    required this.selectedLanguageCode,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: languages.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          thickness: 0.7,
          color: theme.dividerColor.withValues(alpha: 0.4),
          indent: 20,
          endIndent: 20,
        ),
        itemBuilder: (context, index) {
          final language = languages[index];

          return LanguageTile(
            language: language.name,
            isSelected: selectedLanguageCode == language.code,
            onTap: () => onLanguageSelected(language),
          );
        },
      ),
    );
  }
}