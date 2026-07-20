import 'package:flutter/material.dart';

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
  String? _errorMessage;

  List<BadgeModel> _badges = [];

  @override
  void initState() {
    super.initState();

    _loadBadges();
  }

  Future<void> _loadBadges() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await _badgeService.checkBadges();

      final List<Map<String, dynamic>>
          badgeRows =
          await _badgeService.getBadges();

      final Map<String, String> badgeEmojis = {
        'early_bird': '🌅',
        'night_owl': '🦉',
        'streak_7': '🔥',
        'focus_100': '⚡',
        'planner_pro': '📅',
        'zen_master': '🧘',
      };

      final List<String> badgeOrder = [
        'early_bird',
        'night_owl',
        'streak_7',
        'focus_100',
        'planner_pro',
        'zen_master',
      ];

      final List<BadgeModel> loadedBadges =
          badgeOrder.map(
        (String badgeKey) {
          final Map<String, dynamic> badgeRow =
              badgeRows.firstWhere(
            (Map<String, dynamic> row) {
              return row['badge_key']
                      ?.toString() ==
                  badgeKey;
            },
            orElse: () {
              return {
                'badge_key':
                    badgeKey,
                'badge_name':
                    _defaultBadgeName(
                  badgeKey,
                ),
                'unlocked':
                    false,
              };
            },
          );

          return BadgeModel(
            emoji:
                badgeEmojis[badgeKey] ??
                    '🏅',
            title:
                badgeRow['badge_name']
                        ?.toString() ??
                    _defaultBadgeName(
                      badgeKey,
                    ),
            earned:
                badgeRow['unlocked']
                        as bool? ??
                    false,
          );
        },
      ).toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _badges = loadedBadges;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint(
        'Unable to load badges: '
        '$error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            'Unable to load badges';
      });
    }
  }

  String _defaultBadgeName(
    String badgeKey,
  ) {
    switch (badgeKey) {
      case 'early_bird':
        return 'Early Bird';

      case 'night_owl':
        return 'Night Owl';

      case 'streak_7':
        return 'Streak 7';

      case 'focus_100':
        return 'Focus 100h';

      case 'planner_pro':
        return 'Planner Pro';

      case 'zen_master':
        return 'Zen Master';

      default:
        return 'Badge';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(
            24,
          ),
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          children: [
            Text(
              _errorMessage!,
              style: TextStyle(
                color:
                    colorScheme.error,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextButton.icon(
              onPressed:
                  _loadBadges,
              icon:
                  const Icon(
                Icons.refresh,
              ),
              label:
                  const Text(
                'Try again',
              ),
            ),
          ],
        ),
      );
    }

    final int earnedCount =
        _badges
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
                'BADGES',
                style: TextStyle(
                  color: colorScheme
                      .onSurfaceVariant,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '$earnedCount/'
                '${_badges.length} earned',
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
                    _badges.length,
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
                        _badges[index],
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