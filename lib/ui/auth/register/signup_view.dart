import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_routes.dart';
import '../../../data/viewmodels/auth_view_model.dart';

/// ---------------------------------------------------------------------------
/// SIGNUP VIEW
/// ---------------------------------------------------------------------------
/// Handles new user registration.
/// Integrates with [AuthViewModel] → register() → navigate to Verify OTP.
/// ---------------------------------------------------------------------------
class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final nid = TextEditingController();
  final referral = TextEditingController();
  final pass = TextEditingController();
  final confirm = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading = false;

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    email.dispose();
    nid.dispose();
    referral.dispose();
    pass.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
                horizontal: size.width * 0.06,
                vertical: size.height * 0.02,
              ),
              child: Column(
                children: [
                  ///  Language Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _langButton(context, 'en', 'assets/icons/flag_uk.png', 'English'),
                      const SizedBox(width: 8),
                      _langButton(context, 'bn', 'assets/icons/flag_bd.png', 'বাংলা'),
                    ],
                  ),
                  const SizedBox(height: 50),

                  ///  Logo & Title
                  Image.asset('assets/icons/logo.png', width: 90, height: 90),
                  const SizedBox(height: 24),
                  Text(
                    tr('signup.title'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 24),

                  ///  Form Fields
                  _field(name, tr('signup.name'), Icons.person_outline),
                  const SizedBox(height: 12),
                  _field(phone, tr('signup.phone'), Icons.phone, type: TextInputType.phone),
                  const SizedBox(height: 12),
                  _field(email, tr('signup.email'), Icons.email_outlined, type: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  _field(nid, tr('signup.nid'), Icons.credit_card),
                  const SizedBox(height: 12),
                  _field(referral, tr('signup.referral'), Icons.card_giftcard),
                  const SizedBox(height: 12),

                  /// Password Field
                  TextField(
                    controller: pass,
                    obscureText: _obscure1,
                    decoration: InputDecoration(
                      hintText: tr('signup.password'),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure1 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(() => _obscure1 = !_obscure1),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Confirm Password Field
                  TextField(
                    controller: confirm,
                    obscureText: _obscure2,
                    decoration: InputDecoration(
                      hintText: tr('signup.confirm_password'),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure2 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(() => _obscure2 = !_obscure2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ///  Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : () async => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                        tr('signup.continue'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Redirect to Login
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                    child: Text(
                      tr('signup.have_account'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
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
  // Helper: Submit Logic
  // ---------------------------------------------------------------------------
  Future<void> _submit(BuildContext context) async {
    final vm = context.read<AuthViewModel>();
    final nameVal = name.text.trim();
    final phoneVal = phone.text.trim();
    final emailVal = email.text.trim();
    final passVal = pass.text.trim();
    final confirmVal = confirm.text.trim();

    if ([nameVal, phoneVal, emailVal, passVal, confirmVal].any((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }
    if (passVal != confirmVal) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => _loading = true);
    final ok = await vm.register(
      name: nameVal,
      phone: phoneVal,
      email: emailVal,
      password: passVal,
      confirmPassword: confirmVal,
      nid: nid.text.trim(),
      referral: referral.text.trim(),
    );
    setState(() => _loading = false);

    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.verify,
        arguments: emailVal,
      );
    } else {
      final err = vm.error ?? tr('common.retry');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  // ---------------------------------------------------------------------------
  // Helper: Language Button
  // ---------------------------------------------------------------------------
  Widget _langButton(BuildContext context, String code, String asset, String label) {
    final active = context.locale.languageCode == code;
    return GestureDetector(
      onTap: () async {
        await context.setLocale(Locale(code));
        if (mounted) setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: active ? AppTheme.primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Image.asset(asset, height: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: active ? AppTheme.primary : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helper: Common Input Field
  // ---------------------------------------------------------------------------
  Widget _field(TextEditingController c, String hint, IconData icon,
      {TextInputType? type}) {
    return TextField(
      controller: c,
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
}
