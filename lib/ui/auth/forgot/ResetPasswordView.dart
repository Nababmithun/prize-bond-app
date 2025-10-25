import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_routes.dart';
import '../../../viewmodels/auth_view_model.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final email = TextEditingController();
  final otp = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();
  bool obscure1 = true;
  bool obscure2 = true;
  bool _loading = false;

  @override
  void didChangeDependencies() {
    // If email passed from ForgotEmailView, auto-fill
    final argEmail = ModalRoute.of(context)?.settings.arguments as String?;
    if (argEmail != null && argEmail.isNotEmpty) {
      email.text = argEmail;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final vm = context.watch<AuthViewModel>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
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
                  const SizedBox(height: 60),
                  Image.asset('assets/icons/logo.png', width: 90, height: 90),
                  const SizedBox(height: 24),
                  const Text('Reset Password',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Text(
                    'Enter your registered email, OTP and your new password below.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, color: cs.onSurface.withOpacity(.7)),
                  ),
                  const SizedBox(height: 30),

                  // Email field
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
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
                  const SizedBox(height: 14),

                  // OTP field
                  TextField(
                    controller: otp,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter OTP',
                      prefixIcon:
                      const Icon(Icons.numbers_outlined, color: Colors.grey),
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

                  // New password
                  TextField(
                    controller: newPass,
                    obscureText: obscure1,
                    decoration: InputDecoration(
                      hintText: 'New Password',
                      prefixIcon:
                      const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure1
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(() => obscure1 = !obscure1),
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

                  // Confirm password
                  TextField(
                    controller: confirmPass,
                    obscureText: obscure2,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      prefixIcon:
                      const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure2
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(() => obscure2 = !obscure2),
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

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading
                          ? null
                          : () async {
                        if (email.text.isEmpty ||
                            otp.text.isEmpty ||
                            newPass.text.isEmpty ||
                            confirmPass.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                Text('Please fill all fields')),
                          );
                          return;
                        }
                        if (newPass.text != confirmPass.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                Text('Passwords do not match')),
                          );
                          return;
                        }

                        setState(() => _loading = true);
                        final ok = await vm.resetPassword(
                          email: email.text.trim(),
                          otp: otp.text.trim(),
                          newPassword: newPass.text.trim(),
                        );
                        setState(() => _loading = false);

                        if (!mounted) return;

                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(vm.error ??
                                  'Password has been reset successfully. Please log in with your new password.'),
                            ),
                          );
                          Navigator.pushNamedAndRemoveUntil(
                              context, AppRoutes.login, (r) => false);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(vm.error ??
                                  'Failed to reset password. Try again.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                          : const Text(
                        'Save Password',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Text(
                    '© 2025, Prize bond checker',
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
