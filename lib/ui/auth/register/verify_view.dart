import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_routes.dart';
import '../../../viewmodels/auth_view_model.dart';

/// ----------------------------------------------------------------------------
/// VERIFY VIEW
/// ----------------------------------------------------------------------------
/// - Takes 6-digit OTP and verifies registration
/// - If success → navigates to Login
/// - If failure → shows snackbar
/// - Uses [AuthViewModel.verifyOtp]
/// ----------------------------------------------------------------------------
class VerifyView extends StatefulWidget {
  final String? emailFromRouteArg;
  const VerifyView({super.key, this.emailFromRouteArg});

  @override
  State<VerifyView> createState() => _VerifyViewState();
}

class _VerifyViewState extends State<VerifyView> {
  // Focus chain for OTP fields
  final _nodes = List<FocusNode>.generate(6, (_) => FocusNode());
  final _ctrls = List<TextEditingController>.generate(6, (_) => TextEditingController());

  String get _otp => _ctrls.map((e) => e.text).join();

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
    setState(() {}); // rebuild to reflect filled state if needed
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final vm = context.watch<AuthViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF5FBF5), Color(0xFFE9F6EA)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image.asset('assets/icons/logo.png', width: 80, height: 80),
                  const SizedBox(height: 26),

                  // Title
                  Text(
                    tr('verify.title'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 24),

                  // Card
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
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        // Label
                        Text(
                          tr('verify.code_label'),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface.withOpacity(.85),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // OTP row
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

                        // Submit
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: vm.isLoading
                                ? null
                                : () async {
                              if (_otp.length == 6) {
                                final ok = await vm.verifyOtp(
                                  _otp,
                                  emailArg: widget.emailFromRouteArg,
                                );
                                if (!mounted) return;

                                if (ok) {
                                  // After verify → go to Login (per your flow)
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.login,
                                        (r) => false,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(vm.error ?? tr('common.retry')),
                                    ),
                                  );
                                }
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
                            child: vm.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                              tr('verify.submit'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Back to login
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.login,
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: cs.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.primary, width: 1.6),
          ),
        ),
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
    );
  }
}
