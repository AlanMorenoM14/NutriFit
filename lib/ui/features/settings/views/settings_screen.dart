import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../domain/models/enums.dart';
import '../../../../ui/core/constants.dart';
import '../../../../ui/core/widgets/glass_card.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) {
          if (user == null) return const SizedBox();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(NutrifitTheme.spacingLg),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    // ─── Profile Card ─────────────────────────
                    GlassCard(
                      padding:
                          const EdgeInsets.all(NutrifitTheme.spacingLg),
                      child: Column(
                        children: [
                          // Avatar
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: NutrifitTheme.primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: NutrifitTheme.primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                user.displayName.isNotEmpty
                                    ? user.displayName[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: NutrifitTheme.background,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: NutrifitTheme.spacingMd),
                          Text(
                            user.displayName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: -0.05, end: 0),

                    const SizedBox(height: NutrifitTheme.spacingLg),

                    // ─── Goal Section ─────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tu Objetivo',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms),

                    const SizedBox(height: NutrifitTheme.spacingSm),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Cambia tu objetivo y las recetas se actualizarán automáticamente.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 250.ms, duration: 400.ms),

                    const SizedBox(height: NutrifitTheme.spacingMd),

                    ...UserGoal.values.asMap().entries.map((entry) {
                      final index = entry.key;
                      final goal = entry.value;
                      final isSelected = user.goal == goal;

                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: NutrifitTheme.spacingSm),
                        child: _GoalOption(
                          goal: goal,
                          isSelected: isSelected,
                          onTap: () async {
                            if (isSelected) return;
                            await ref
                                .read(settingsActionsProvider)
                                .updateGoal(user.uid, goal);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${goal.emoji} Objetivo actualizado a "${goal.label}"',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      )
                          .animate()
                          .fadeIn(
                            delay: Duration(
                                milliseconds: 300 + (index * 100)),
                            duration: 400.ms,
                          )
                          .slideX(begin: 0.05, end: 0);
                    }),

                    const SizedBox(height: NutrifitTheme.spacingXl),

                    // ─── Sign Out ─────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await ref.read(authActionsProvider).signOut();
                          if (context.mounted) {
                            context.goNamed('login');
                          }
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: NutrifitTheme.error,
                        ),
                        label: const Text(
                          'Cerrar Sesión',
                          style: TextStyle(color: NutrifitTheme.error),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: NutrifitTheme.error.withValues(alpha: 0.3),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 400.ms),

                    const SizedBox(height: NutrifitTheme.spacingLg),

                    // App version
                    Text(
                      'NutriFit v${AppConstants.appVersion}',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                        .animate()
                        .fadeIn(delay: 700.ms, duration: 400.ms),

                    const SizedBox(height: NutrifitTheme.spacingXl),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Goal Option ───────────────────────────────────────────────

class _GoalOption extends StatelessWidget {
  final UserGoal goal;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalOption({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  Color get _color => NutrifitTheme.goalColor(goal.value);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      borderColor: isSelected
          ? _color
          : Colors.white.withValues(alpha: NutrifitTheme.glassBorderOpacity),
      padding: const EdgeInsets.symmetric(
        horizontal: NutrifitTheme.spacingMd,
        vertical: 14,
      ),
      child: Row(
        children: [
          Text(
            goal.emoji,
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(width: NutrifitTheme.spacingMd),
          Expanded(
            child: Text(
              goal.label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected ? _color : null,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isSelected ? _color : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    isSelected ? _color : Colors.white.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }
}
