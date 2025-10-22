import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_routes.dart';
import 'WinningResultView.dart';

class DrawDetailView extends StatelessWidget {
  const DrawDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    // demo (static mock)
    const seriesLines = [
      'AA, AB, AC, BA, BB, BC,',
      'AA, AB, AC, BA, BB, BC,',
      'AA, AB, AC, BA, BB, BC',
    ];
    final prizes = <({String title, String amount, String number})>[
      (title: 'draw_detail.first_prize'.tr(),  amount: 'BDT 60000', number: '5241681'),
      (title: 'draw_detail.second_prize'.tr(), amount: 'BDT 30000', number: '1122334'),
      (title: 'draw_detail.third_prize'.tr(),  amount: 'BDT 10000', number: '5566778'),
    ];

    const drawNo = 86;
    const dateStr = '21/12/2025';

    return Scaffold(
      body: Stack(
        children: [
          const _GreenBg(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                const _HeaderCard(),
                const SizedBox(height: 14),

                // Body card
                Container(
                  decoration: _cardDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title + Date
                        Center(
                          child: Column(
                            children: [
                              Text(
                                // e.g. "Draw no 86"
                                'draw_detail.draw_no_title'.tr(args: [drawNo.toString()]),
                                style: TextStyle(
                                  fontSize: size.width * 0.05,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                // e.g. "Date: 21/12/2025"
                                'draw_detail.date_title'.tr(args: [dateStr]),
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: cs.onSurface.withOpacity(.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Series block
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('draw_detail.series'.tr(), style: _kLabelStyle),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                seriesLines.join('\n'),
                                style: const TextStyle(fontSize: 13.5, height: 1.45),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(height: 1, color: cs.outlineVariant),

                        // Prize rows
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: prizes.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: cs.outlineVariant),
                          itemBuilder: (_, i) {
                            final p = prizes[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.title, style: _kValueBold),
                                      const SizedBox(height: 2),
                                      Text(p.amount, style: _kLabelStyle),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                    p.number,
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // CTA → WinningResultView
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WinningResultView()),
                      );
                    },
                    style: _ctaStyle(),
                    child: Text(
                      'draw.check'.tr(), // "Check my bonds"
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
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
}

// ---------- shared ----------
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

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          // Logo circle with app logo.png
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary, width: 2),
              color: AppTheme.primary.withOpacity(.06),
              image: const DecorationImage(
                image: AssetImage('assets/icons/logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('home.title'.tr(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('home.info'.tr(),
                        style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(.6))),
                    const SizedBox(width: 10),
                    Text('home.support'.tr(),
                        style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(.6))),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
            icon: const Icon(Icons.notifications_outlined),
            color: AppTheme.primary,
          ),
        ],
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

ButtonStyle _ctaStyle() => ElevatedButton.styleFrom(
  backgroundColor: AppTheme.primary,
  padding: const EdgeInsets.symmetric(vertical: 14),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);

const _kLabelStyle = TextStyle(fontSize: 12.5, color: Color(0x99000000));
const _kValueBold = TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
