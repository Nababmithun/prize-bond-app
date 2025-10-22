import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/prize_bond.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final _search = TextEditingController();

  // demo data
  final List<PrizeBond> _bonds = List.generate(
    10,
        (i) => PrizeBond(series: 'KK', number: '123456789'),
  );

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fade = CurvedAnimation(parent: _ac, curve: Curves.easeInOut);
    _slide = Tween<Offset>(begin: const Offset(0, .12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // soft gradient background
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
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: ListView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: [
                    // 🪪 Header card
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
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
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppTheme.primary.withOpacity(.15),
                            child: const Icon(Icons.person,
                                color: AppTheme.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pritom Basak',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'example@gmail.com',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: cs.onSurface.withOpacity(.65),
                                  ),
                                ),
                                Text(
                                  '+8801234567899',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: cs.onSurface.withOpacity(.65),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section title
                    Center(
                      child: Text(
                        '${'profile.my_bonds'.tr()} (${_filteredBonds.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Search box
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF6EA),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                  color: Colors.green.withOpacity(.25)),
                            ),
                            child: TextField(
                              controller: _search,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                hintText: 'profile.search'.tr(),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                              ),
                              onSubmitted: (_) => setState(() {}),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 48,
                          width: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () => setState(() {}),
                            child: const Icon(Icons.search, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Bond list card
                    Container(
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
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredBonds.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 1, color: cs.outlineVariant),
                        itemBuilder: (_, i) {
                          final b = _filteredBonds[i];
                          return _BondRow(series: b.series, number: b.number);
                        },
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

  List<PrizeBond> get _filteredBonds {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return _bonds;
    return _bonds
        .where((e) =>
    e.series.toLowerCase().contains(q) ||
        e.number.toLowerCase().contains(q))
        .toList();
  }
}

class _BondRow extends StatelessWidget {
  final String series;
  final String number;
  const _BondRow({required this.series, required this.number});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Labels
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Series',
                  style: TextStyle(
                      fontSize: 12.5, color: cs.onSurface.withOpacity(.6))),
              const SizedBox(height: 2),
              Text('Number',
                  style: TextStyle(
                      fontSize: 12.5, color: cs.onSurface.withOpacity(.6))),
            ],
          ),
          const SizedBox(width: 12),

          // Values
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(series,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 2),
                Text(number,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
              ],
            ),
          ),

          // Faint right text
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(series,
                  style: TextStyle(
                      fontSize: 12.5, color: cs.onSurface.withOpacity(.45))),
              const SizedBox(height: 2),
              Text(number,
                  style: TextStyle(
                      fontSize: 12.5, color: cs.onSurface.withOpacity(.45))),
            ],
          ),
        ],
      ),
    );
  }
}
