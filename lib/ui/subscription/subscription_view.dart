import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // <-- animation package
import '../../core/theme/app_theme.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

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
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'subscription.title'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Illustration
                Center(
                  child: Image.asset(
                    'assets/images/subscription.png',
                    height: size.height * 0.25,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.subscriptions_rounded,
                      color: AppTheme.primary,
                      size: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Subscription Options (with animation)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 400),
                        child: _PlanCard(
                          title: '12 Month',
                          subtitle: '৳1099',
                          oldPrice: '৳1249',
                          saveText: 'SAVE 12%',
                          features: const [
                            'Lorem ipsum',
                            'Lorem ipsum',
                            'Lorem ipsum',
                          ],
                          isSelected: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: _PlanCard(
                          title: 'Lifetime',
                          subtitle: '৳999',
                          oldPrice: '৳1129',
                          saveText: 'SAVE 12%',
                          extraText: '(First 100 Users Only)',
                          features: const [
                            'Lorem ipsum',
                            'Lorem ipsum',
                            'Lorem ipsum',
                          ],
                          isSelected: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      FadeInDown(
                        duration: const Duration(milliseconds: 800),
                        child: _PlanCard(
                          title: '5 Year',
                          subtitle: '৳4999',
                          oldPrice: '৳5499',
                          saveText: 'SAVE 12%',
                          features: const [
                            'Lorem ipsum',
                            'Lorem ipsum',
                            'Lorem ipsum',
                          ],
                          isSelected: false,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Buy button
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: SizedBox(
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
                        'subscription.get_lifetime'.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Terms text
                Text.rich(
                  TextSpan(
                    text: tr('By placing this order, you agree to the '),
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurface.withOpacity(.7),
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms of Service ',
                        style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: 'and '),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // FAQs (animated)
                FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  child: _QuestionBlock(
                    title: 'When will I be billed?',
                    desc:
                    'Lorem Ipsum is simply dummy text Lorem Ipsum is simply dummy text.',
                  ),
                ),
                const SizedBox(height: 14),
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: _QuestionBlock(
                    title: 'Does my Subscription Auto Renew?',
                    desc:
                    'Lorem Ipsum is simply dummy text Lorem Ipsum is simply dummy text.',
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String oldPrice;
  final String saveText;
  final List<String> features;
  final bool isSelected;
  final String? extraText;

  const _PlanCard({
    required this.title,
    required this.subtitle,
    required this.oldPrice,
    required this.saveText,
    required this.features,
    required this.isSelected,
    this.extraText,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primary.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppTheme.primary : cs.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Save badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              saveText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          if (extraText != null)
            Text(
              extraText!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.5,
                color: cs.onSurface.withOpacity(.6),
              ),
            ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.primary,
            ),
          ),
          Text(
            oldPrice,
            style: const TextStyle(
              fontSize: 11.5,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(height: 8),

          // Features
          Column(
            children: features
                .map(
                  (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle,
                        size: 14, color: AppTheme.primary),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        e,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: cs.onSurface.withOpacity(.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _QuestionBlock extends StatelessWidget {
  final String title;
  final String desc;

  const _QuestionBlock({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          desc,
          style: TextStyle(
            fontSize: 13,
            color: cs.onSurface.withOpacity(.7),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
