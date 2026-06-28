import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../ui/core/widgets/glass_card.dart';
import '../../../../ui/core/widgets/gradient_button.dart';
import '../../../features/home/providers/daily_log_provider.dart';
import '../providers/recipe_provider.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final String recipeId;
  final String? mealId;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
    this.mealId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeAsync = ref.watch(recipeDetailProvider(recipeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Receta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: recipeAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: NutrifitTheme.primary),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (recipe) {
          if (recipe == null) {
            return const Center(child: Text('Receta no encontrada'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(NutrifitTheme.spacingLg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Header Card ──────────────────────────
                  GlassCard(
                    padding: const EdgeInsets.all(NutrifitTheme.spacingLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Emoji + Title
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: NutrifitTheme.primaryGradient,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  recipe.mealType.emoji,
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ),
                            ),
                            const SizedBox(width: NutrifitTheme.spacingMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    recipe.description,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: NutrifitTheme.spacingMd),

                        // Metadata row
                        Row(
                          children: [
                            _DetailChip(
                              icon: Icons.local_fire_department_rounded,
                              label: '${recipe.calories} kcal',
                              color: NutrifitTheme.accent,
                            ),
                            const SizedBox(width: 12),
                            _DetailChip(
                              icon: Icons.timer_outlined,
                              label: '${recipe.prepTimeMinutes} min',
                              color: NutrifitTheme.secondary,
                            ),
                            const SizedBox(width: 12),
                            _DetailChip(
                              icon: Icons.signal_cellular_alt_rounded,
                              label: recipe.difficulty == 'easy'
                                  ? 'Fácil'
                                  : 'Media',
                              color: NutrifitTheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.05, end: 0),

                  const SizedBox(height: NutrifitTheme.spacingLg),

                  // ─── Ingredients ───────────────────────────
                  Text(
                    'Ingredientes',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms),
                  const SizedBox(height: NutrifitTheme.spacingSm),
                  ...recipe.ingredients.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: NutrifitTheme.spacingSm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 7),
                            decoration: const BoxDecoration(
                              color: NutrifitTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(
                          delay: Duration(
                              milliseconds: 300 + (entry.key * 60)),
                          duration: 300.ms,
                        );
                  }),

                  const SizedBox(height: NutrifitTheme.spacingLg),

                  // ─── Steps ────────────────────────────────
                  Text(
                    'Preparación',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms),
                  const SizedBox(height: NutrifitTheme.spacingSm),
                  ...recipe.steps.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: NutrifitTheme.spacingMd),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: NutrifitTheme.primary
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: const TextStyle(
                                  color: NutrifitTheme.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(
                          delay: Duration(
                              milliseconds: 500 + (entry.key * 80)),
                          duration: 300.ms,
                        );
                  }),

                  const SizedBox(height: NutrifitTheme.spacingLg),

                  // ─── Select Recipe Button ─────────────────
                  if (mealId != null)
                    GradientButton(
                      text: 'Elegir esta receta',
                      icon: Icons.check_circle_outline_rounded,
                      onPressed: () {
                        ref
                            .read(dailyLogProvider.notifier)
                            .linkRecipe(mealId!, recipeId);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '✅ "${recipe.title}" seleccionada',
                            ),
                          ),
                        );

                        // Go back to home
                        context.goNamed('home');
                      },
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: NutrifitTheme.spacingXl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _DetailChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
