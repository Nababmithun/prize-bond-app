import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_routes.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final otp = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();
  bool obscure1 = true;
  bool obscure2 = true;

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

                  //Logo
                  Image.asset(
                    'assets/icons/logo.png',
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    tr('forgot.reset_title').isNotEmpty
                        ? tr('forgot.reset_title')
                        : 'Reset Password',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle
                  Text(
                    tr('forgot.reset_subtitle').isNotEmpty
                        ? tr('forgot.reset_subtitle')
                        : 'Enter the OTP and your new password below.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: cs.onSurface.withOpacity(.7),
                    ),
                  ),
                  const SizedBox(height: 30),

                  //OTP Field
                  TextField(
                    controller: otp,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: tr('verify.code'),
                      prefixIcon:
                      const Icon(Icons.numbers, color: Colors.grey),
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
                  const SizedBox(height: 14),

                  // New Password
                  TextField(
                    controller: newPass,
                    obscureText: obscure1,
                    decoration: InputDecoration(
                      hintText: tr('signup.password'),
                      prefixIcon:
                      const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure1
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () =>
                            setState(() => obscure1 = !obscure1),
                      ),
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
                  const SizedBox(height: 14),

                  //Confirm Password
                  TextField(
                    controller: confirmPass,
                    obscureText: obscure2,
                    decoration: InputDecoration(
                      hintText: tr('signup.confirm_password'),
                      prefixIcon:
                      const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure2
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () =>
                            setState(() => obscure2 = !obscure2),
                      ),
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
                  const SizedBox(height: 26),

                  // Submit
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        tr('common.save').isNotEmpty
                            ? tr('common.save')
                            : 'Save Password',
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
