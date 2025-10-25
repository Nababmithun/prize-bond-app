import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_routes.dart';
import '../../../viewmodels/auth_view_model.dart';

class ForgotEmailView extends StatefulWidget {
  const ForgotEmailView({super.key});

  @override
  State<ForgotEmailView> createState() => _ForgotEmailViewState();
}

class _ForgotEmailViewState extends State<ForgotEmailView> {
  final email = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final vm = context.watch<AuthViewModel>();

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
                  const SizedBox(height: 30),

                  Text(
                    'Forgot Password?',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter your registered email to receive a reset code.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, color: cs.onSurface.withOpacity(.7)),
                  ),
                  const SizedBox(height: 40),

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
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading
                          ? null
                          : () async {
                        final emailVal = email.text.trim();
                        if (emailVal.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                  Text('Please enter your email')));
                          return;
                        }
                        setState(() => _loading = true);
                        final ok =
                        await vm.forgotPassword(emailVal);
                        setState(() => _loading = false);
                        if (!mounted) return;
                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(vm.error ??
                                  'Verification code sent to your email'),
                            ),
                          );
                          Navigator.pushNamed(
                            context,
                            AppRoutes.resetPassword,
                            arguments: emailVal,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(vm.error ??
                                  'Failed to send verification code'),
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
                          color: Colors.white)
                          : const Text(
                        'Send Code',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text('© 2025, Prize bond checker',
                      style: TextStyle(
                          fontSize: 12.5,
                          color: cs.onSurface.withOpacity(.55))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
