import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _name = TextEditingController(text: "Pritom Basak");
  final _phone = TextEditingController(text: "123456789");
  final _email = TextEditingController(text: "abcd@email.com");
  final _nid = TextEditingController(text: "123456789");
  File? _imageFile;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Rounded header pill (back + title)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                        color: AppTheme.primary,
                        padding: const EdgeInsets.only(left: 6, right: 2),
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'edit_profile.title'.tr(), // Edit profile
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Content card (same-to-same look)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.045,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // profile image with overlay "Change profile"
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage:
                              _imageFile != null ? FileImage(_imageFile!) : null,
                              child: _imageFile == null
                                  ? const Icon(Icons.person, size: 48, color: Colors.white)
                                  : null,
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.black.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(999),
                                child: InkWell(
                                  onTap: _pickImage,
                                  borderRadius: BorderRadius.circular(999),
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
                      _label(context, 'edit_profile.name'.tr()),
                      _field(controller: _name, icon: Icons.person_outline),
                      const SizedBox(height: 12),

                      // Phone
                      _label(context, 'edit_profile.phone'.tr()),
                      _field(
                        controller: _phone,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),

                      // Email
                      _label(context, 'edit_profile.email'.tr()),
                      _field(
                        controller: _email,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),

                      // NID (Optional)
                      _label(context, 'edit_profile.nid'.tr()),
                      _field(controller: _nid, icon: Icons.credit_card),
                      const SizedBox(height: 18),

                      // Update button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Profile updated successfully!'),
                                backgroundColor: AppTheme.primary,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'edit_profile.update'.tr(),
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // small label above fields
  Widget _label(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 6),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(.85),
      ),
    ),
  );

  // pale green field
  Widget _field({
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE6F2E6), // pale green
        hintStyle: const TextStyle(color: Color(0x99000000)),
        prefixIcon: Icon(icon, color: AppTheme.primary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black.withOpacity(.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.6),
        ),
      ),
    );
  }
}
