import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class WinningResultView extends StatelessWidget {
  const WinningResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // demo data
    final wins = List.generate(
      4,
          (i) => (
      title: 'congrats.first_prize'.tr(), // localized
      amount: 'BDT 60000',
      number: '5241681',
      draw: 86 + i,
      ),
    );

    // e.g. “85, 86, 87”
    final joinedDraws = '85, 86, 87';

    return Scaffold(
      body: Stack(
        children: [
          const _GreenBg(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                //Top card (icon + title)
                Container(
                  decoration: _cardDecoration(),
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  child: Column(
                    children: [
                      const Icon(Icons.celebration_outlined,
                          color: AppTheme.primary, size: 36),
                      const SizedBox(height: 8),
                      Text(
                        'congrats.title'.tr(), // "Congratulations"
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Main card
                Container(
                  decoration: _cardDecoration(),
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'congrats.youwin'.tr(), // "You Won"
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              // "Draw 85, 86, 87"
                              'draw.selected'.tr(args: [joinedDraws]),
                              style: TextStyle(
                                fontSize: 12.5,
                                color: cs.onSurface.withOpacity(.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Winning rows
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: wins.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 1, color: cs.outlineVariant),
                        itemBuilder: (_, i) {
                          final w = wins[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(w.title, style: _kValueBold),
                                    const SizedBox(height: 2),
                                    Text(w.amount, style: _kLabelStyle),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      w.number,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      // "Draw 86"
                                      'draw.no_short'.tr(
                                        args: [w.draw.toString()],
                                      ),
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color:
                                        cs.onSurface.withOpacity(.55),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Refresh
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.refresh, size: 18),
                          label: Text(
                            'congrats.refresh'.tr(), // "Refresh"
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                            side: const BorderSide(color: AppTheme.primary),
                            padding:
                            const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: const Color(0xFFEFF7EF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          // "Last update: 21/12/2025 12:45 AM"
                          'common.last_update'
                              .tr(args: ['21/12/2025 12:45 AM']),
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurface.withOpacity(.55),
                          ),
                        ),
                      ),
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
}

// shared
class _GreenBg extends StatelessWidget {
  const _GreenBg();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF5FBF5), Color(0xFFE9F6EA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
);

const _kLabelStyle = TextStyle(fontSize: 12.5, color: Color(0x99000000));
const _kValueBold = TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
