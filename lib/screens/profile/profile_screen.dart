import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../../models/profile/profile_model.dart';
import '../../services/profile/profile_service.dart';
import '../main_screen.dart';
import '../theme/app_constants.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/profile/badges_section.dart';
import '../widgets/profile/profile_avatar.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_stats.dart';
import '../widgets/profile/recent_activity.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  final ProfileService _profileService =
      ProfileService();

  ProfileModel? profile;

  bool isLoading = true;
  bool hasLoadError = false;

  @override
  void initState() {
    super.initState();

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
          hasLoadError = false;
        });
      }

      // Update consecutive login streak.
      await _profileService
          .updateLoginStreak();

      // Load the latest profile data.
      final ProfileModel loadedProfile =
          await _profileService
              .getProfile();

      if (!mounted) {
        return;
      }

      setState(() {
        profile = loadedProfile;
        isLoading = false;
        hasLoadError = false;
      });
    } catch (error, stackTrace) {
      debugPrint(
        'Profile loading error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
        hasLoadError = true;
      });
    }
  }

  void _changePage(
    BuildContext context,
    int index,
  ) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => MainScreen(
          initialIndex: index,
        ),
      ),
      (Route<dynamic> route) =>
          false,
    );
  }

  Future<void> _openEditProfile() async {
    final ProfileModel? currentProfile =
        profile;

    if (currentProfile == null) {
      return;
    }

    final bool? updated =
        await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditProfileScreen(
          profile: currentProfile,
        ),
      ),
    );

    if (updated != true) {
      return;
    }

    await _loadProfile();

    if (!mounted) {
      return;
    }

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            localizations
                .profileUpdatedSuccessfully,
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      bottomNavigationBar:
          BottomNavBar(
        currentIndex: 4,
        onTap: (
          int index,
        ) {
          _changePage(
            context,
            index,
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(
            AppConstants.screen,
          ),
          child: _buildBody(
            localizations,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    AppLocalizations localizations,
  ) {
    if (isLoading) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    if (hasLoadError) {
      return Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Text(
              localizations
                  .unableToLoadProfile,
              textAlign:
                  TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              onPressed:
                  _loadProfile,
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

    final ProfileModel? currentProfile =
        profile;

    if (currentProfile == null) {
      return Center(
        child: Text(
          localizations
              .profileDataUnavailable,
          textAlign:
              TextAlign.center,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh:
          _loadProfile,
      child:
          SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            ProfileHeader(
              onEditPressed:
                  _openEditProfile,
            ),
            const SizedBox(
              height: 24,
            ),
            ProfileAvatar(
              fullName:
                  currentProfile
                      .fullName,
              bio:
                  currentProfile.bio,
              avatarUrl:
                  currentProfile
                      .avatarUrl,
              membership:
                  currentProfile
                      .membership,
              level:
                  currentProfile.level,
            ),
            const SizedBox(
              height: 28,
            ),
            ProfileStats(
              streak:
                  currentProfile.streak,
              completedTasks:
                  currentProfile
                      .completedTasks,
              focusHours:
                  currentProfile
                          .focusMinutes ~/
                      60,
              membership:
                  currentProfile
                      .membership,
            ),
            const SizedBox(
              height: 30,
            ),
            const BadgesSection(),
            const SizedBox(
              height: 30,
            ),
            const RecentActivity(),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}