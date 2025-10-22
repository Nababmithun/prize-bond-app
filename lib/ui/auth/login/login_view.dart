import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_routes.dart';
import '../../../viewmodels/auth_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 🌿 Background Gradient
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
                horizontal: size.width * 0.06,
                vertical: size.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🌐 Language Switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _langButton(context, 'en', 'assets/icons/flag_uk.png', 'English'),
                      const SizedBox(width: 8),
                      _langButton(context, 'bn', 'assets/icons/flag_bd.png', 'বাংলা'),
                    ],
                  ),
                  const SizedBox(height: 50),

                  // 🖼️ Logo (Replaced Icon with logo.png)
                  Image.asset(
                    'assets/icons/logo.png',
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),

                  // 🧾 Title
                  Text(
                    tr('login.title'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 📧 Email Field
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: tr('login.email'),
                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCBD5C0), width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 🔐 Password Field
                  TextField(
                    controller: pass,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: tr('login.password'),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCBD5C0), width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 🔗 Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.forgotEmail);
                      },
                      child: Text(
                        tr('login.forgot'),
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // ✅ Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final ok = await context
                            .read<AuthViewModel>()
                            .login(email.text.trim(), pass.text);
                        if (!mounted) return;
                        if (ok) {
                          Navigator.pushReplacementNamed(context, AppRoutes.home);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(tr('common.retry'))),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        tr('login.signin'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: cs.outlineVariant)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          tr('login.continue_with'),
                          style: TextStyle(color: cs.onSurface.withOpacity(.7)),
                        ),
                      ),
                      Expanded(child: Divider(color: cs.outlineVariant)),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 🔘 Google Sign-in
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image.asset('assets/icons/google.png', height: 20),
                      label: Text(
                        tr('login.google'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        side: const BorderSide(color: AppTheme.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color(0xFFDDF5DD),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 📜 Terms
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'By continuing, you agree to Conditions of Use and Privacy Notice.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: cs.onSurface.withOpacity(.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🆕 Signup Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.signup),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor:
                        cs.surfaceContainerHighest.withOpacity(.35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        tr('login.signup'),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 📑 Footer
                  _footer(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🌐 Language Button
  Widget _langButton(
      BuildContext context, String code, String asset, String label) {
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
                color: active ? AppTheme.primary : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Footer
  Widget _footer(BuildContext context) => Column(
    children: [
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        children: const [
          _FooterText('Conditions of Use'),
          _FooterText('Privacy Notice'),
          _FooterText('Help'),
        ],
      ),
      const SizedBox(height: 12),
      Text(
        '© 2025, Prize bond checker',
        style: TextStyle(
          fontSize: 12.5,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(.55),
        ),
      ),
    ],
  );
}

// Footer Link Text
class _FooterText extends StatelessWidget {
  final String text;
  const _FooterText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.5,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(.7),
        decoration: TextDecoration.underline,
      ),
    );
  }
}
