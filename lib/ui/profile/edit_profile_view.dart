import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/viewmodels/ProfileViewModel.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _nid = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadProfile();
    });
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final user = vm.user;
    final cs = Theme.of(context).colorScheme;

    if (user != null && _name.text.isEmpty) {
      _name.text = user['name'] ?? '';
      _phone.text = user['phone'] ?? '';
      _email.text = user['email'] ?? '';
      _nid.text = user['nid'] ?? '';
    }

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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppTheme.primary),
                    ),
                    Text('edit_profile.title'.tr(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 14),

                // Image picker
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (user?['image'] != null
                            ? NetworkImage(
                            "https://prize-bond-test.peopleplusbd.com/${user?['image']}")
                            : null) as ImageProvider?,
                        child: user?['image'] == null && _imageFile == null
                            ? const Icon(Icons.person, size: 48, color: Colors.white)
                            : null,
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(999),
                          child: InkWell(
                            onTap: _pickImage,
                            child: const Center(
                              child: Text(
                                'Change profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Name
                _field(_name, Icons.person_outline, 'edit_profile.name'.tr()),
                const SizedBox(height: 12),

                // Phone
                _field(_phone, Icons.phone_outlined, 'edit_profile.phone'.tr(),
                    type: TextInputType.phone),
                const SizedBox(height: 12),

                // Email (readonly)
                TextField(
                  controller: _email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'edit_profile.email'.tr(),
                    filled: true,
                    fillColor: const Color(0xFFE6F2E6),
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: AppTheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // NID
                _field(_nid, Icons.credit_card, 'edit_profile.nid'.tr()),
                const SizedBox(height: 20),

                // Submit
                ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                    final ok = await vm.updateProfile(
                      name: _name.text.trim(),
                      phone: _phone.text.trim(),
                      nid: _nid.text.trim(),
                      image: _imageFile,
                    );
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(vm.message ??
                          (ok
                              ? 'Profile updated successfully!'
                              : 'Failed to update profile')),
                      backgroundColor:
                      ok ? AppTheme.primary : Colors.redAccent,
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: vm.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('edit_profile.update'.tr(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController ctrl, IconData icon, String label,
      {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFE6F2E6),
        prefixIcon: Icon(icon, color: AppTheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
