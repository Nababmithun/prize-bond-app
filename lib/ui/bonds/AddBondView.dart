import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AddBondView extends StatefulWidget {
  const AddBondView({super.key});

  @override
  State<AddBondView> createState() => _AddBondViewState();
}

class _AddBondViewState extends State<AddBondView> {
  bool isMultiple = false;
  final _series = TextEditingController();
  final _startNumber = TextEditingController();
  final _count = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // 🔝 Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(.08),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.primary, width: 2),
                        ),
                        child: const Center(
                          child: Icon(Icons.card_giftcard, color: AppTheme.primary, size: 28),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'add_bond.title'.tr(), // ✅ Translated
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'home.info'.tr(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: cs.onSurface.withOpacity(.6),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'home.support'.tr(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: cs.onSurface.withOpacity(.6),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Icon(Icons.notifications_outlined, color: AppTheme.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Center(
                  child: Text(
                    'add_bond.title'.tr(),
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Toggle: Single / Multiple
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isMultiple = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isMultiple ? AppTheme.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'add_bond.single'.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !isMultiple ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isMultiple = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isMultiple ? AppTheme.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'add_bond.multiple'.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isMultiple ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Form Fields
                _buildField(
                    'add_bond.series'.tr(), 'add_bond.select_series'.tr(), _series),
                const SizedBox(height: 12),

                _buildField(
                    isMultiple
                        ? 'add_bond.range'.tr()
                        : 'add_bond.number'.tr(),
                    'add_bond.hint_number'.tr(),
                    _startNumber),
                const SizedBox(height: 12),

                if (isMultiple)
                  _buildField(
                      'add_bond.count'.tr(), 'add_bond.hint_count'.tr(), _count),

                const SizedBox(height: 24),

                // Add Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'add_bond.add'.tr(),
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
    );
  }

  Widget _buildField(String label, String hint, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFEAF6EA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.green.withOpacity(0.4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
