
import 'package:flutter/material.dart';
import 'package:flutter_app_focus_glow/services/notification_setting_service.dart';

import '../../data/notification_data.dart';
import '../../models/notification_setting.dart';
//import '../../services/local_notification_service.dart';
//import '../../services/notification_service.dart';

import '../main_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/notifications/notification_card.dart';
import '../widgets/notifications/notification_header.dart';
import '../widgets/notifications/notification_section_title.dart';
import '../widgets/notifications/notification_tile.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  static const int selectedIndex = 4;

  final NotificationSettingService
      _notificationSettingService =
      NotificationSettingService();

  final Set<String> _savingSettings = {};

  bool _isLoading = true;
  //bool _isTestingNotification = false;

  @override
  void initState() {
    super.initState();

    _loadNotificationSettings();
  }

  List<NotificationSetting> get _allSettings {
    return [
      ...NotificationData.channels,
      ...NotificationData.alerts,
      ...NotificationData.display,
    ];
  }

  String _createSettingKey(
    NotificationSetting setting,
  ) {
    return setting.title
        .trim()
        .toLowerCase()
        .replaceAll(
          RegExp(r'[^a-z0-9]+'),
          '_',
        )
        .replaceAll(
          RegExp(r'^_+|_+$'),
          '',
        );
  }

  Future<void> _loadNotificationSettings() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final Map<String, bool> savedSettings =
          await _notificationSettingService
              .getNotificationSettings();

      if (!mounted) {
        return;
      }

      setState(() {
        for (final NotificationSetting setting
            in _allSettings) {
          final String settingKey =
              _createSettingKey(setting);

          final bool? savedValue =
              savedSettings[settingKey];

          if (savedValue != null) {
            setting.enabled = savedValue;
          }
        }

        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      _showMessage(
        'Could not load notification settings: $error',
      );
    }
  }

  Future<void> _updateSetting({
    required NotificationSetting setting,
    required bool value,
  }) async {
    final String settingKey =
        _createSettingKey(setting);

    if (_savingSettings.contains(settingKey)) {
      return;
    }

    final bool previousValue = setting.enabled;

    setState(() {
      setting.enabled = value;
      _savingSettings.add(settingKey);
    });

    try {
      await _notificationSettingService
          .saveNotificationSetting(
        settingKey: settingKey,
        enabled: value,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        setting.enabled = previousValue;
      });

      _showMessage(
        'Could not save notification setting: $error',
      );
    } finally {
      if (mounted) {
        setState(() {
          _savingSettings.remove(settingKey);
        });
      }
    }
  }

  // Future<void> _showNotificationPopup() async {
  //   if (_isTestingNotification) {
  //     return;
  //   }

  //   setState(() {
  //     _isTestingNotification = true;
  //   });

  //   try {
  //     final bool permissionGranted =
  //         await LocalNotificationService.instance
  //             .requestPermission();

  //     if (!mounted) {
  //       return;
  //     }

  //     if (!permissionGranted) {
  //       _showMessage(
  //         'Notification permission was denied. '
  //         'Please enable notifications in phone settings.',
  //       );

  //       return;
  //     }

  //     await LocalNotificationService.instance
  //         .showTestNotification();

  //     if (!mounted) {
  //       return;
  //     }

  //     _showMessage(
  //       'Notification pop-up sent.',
  //     );
  //   } catch (error) {
  //     if (!mounted) {
  //       return;
  //     }

  //     _showMessage(
  //       'Notification error: $error',
  //     );
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isTestingNotification = false;
  //       });
  //     }
  //   }
  // }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  void _handleBottomNavTap(int index) {
    if (index == selectedIndex) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => MainScreen(
          initialIndex: index,
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: _handleBottomNavTap,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              const NotificationHeader(),

              // const SizedBox(height: 16),

              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton.icon(
              //     onPressed: _isTestingNotification
              //         ? null
              //         : _showNotificationPopup,
              //     icon: _isTestingNotification
              //         ? const SizedBox(
              //             width: 18,
              //             height: 18,
              //             child:
              //                 CircularProgressIndicator(
              //               strokeWidth: 2,
              //             ),
              //           )
              //         : const Icon(
              //             Icons.notifications_active,
              //           ),
              //     label: Text(
              //       _isTestingNotification
              //           ? 'Sending...'
              //           : 'Test Notification Pop-up',
              //     ),
              //   ),
              // ),

              // const SizedBox(height: 24),

              Expanded(
                child: _isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh:
                            _loadNotificationSettings,
                        child:
                            SingleChildScrollView(
                          physics:
                              const AlwaysScrollableScrollPhysics(
                            parent:
                                BouncingScrollPhysics(),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              _buildSection(
                                title: 'CHANNELS',
                                items:
                                    NotificationData
                                        .channels,
                              ),

                              const SizedBox(
                                height: 24,
                              ),

                              _buildSection(
                                title: 'ALERTS',
                                items:
                                    NotificationData
                                        .alerts,
                              ),

                              const SizedBox(
                                height: 24,
                              ),

                              _buildSection(
                                title: 'DISPLAY',
                                items:
                                    NotificationData
                                        .display,
                              ),

                              const SizedBox(
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<NotificationSetting> items,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          NotificationSectionTitle(
            title: title,
          ),

          NotificationCard(
            child: Column(
              children: List.generate(
                items.length,
                (int index) {
                  final NotificationSetting setting =
                      items[index];

                  final String settingKey =
                      _createSettingKey(setting);

                  final bool isSaving =
                      _savingSettings.contains(
                    settingKey,
                  );

                  return Stack(
                    children: [
                      NotificationTile(
                        setting: setting,
                        showDivider:
                            index != items.length - 1,
                        onChanged: isSaving
                            ? null
                            : (bool value) {
                                _updateSetting(
                                  setting: setting,
                                  value: value,
                                );
                              },
                      ),

                      if (isSaving)
                        const Positioned(
                          right: 6,
                          top: 6,
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

