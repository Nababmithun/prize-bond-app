import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ChangeLanguageView extends StatefulWidget {
  const ChangeLanguageView({super.key});

  @override
  State<ChangeLanguageView> createState() => _ChangeLanguageViewState();
}

class _ChangeLanguageViewState extends State<ChangeLanguageView> {
  String _selected = 'en';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selected = context.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // gradient background
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // 🔙 Back button + Title container
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'change_language.title'.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      //  Language Options
                      _langTile(
                        code: 'en',
                        title: 'English',
                        flag: '🇬🇧',
                      ),
                      const SizedBox(height: 10),
                      _langTile(
                        code: 'bn',
                        title: 'বাংলা',
                        flag: '🇧🇩',
                      ),
                      const SizedBox(height: 20),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            await context.setLocale(Locale(_selected));
                            if (mounted) Navigator.pop(context);
                          },
                          child: Text(
                            'change_language.save'.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _langTile({required String code, required String title, required String flag}) {
    final selected = _selected == code;
    return InkWell(
      onTap: () => setState(() => _selected = code),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary.withOpacity(0.08) : Colors.white,
          border: Border.all(
            color: selected ? AppTheme.primary : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: selected ? AppTheme.primary : Colors.black87,
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
