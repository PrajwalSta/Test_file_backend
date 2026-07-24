import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/badge_model.dart';
import '../../../services/profile/badge_service.dart';
import 'badge_card.dart';

class BadgesSection extends StatefulWidget {
  const BadgesSection({
    super.key,
  });

  @override
  State<BadgesSection> createState() =>
      _BadgesSectionState();
}

class _BadgesSectionState
    extends State<BadgesSection> {
  final BadgeService _badgeService =
      BadgeService();

  bool _isLoading = true;
  bool _hasLoadError = false;

  List<Map<String, dynamic>> _badgeRows = [];

  static const Map<String, String>
      _badgeEmojis = {
    'early_bird': '🌅',
    'night_owl': '🦉',
    'streak_7': '🔥',
    'focus_100': '⚡',
    'planner_pro': '📅',
    'zen_master': '🧘',
  };

  static const List<String> _badgeOrder = [
    'early_bird',
    'night_owl',
    'streak_7',
    'focus_100',
    'planner_pro',
    'zen_master',
  ];

  @override
  void initState() {
    super.initState();

    _loadBadges();
  }

  Future<void> _loadBadges() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasLoadError = false;
      });
    }

    try {
      await _badgeService.checkBadges();

      final List<Map<String, dynamic>>
          badgeRows =
          await _badgeService.getBadges();

      if (!mounted) {
        return;
      }

      setState(() {
        _badgeRows = badgeRows;
        _isLoading = false;
        _hasLoadError = false;
      });
    } catch (error) {
      debugPrint(
        'Unable to load badges: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _hasLoadError = true;
      });
    }
  }

  String _localizedBadgeName(
    AppLocalizations localizations,
    String badgeKey,
  ) {
    switch (badgeKey) {
      case 'early_bird':
        return localizations.earlyBird;

      case 'night_owl':
        return localizations.nightOwl;

      case 'streak_7':
        return localizations.streakSeven;

      case 'focus_100':
        return localizations.focusOneHundredHours;

      case 'planner_pro':
        return localizations.plannerPro;

      case 'zen_master':
        return localizations.zenMaster;

      default:
        return localizations.badge;
    }
  }

  List<BadgeModel> _buildLocalizedBadges(
    AppLocalizations localizations,
  ) {
    return _badgeOrder.map(
      (String badgeKey) {
        final Map<String, dynamic> badgeRow =
            _badgeRows.firstWhere(
          (Map<String, dynamic> row) {
            return row['badge_key']
                    ?.toString() ==
                badgeKey;
          },
          orElse: () {
            return <String, dynamic>{
              'badge_key': badgeKey,
              'unlocked': false,
            };
          },
        );

        return BadgeModel(
          emoji:
              _badgeEmojis[badgeKey] ??
                  '🏅',
          title: _localizedBadgeName(
            localizations,
            badgeKey,
          ),
          earned:
              badgeRow['unlocked']
                      as bool? ??
                  false,
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (_hasLoadError) {
      return Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Text(
              localizations
                  .unableToLoadBadges,
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    colorScheme.error,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextButton.icon(
              onPressed: _loadBadges,
              icon: const Icon(
                Icons.refresh,
              ),
              label: Text(
                localizations.tryAgain,
              ),
            ),
          ],
        ),
      );
    }

    final List<BadgeModel> badges =
        _buildLocalizedBadges(
      localizations,
    );

    final int earnedCount =
        badges
            .where(
              (BadgeModel badge) =>
                  badge.earned,
            )
            .length;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                localizations.badges
                    .toUpperCase(),
                style: TextStyle(
                  color: colorScheme
                      .onSurfaceVariant,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                localizations.badgesEarned(
                  earnedCount,
                  badges.length,
                ),
                style: TextStyle(
                  color:
                      colorScheme.primary,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          LayoutBuilder(
            builder: (
              BuildContext context,
              BoxConstraints constraints,
            ) {
              int crossAxisCount = 3;

              if (constraints.maxWidth >=
                  1000) {
                crossAxisCount = 6;
              } else if (constraints
                      .maxWidth >=
                  700) {
                crossAxisCount = 4;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount:
                    badges.length,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      crossAxisCount,
                  crossAxisSpacing:
                      12,
                  mainAxisSpacing:
                      12,
                  childAspectRatio:
                      1.1,
                ),
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return BadgeCard(
                    badge:
                        badges[index],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}