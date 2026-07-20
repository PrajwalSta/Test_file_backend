import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String fullName;
  final String bio;
  final String? avatarUrl;
  final String membership;
  final int level;

  const ProfileAvatar({
    super.key,
    required this.fullName,
    required this.bio,
    required this.avatarUrl,
    required this.membership,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final bool hasAvatar =
        avatarUrl != null &&
        avatarUrl!.trim().isNotEmpty;

    final String displayName =
        fullName.trim().isNotEmpty
            ? fullName.trim()
            : 'Project User';

    final String displayBio =
        bio.trim().isNotEmpty
            ? bio.trim()
            : 'Focused on building better habits ✨';

    return Center(
      child: Column(
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color:
                    theme.colorScheme.primary,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: hasAvatar
                  ? Image.network(
                      avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return _buildDefaultAvatar(
                          theme,
                        );
                      },
                    )
                  : _buildDefaultAvatar(
                      theme,
                    ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            displayName,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            displayBio,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(
                alpha: 0.18,
              ),
              borderRadius: BorderRadius.circular(
                30,
              ),
            ),
            child: Text(
              '🏆 $membership Member • Level $level',
              style: const TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(
    ThemeData theme,
  ) {
    return Container(
      color: theme.colorScheme.primaryContainer,
      child: Icon(
        Icons.person,
        size: 52,
        color:
            theme.colorScheme.onPrimaryContainer,
      ),
    );
  }
}