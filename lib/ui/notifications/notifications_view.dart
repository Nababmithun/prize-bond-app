import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  // filter will now use language-independent keys
  String _filter = 'all';

  final _items = List.generate(
    7,
        (i) => (
    title: tr('notifications.sample_title').isEmpty
        ? 'Lorem Ipsum is simply dummy text'
        : tr('notifications.sample_title'),
    body: tr('notifications.sample_body').isEmpty
        ? 'This is a sample notification text.'
        : tr('notifications.sample_body'),
    time: tr('notifications.time', args: ['2h']).isEmpty
        ? '2h ago'
        : tr('notifications.time', args: ['2h']),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // background
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(4, 4, 12, 16),
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            tr('notifications.title').isEmpty
                                ? 'Notifications'
                                : tr('notifications.title'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // inner white card
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: cs.outlineVariant.withOpacity(.4)),
                        ),
                        child: Column(
                          children: [
                            // 🔹 header row
                            Row(
                              children: [
                                Text(
                                  tr('notifications.all_title').isEmpty
                                      ? 'All Notifications (23)'
                                      : tr('notifications.all_title'),
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: cs.onSurface.withOpacity(.8),
                                  ),
                                ),
                                const Spacer(),
                                _FilterChip(
                                  value: _filter,
                                  onChanged: (v) => setState(() => _filter = v),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // notification list
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _items.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 1,
                                color: cs.outlineVariant.withOpacity(.4),
                              ),
                              itemBuilder: (_, i) {
                                final it = _items[i];
                                return _NotificationTile(
                                  title: it.title,
                                  subtitle: it.body,
                                  time: it.time,
                                );
                              },
                            ),
                          ],
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

class _NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  const _NotificationTile({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primary, width: 1.2),
            ),
            child: const Icon(Icons.campaign_outlined, size: 20, color: AppTheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: cs.onSurface.withOpacity(.6), fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(.5)),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _FilterChip({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final options = [
      {'key': 'all', 'label': tr('notifications.filter_all')},
      {'key': 'read', 'label': tr('notifications.filter_read')},
      {'key': 'unread', 'label': tr('notifications.filter_unread')},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8F3),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppTheme.primary.withOpacity(.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value, // now stores key instead of label
          isDense: true,
          items: options
              .map(
                (opt) => DropdownMenuItem<String>(
              value: opt['key']!,
              child: Text(
                opt['label']!,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          icon: const Icon(Icons.expand_more),
        ),
      ),
    );
  }
}
