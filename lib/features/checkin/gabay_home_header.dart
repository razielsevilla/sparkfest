import 'package:flutter/material.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/features/checkin/settings_dropdown_menu.dart';

class GabayHomeHeader extends StatelessWidget implements PreferredSizeWidget {
  final AppState appState;
  final IconData leadingIcon;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  const GabayHomeHeader({
    super.key,
    required this.appState,
    required this.leadingIcon,
    this.bottom,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(80.0 + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFFAF8F5);
    const Color primaryColor = Color(0xFF005C55);
    const Color textSecondaryColor = Color(0xFF3E4947);

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leadingWidth: 260,
      leading: Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: Row(
          children: [
            Icon(leadingIcon, color: primaryColor, size: 28),
            const SizedBox(width: 8),
            const Text(
              'Magandang araw!',
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
      actions: [
        ...?actions,
        SettingsDropdownMenu(appState: appState, iconColor: textSecondaryColor),
        const SizedBox(width: 16),
      ],
      bottom: bottom,
    );
  }
}
