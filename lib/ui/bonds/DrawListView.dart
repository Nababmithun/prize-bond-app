import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_routes.dart';

class DrawListView extends StatelessWidget {
  const DrawListView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    // demo data
    final items = List.generate(
      5,
          (i) => (drawNo: 51 + i, date: '21/12/2025'),
    );

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

                // Title card
                Container(
                  decoration: _cardDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'draw.title'.tr(),
                            style: TextStyle(
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: cs.outlineVariant,
                          ),
                          itemBuilder: (_, i) {
                            final it = items[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 14),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text('draw.no'.tr(),
                                          style: _kLabelStyle),
                                      const SizedBox(height: 2),
                                      Text('${it.drawNo}',
                                          style: _kValueBold),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('draw.date'.tr(),
                                          style: _kLabelStyle),
                                      const SizedBox(height: 2),
                                      Text(
                                        it.date,
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

                        // Refresh bar
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF7EF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.refresh,
                                  size: 18,
                                  color: cs.onSurface.withOpacity(.7)),
                              const SizedBox(width: 8),
                              Text(
                                'common.refresh'.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface.withOpacity(.8),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'draw.last_update'.tr(args: ['21/12/2025 12:45 AM']),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: cs.onSurface.withOpacity(.55),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // CTA
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.drawResults),
                    style: _ctaStyle(),
                    child: Text(
                      'draw.check'.tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
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

// ---------- shared bits ----------
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
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(.08),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.card_giftcard,
                  color: AppTheme.primary, size: 28),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('home.title'.tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('home.info'.tr(),
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(.6))),
                    const SizedBox(width: 10),
                    Text('home.support'.tr(),
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(.6))),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
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

const _kLabelStyle =
TextStyle(fontSize: 12.5, color: Color(0x99000000));
const _kValueBold =
TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
