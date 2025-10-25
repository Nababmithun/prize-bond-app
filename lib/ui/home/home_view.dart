import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_routes.dart';
import '../../viewmodels/auth_view_model.dart';

/// ---------------------------------------------------------------------------
/// HOME VIEW
/// ---------------------------------------------------------------------------
/// - Displays main feature grid (Add Bond, Prize Draw, Settings, etc.)
/// - Handles logout flow with confirmation dialog.
/// - Fully localized using EasyLocalization.
/// ---------------------------------------------------------------------------
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _loggingOut = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          ///  Background
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF5FBF5), Color(0xFFE9F6EA)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          ///  Page Body
          SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06,
                vertical: size.height * 0.02,
              ),
              children: [
                _buildHeader(cs),
                const SizedBox(height: 24),
                _buildGridButtons(),
                const SizedBox(height: 16),
                _buildSubscriptionButton(),
                const SizedBox(height: 20),
                _buildAdBox(),
                const SizedBox(height: 20),
                _buildLogoutButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  HEADER CARD
  // ---------------------------------------------------------------------------
  Widget _buildHeader(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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

          // Title + Info
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

          // Notification button
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppTheme.primary,
            ),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.notifications),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  GRID BUTTONS (MAIN ACTIONS)
  // ---------------------------------------------------------------------------
  Widget _buildGridButtons() {
    return Column(
      children: [
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
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.addBondSingle),
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
                  setState(() {}); // rebuild if language changed
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
      ],
    );
  }

  // ---------------------------------------------------------------------------
  //  SUBSCRIPTION BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildSubscriptionButton() {
    return _HomeButton(
      icon: Icons.lock_outline,
      label: 'home.subscription'.tr(),
      onTap: () => Navigator.pushNamed(context, AppRoutes.subscription),
      fullWidth: true,
    );
  }

  // ---------------------------------------------------------------------------
  //  ADS BOX
  // ---------------------------------------------------------------------------
  Widget _buildAdBox() {
    return Container(
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
    );
  }

  // ---------------------------------------------------------------------------
  //  LOGOUT BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _loggingOut ? null : () => _showLogoutDialog(context),
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFDDF5DD),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _loggingOut
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: AppTheme.primary,
            strokeWidth: 2,
          ),
        )
            : Text(
          'home.signout'.tr(),
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  LOGOUT CONFIRMATION
  // ---------------------------------------------------------------------------
  void _showLogoutDialog(BuildContext context) {
    final vm = context.read<AuthViewModel>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              child: Text(
                'cancel'.tr(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() => _loggingOut = true);

                await vm.logout();

                if (!mounted) return;
                setState(() => _loggingOut = false);

                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.login, (r) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'ok'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// ---------------------------------------------------------------------------
///  REUSABLE HOME GRID BUTTON
/// ---------------------------------------------------------------------------
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
