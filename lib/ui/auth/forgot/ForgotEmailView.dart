import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_routes.dart';

class ForgotEmailView extends StatefulWidget {
  const ForgotEmailView({super.key});

  @override
  State<ForgotEmailView> createState() => _ForgotEmailViewState();
}

class _ForgotEmailViewState extends State<ForgotEmailView> {
  final email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background
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
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08, vertical: size.height * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // Logo
                  Image.asset(
                    'assets/icons/logo.png',
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    tr('forgot.title').isNotEmpty
                        ? tr('forgot.title')
                        : 'Forgot Password?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 12),

                  //Subtitle
                  Text(
                    tr('forgot.subtitle').isNotEmpty
                        ? tr('forgot.subtitle')
                        : 'Enter your registered email to receive a reset code.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: cs.onSurface.withOpacity(.7),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email Input
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: tr('login.email'),
                      prefixIcon:
                      const Icon(Icons.email_outlined, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        const BorderSide(color: Color(0xFFCBD5C0), width: 1),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Send OTP button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.resetPassword);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        tr('forgot.send').isNotEmpty
                            ? tr('forgot.send')
                            : 'Send Code',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 📎 Footer
                  Text(
                    '© 2025, Prize bond checker',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: cs.onSurface.withOpacity(.55),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
