import 'package:flutter/material.dart';

import '../../../data/language_data.dart';
import '../../../models/language_model.dart';
import '../../main_screen.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/settings/language/language_app_bar.dart';
import '../../widgets/settings/language/language_header.dart';
import '../../widgets/settings/language/language_list.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  LanguageModel _selectedLanguage = languageList.first;

  void _changeLanguage(LanguageModel language) {
    setState(() {
      _selectedLanguage = language;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${language.name} selected'),
        duration: const Duration(milliseconds: 700),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => MainScreen(
          initialIndex: index,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: _handleBottomNavTap,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LanguageAppBar(),
              const SizedBox(height: 24),
              const LanguageHeader(),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: LanguageList(
                    languages: languageList,
                    selectedLanguageCode: _selectedLanguage.code,
                    onLanguageSelected: _changeLanguage,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}