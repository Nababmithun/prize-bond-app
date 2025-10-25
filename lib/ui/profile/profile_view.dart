import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/viewmodels/ProfileViewModel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _fade = CurvedAnimation(parent: _ac, curve: Curves.easeInOut);
    _slide = Tween<Offset>(begin: const Offset(0, .12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadProfileAndBonds();
    });
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final cs = Theme.of(context).colorScheme;

    final user = vm.user;
    final bonds = vm.bonds;

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
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: vm.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                    : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Profile Info
                    Container(
                      padding: const EdgeInsets.all(16),
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
                            radius: 30,
                            backgroundColor: AppTheme.primary.withOpacity(.15),
                            backgroundImage: (user?['image'] != null)
                                ? NetworkImage(
                                'https://prize-bond-test.peopleplusbd.com/${user?['image']}')
                                : null,
                            child: user?['image'] == null
                                ? const Icon(Icons.person, color: AppTheme.primary)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user?['name'] ?? '—',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 16)),
                                const SizedBox(height: 2),
                                Text(user?['email'] ?? '',
                                    style: TextStyle(
                                        fontSize: 12.5,
                                        color: cs.onSurface.withOpacity(.6))),
                                Text(user?['phone'] ?? '',
                                    style: TextStyle(
                                        fontSize: 12.5,
                                        color: cs.onSurface.withOpacity(.6))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Bonds List
                    Text(
                      'My Prize Bonds (${bonds.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

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
                        itemCount: bonds.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 1, color: cs.outlineVariant),
                        itemBuilder: (_, i) {
                          final b = bonds[i];
                          return ListTile(
                            title: Text(
                              '৳${b['price']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            subtitle: Text(
                              b['code'] ?? '',
                              style: TextStyle(
                                  fontSize: 12.5,
                                  color: cs.onSurface.withOpacity(.6)),
                            ),
                            trailing: Text(
                              b['series']?['name'] ?? '',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: cs.onSurface.withOpacity(.65)),
                            ),
                          );
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
}
