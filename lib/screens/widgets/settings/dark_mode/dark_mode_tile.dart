import 'package:flutter/material.dart';

class DarkModeTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const DarkModeTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: 8,
      ),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .primaryColor
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.dark_mode_outlined,
              color: Theme.of(context).primaryColor,
              size: width < 360 ? 22 : 24,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dark Mode",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: width < 360 ? 15 : 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Enable dark appearance throughout the app",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: width < 360 ? 12 : 13,
                  ),
                ),
              ],
            ),
          ),

          Switch.adaptive(
            value: value,
            activeThumbColor: Theme.of(context).primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}