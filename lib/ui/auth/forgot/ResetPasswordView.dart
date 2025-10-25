import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_routes.dart';
import '../../../viewmodels/auth_view_model.dart';

/// ---------------------------------------------------------------------------
/// RESET PASSWORD VIEW
/// ---------------------------------------------------------------------------
/// - User enters Email, OTP, New Password & Confirm Password
/// - Calls [AuthViewModel.resetPassword]
/// - On success → navigates to Login
/// ---------------------------------------------------------------------------
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
    // Auto-fill email if passed from ForgotEmailView
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
          /// Background Gradient
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF5FBF5), Color(0xFFE9F6EA)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// Page Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
                vertical: size.height * 0.04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Image.asset('assets/icons/logo.png', width: 90, height: 90),
                  const SizedBox(height: 24),

                  ///  Title & Subtitle
                  const Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter your registered email, OTP and your new password below.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: cs.onSurface.withOpacity(.7),
                    ),
                  ),
                  const SizedBox(height: 30),

                  ///  Email Field
                  _inputField(
                    controller: email,
                    hint: 'Email Address',
                    icon: Icons.email_outlined,
                    type: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),

                  ///  OTP Field
                  _inputField(
                    controller: otp,
                    hint: 'Enter OTP',
                    icon: Icons.numbers_outlined,
                    type: TextInputType.number,
                  ),
                  const SizedBox(height: 14),

                  ///  New Password
                  _passwordField(
                    controller: newPass,
                    hint: 'New Password',
                    obscure: obscure1,
                    toggle: () => setState(() => obscure1 = !obscure1),
                  ),
                  const SizedBox(height: 14),

                  ///  Confirm Password
                  _passwordField(
                    controller: confirmPass,
                    hint: 'Confirm Password',
                    obscure: obscure2,
                    toggle: () => setState(() => obscure2 = !obscure2),
                  ),
                  const SizedBox(height: 26),

                  ///  Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading
                          ? null
                          : () async => _handleResetPassword(context, vm),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2)
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

                  ///  Footer
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

  // ---------------------------------------------------------------------------
  // Handle Submit
  // ---------------------------------------------------------------------------
  Future<void> _handleResetPassword(
      BuildContext context, AuthViewModel vm) async {
    if (email.text.isEmpty ||
        otp.text.isEmpty ||
        newPass.text.isEmpty ||
        confirmPass.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    if (newPass.text != confirmPass.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
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
          content: Text(
            vm.error ??
                'Password has been reset successfully. Please log in with your new password.',
          ),
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            vm.error ?? 'Failed to reset password. Try again.',
          ),
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  //  Reusable Input Field
  // ---------------------------------------------------------------------------
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? type,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCBD5C0), width: 1),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Reusable Password Field
  // ---------------------------------------------------------------------------
  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey,
          ),
          onPressed: toggle,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCBD5C0), width: 1),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}
