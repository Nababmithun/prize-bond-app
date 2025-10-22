import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_routes.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
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
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06,
                vertical: size.height * 0.02,
              ),
              children: [
                // Header card
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Logo
                      Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/icons/logo.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'home.title'.tr(),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Text(
                                  'home.info'.tr(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: cs.onSurface.withOpacity(.6),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'home.support'.tr(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: cs.onSurface.withOpacity(.6),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined,
                            color: AppTheme.primary),
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.notifications),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons grid
                Row(
                  children: [
                    Expanded(
                      child: _HomeButton(
                        icon: Icons.card_giftcard,
                        label: 'home.prize_draw'.tr(),
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.draw),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _HomeButton(
                        icon: Icons.add_circle_outline,
                        label: 'home.add_bond'.tr(),
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.addBondSingle),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _HomeButton(
                        icon: Icons.settings_outlined,
                        label: 'home.settings'.tr(),
                        onTap: () async {
                          await Navigator.pushNamed(context, AppRoutes.settings);
                          setState(() {}); // 🔄 Rebuild for language change
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _HomeButton(
                        icon: Icons.person_outline,
                        label: 'home.profile'.tr(),
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.profile),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Subscription full width
                _HomeButton(
                  icon: Icons.lock_outline,
                  label: 'home.subscription'.tr(),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.subscription),
                  fullWidth: true,
                ),

                const SizedBox(height: 20),

                // Ads box
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      'home.ads'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🚪 Sign out button
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
                      'home.signout'.tr(),
                      style: const TextStyle(
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

  ///Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.logout, color: AppTheme.primary),
            const SizedBox(width: 8),
            Text('home.logout_title'.tr()),
          ],
        ),
        content: Text('home.logout_message'.tr()),
        actionsPadding: const EdgeInsets.only(bottom: 8, right: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr(),
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('ok'.tr(),
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool fullWidth;

  const _HomeButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 30, color: Colors.white),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
