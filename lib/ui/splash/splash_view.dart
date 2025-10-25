import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../core/utils/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../data/viewmodels/auth_view_model.dart';

/// ---------------------------------------------------------------------------
/// SPLASH VIEW
/// ---------------------------------------------------------------------------
/// - Shows logo, name, and tagline with fade-in animation.
/// - Waits 2 seconds, then checks auth state.
/// - Navigates to Home if logged in, else Login.
/// ---------------------------------------------------------------------------
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    _checkAuthAndNavigate();
  }

  /// Check login state and redirect
  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final authVM = context.read<AuthViewModel>();
    final isLoggedIn = await authVM.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      await authVM.tryAutoAttachToken();
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFF4FAF4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Logo
                Image.asset(
                  'assets/icons/logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 18),

                /// App name
                Text(
                  'splash.app_name'.tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                    letterSpacing: 0.5,
                  ),
                ),

                /// Tagline
                const SizedBox(height: 6),
                Text(
                  'splash.tagline'.tr(),
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Colors.black54,
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
