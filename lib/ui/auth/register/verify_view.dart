import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_routes.dart';
import '../../widgets/language_badge.dart';

class VerifyView extends StatefulWidget {
  const VerifyView({super.key});

  @override
  State<VerifyView> createState() => _VerifyViewState();
}

class _VerifyViewState extends State<VerifyView> {
  final _nodes = List<FocusNode>.generate(6, (_) => FocusNode());
  final _ctrls = List<TextEditingController>.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    for (final n in _nodes) n.dispose();
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _nodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  String get _otp => _ctrls.map((e) => e.text).join();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 🌿 Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF5FBF5), Color(0xFFE9F6EA)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🌐 Language toggle top-right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LanguageBadge(
                        label: 'English',
                        isActive: context.locale.languageCode == 'en',
                        onTap: () async {
                          await context.setLocale(const Locale('en'));
                          if (mounted) setState(() {});
                        },
                      ),
                      const SizedBox(width: 6),
                      LanguageBadge(
                        label: 'বাংলা',
                        isActive: context.locale.languageCode == 'bn',
                        onTap: () async {
                          await context.setLocale(const Locale('bn'));
                          if (mounted) setState(() {});
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🖼️ Logo (no border)
                  Center(
                    child: Image.asset(
                      'assets/icons/logo.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 26),

                  // 🏷 Title
                  Text(
                    tr('verify.title').isNotEmpty
                        ? tr('verify.title')
                        : 'Verify account using email',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 🧾 Card container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // 🧩 Verification code label
                        Text(
                          "Verification code",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface.withOpacity(.85),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 🔢 OTP Boxes - 6 digits
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            6,
                                (i) => _OtpBox(
                              controller: _ctrls[i],
                              focusNode: _nodes[i],
                              onChanged: (v) => _onChanged(i, v),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ✅ Sign up button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_otp.length == 6) {
                                Navigator.pushReplacementNamed(context, AppRoutes.home);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Enter 6-digit code')),
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
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🧾 Terms text
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
                  const SizedBox(height: 18),

                  // 📎 Footer links
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    children: [
                      _footerLink('Conditions of Use', cs),
                      _footerLink('Privacy Notice', cs),
                      _footerLink('Help', cs),
                    ],
                  ),
                  const SizedBox(height: 10),
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

  Widget _footerLink(String text, ColorScheme cs) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.5,
        color: cs.onSurface.withOpacity(.7),
        decoration: TextDecoration.underline,
      ),
    );
  }
}

/// 🔢 OTP Input Box
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 46,
      height: 55,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: const Color(0xFFE6F2E6),
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: cs.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.primary, width: 1.6),
          ),
        ),
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
