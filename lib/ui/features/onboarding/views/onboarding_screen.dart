import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../domain/models/enums.dart';
import '../../../../ui/core/widgets/glass_card.dart';
import '../../../../ui/core/widgets/gradient_button.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _isLoading = false;

  Future<void> _handleContinue() async {
    final selectedGoal = ref.read(selectedGoalProvider);
    if (selectedGoal == null) return;

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(onboardingActionsProvider).completeOnboarding(
            user.uid,
            selectedGoal,
          );

      if (mounted) {
        context.goNamed('home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedGoal = ref.watch(selectedGoalProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(NutrifitTheme.spacingLg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  // ─── Header ───────────────────────────────
                  Column(
                    children: [
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
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.flag_rounded,
                          size: 36,
                          color: NutrifitTheme.background,
                        ),
                      ),
                      const SizedBox(height: NutrifitTheme.spacingMd),
                      Text(
                        '¿Cuál es tu objetivo?',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: NutrifitTheme.spacingSm),
                      Text(
                        'Esto nos ayudará a recomendarte las recetas\nperfectas para ti.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.15, end: 0),

                  const SizedBox(height: NutrifitTheme.spacingXl),

                  // ─── Goal Cards ───────────────────────────
                  ...UserGoal.values.asMap().entries.map((entry) {
                    final index = entry.key;
                    final goal = entry.value;
                    final isSelected = selectedGoal == goal;

                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: NutrifitTheme.spacingMd),
                      child: _GoalCard(
                        goal: goal,
                        isSelected: isSelected,
                        onTap: () {
                          ref.read(selectedGoalProvider.notifier).select(goal);
                        },
                      ),
                    )
                        .animate()
                        .fadeIn(
                          delay: Duration(milliseconds: 300 + (index * 120)),
                          duration: 500.ms,
                        )
                        .slideX(begin: 0.15, end: 0);
                  }),

                  const SizedBox(height: NutrifitTheme.spacingLg),

                  // ─── Continue Button ──────────────────────
                  GradientButton(
                    text: 'Continuar',
                    isLoading: _isLoading,
                    onPressed: selectedGoal != null ? _handleContinue : null,
                    icon: Icons.arrow_forward_rounded,
                  )
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 500.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual goal selection card.
class _GoalCard extends StatelessWidget {
  final UserGoal goal;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });



  Color get _color {
    switch (goal) {
      case UserGoal.gainWeight:
        return NutrifitTheme.goalGain;
      case UserGoal.loseWeight:
        return NutrifitTheme.goalLose;
      case UserGoal.maintain:
        return NutrifitTheme.goalMaintain;
    }
  }

  String get _description {
    switch (goal) {
      case UserGoal.gainWeight:
        return 'Recetas hipercalóricas y nutritivas para aumentar masa.';
      case UserGoal.loseWeight:
        return 'Recetas ligeras y balanceadas para reducir grasa.';
      case UserGoal.maintain:
        return 'Recetas equilibradas para mantener tu peso actual.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      borderColor: isSelected
          ? _color
          : Colors.white.withValues(alpha: NutrifitTheme.glassBorderOpacity),
      padding: const EdgeInsets.all(NutrifitTheme.spacingMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        child: Row(
          children: [
            // Icon circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? _color.withValues(alpha: 0.2)
                    : NutrifitTheme.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? _color.withValues(alpha: 0.5)
                      : Colors.transparent,
                ),
              ),
              child: Center(
                child: Text(
                  goal.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: NutrifitTheme.spacingMd),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected ? _color : null,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Check indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? _color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? _color
                      : Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
