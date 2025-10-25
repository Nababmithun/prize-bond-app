import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/viewmodels/change_password_view_model.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();

  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
        );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    oldPass.dispose();
    newPass.dispose();
    confirmPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final vm = context.watch<ChangePasswordViewModel>();

    return Scaffold(
      body: Stack(
        children: [
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
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ListView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.fromLTRB(4, 4, 12, 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 20),
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'change_password.title'.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Input card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildField(
                            label: 'change_password.old'.tr(),
                            hint: 'Enter old password',
                            controller: oldPass,
                            obscure: !_showOld,
                            toggle: () =>
                                setState(() => _showOld = !_showOld),
                          ),
                          const SizedBox(height: 14),
                          _buildField(
                            label: 'change_password.new'.tr(),
                            hint: 'Enter new password',
                            controller: newPass,
                            obscure: !_showNew,
                            toggle: () =>
                                setState(() => _showNew = !_showNew),
                          ),
                          const SizedBox(height: 14),
                          _buildField(
                            label: 'change_password.confirm'.tr(),
                            hint: 'Confirm new password',
                            controller: confirmPass,
                            obscure: !_showConfirm,
                            toggle: () =>
                                setState(() => _showConfirm = !_showConfirm),
                          ),
                          const SizedBox(height: 20),

                          // Update button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: vm.isLoading
                                  ? null
                                  : () async {
                                final oldP = oldPass.text.trim();
                                final newP = newPass.text.trim();
                                final confirmP =
                                confirmPass.text.trim();

                                if (oldP.isEmpty ||
                                    newP.isEmpty ||
                                    confirmP.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Please fill all fields')));
                                  return;
                                }
                                if (newP != confirmP) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content: Text(
                                          'New passwords do not match')));
                                  return;
                                }

                                final ok = await vm.changePassword(
                                  oldPassword: oldP,
                                  newPassword: newP,
                                  confirmPassword: confirmP,
                                );

                                if (!mounted) return;
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(vm.message ??
                                      (ok
                                          ? 'Password changed successfully!'
                                          : 'Failed to change password')),
                                  backgroundColor: ok
                                      ? AppTheme.primary
                                      : Colors.redAccent,
                                ));

                                if (ok) Navigator.pop(context);
                              },
                              child: vm.isLoading
                                  ? const CircularProgressIndicator(
                                  color: Colors.white)
                                  : Text(
                                'change_password.update'.tr(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFEAF6EA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey.shade600,
              ),
              onPressed: toggle,
            ),
          ),
        ),
      ],
    );
  }
}
