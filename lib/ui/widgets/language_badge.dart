import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LanguageBadge extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const LanguageBadge({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? AppTheme.primary : Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: AppTheme.primary.withOpacity(isActive ? 1 : .6),
          width: 1.2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, size: 14, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                  color: isActive ? Colors.white : AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
