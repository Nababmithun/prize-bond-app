import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_routes.dart';
import '../../../viewmodels/auth_view_model.dart';

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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(children: [
        //Background
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
                horizontal: size.width * 0.06, vertical: size.height * 0.02),
            child: Column(children: [
              //Language Switch
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                _langButton(context, 'en', 'assets/icons/flag_uk.png', 'English'),
                const SizedBox(width: 8),
                _langButton(context, 'bn', 'assets/icons/flag_bd.png', 'বাংলা'),
              ]),
              const SizedBox(height: 50),

              // App Logo
              Image.asset(
                'assets/icons/logo.png',
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),

              // Title
              Text(tr('signup.title'),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87)),
              const SizedBox(height: 24),

              //Form Fields
              _field(context, name, tr('signup.name'), Icons.person_outline),
              const SizedBox(height: 12),
              _field(context, phone, tr('signup.phone'), Icons.phone,
                  type: TextInputType.phone),
              const SizedBox(height: 12),
              _field(context, email, tr('signup.email'), Icons.email_outlined,
                  type: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _field(context, nid, tr('signup.nid'), Icons.credit_card),
              const SizedBox(height: 12),
              _field(context, referral, tr('signup.referral'), Icons.card_giftcard),
              const SizedBox(height: 18),

              //Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final ok = await context.read<AuthViewModel>().register(
                        name: name.text.trim(),
                        phone: phone.text.trim(),
                        email: email.text.trim(),
                        nid: nid.text.trim(),
                        referral: referral.text.trim());
                    if (!mounted) return;
                    if (ok) {
                      Navigator.pushReplacementNamed(context, AppRoutes.verify);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(tr('common.retry'))));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(tr('signup.continue'),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 14),

              // Divider
              Row(children: [
                Expanded(child: Divider(color: cs.outlineVariant)),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Or sign up with',
                        style:
                        TextStyle(color: cs.onSurface.withOpacity(.7)))),
                Expanded(child: Divider(color: cs.outlineVariant)),
              ]),
              const SizedBox(height: 14),

              // Google Button
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image.asset('assets/icons/google.png', height: 20),
                      label: Text(tr('signup.verify_cta'),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                          side: const BorderSide(color: AppTheme.primary),
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor: const Color(0xFFDDF5DD)))),

              const SizedBox(height: 12),

              //Terms
              Text(
                  'By continuing, you agree to Conditions of Use and Privacy Notice.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.5, color: cs.onSurface.withOpacity(.6))),
              const SizedBox(height: 20),

              // 📎 Footer
              Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  children: const [
                    _FooterText('Conditions of Use'),
                    _FooterText('Privacy Notice'),
                    _FooterText('Help')
                  ]),
              const SizedBox(height: 12),
              Text('© 2025, Prize bond checker',
                  style: TextStyle(
                      fontSize: 12.5,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(.55))),
              const SizedBox(height: 24),
            ]),
          ),
        )
      ]),
    );
  }

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
            borderRadius: BorderRadius.circular(20)),
        child: Row(children: [
          Image.asset(asset, height: 16),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: active ? AppTheme.primary : Colors.black87))
        ]),
      ),
    );
  }

  Widget _field(BuildContext c, TextEditingController ctrl, String hint,
      IconData icon, {TextInputType? type}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: Color(0xFFCBD5C0), width: 1),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}

class _FooterText extends StatelessWidget {
  final String text;
  const _FooterText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontSize: 12.5,
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withOpacity(.7),
            decoration: TextDecoration.underline));
  }
}
