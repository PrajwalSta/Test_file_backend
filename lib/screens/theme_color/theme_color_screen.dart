import 'package:flutter/material.dart';

import '../main_screen.dart';
import '../../models/theme_color_model.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/theme_color/color_grid.dart';
import '../widgets/theme_color/live_preview_card.dart';
import '../widgets/theme_color/theme_header.dart';

class ThemeColorScreen extends StatefulWidget {
  const ThemeColorScreen({super.key});

  @override
  State<ThemeColorScreen> createState() => _ThemeColorScreenState();
}

class _ThemeColorScreenState extends State<ThemeColorScreen> {
  int selectedIndex = 0;

  final List<ThemeColorModel> themeColors = [
    ThemeColorModel(
      title: "Purple",
      color: const Color(0xff7B61FF),
      gradient: const [
        Color(0xff7B61FF),
        Color(0xff20C8F6),
      ],
    ),
    ThemeColorModel(
      title: "Ocean",
      color: const Color(0xff20C8F6),
    ),
    ThemeColorModel(
      title: "Sunset",
      color: const Color(0xffFF6B42),
    ),
    ThemeColorModel(
      title: "Forest",
      color: const Color(0xff22C55E),
    ),
    ThemeColorModel(
      title: "Rose",
      color: const Color(0xffEC4899),
    ),
    ThemeColorModel(
      title: "Gold",
      color: const Color(0xffF59E0B),
    ),
  ];

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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: _handleBottomNavTap,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ThemeHeader(),

                const SizedBox(height: 20),

                ColorGrid(
                  colors: themeColors,
                  selectedIndex: selectedIndex,
                  onSelected: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: LivePreviewCard(
                    selectedTheme: themeColors[selectedIndex],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}