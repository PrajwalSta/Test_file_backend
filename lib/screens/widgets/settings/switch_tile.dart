import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'switch_setting_tile.dart';

class SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor = AppColors.primary,
    this.value = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchSettingTile(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged ?? (_) {},
    );
  }
}
