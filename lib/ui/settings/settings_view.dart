import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_routes.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF5FBF5), Color(0xFFE9F6EA)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Header card (rounded like screenshot)
                Container(
                  padding: const EdgeInsets.fromLTRB(4, 4, 12, 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        tr('settings.title').isNotEmpty
                            ? tr('settings.title')
                            : 'Settings',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ⚙️ Settings group card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section title
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 14, bottom: 6),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),

                      _SettingsTile(
                        title: tr('settings.edit_profile'),
                        icon: Icons.chevron_right_rounded,
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.editProfile),
                      ),

                      _SettingsTile(
                        title: tr('settings.change_password'),
                        icon: Icons.chevron_right_rounded,
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.changePassword),
                      ),

                      _SettingsTile(
                        title: tr('settings.change_language'),
                        icon: Icons.chevron_right_rounded,
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.changeLanguage),
                      ),

                      _SettingsTile(
                        title: tr('settings.referral'),
                        icon: Icons.add,
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.referral),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Sign Out Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _showLogoutDialog(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFDDF5DD),
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      tr('settings.signout').isNotEmpty
                          ? tr('settings.signout')
                          : 'Sign out',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Confirm Logout",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text("Are you sure you want to sign out?"),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // ❌ Cancel
            child: const Text("Cancel",
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            child: const Text(
              "OK",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Settings list tile widget
class _SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Icon(icon, color: AppTheme.primary),
          ],
        ),
      ),
    );
  }
}
