import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../data/models/recipe_model.dart';
import '../../../../ui/core/widgets/glass_card.dart';
import '../providers/recipe_provider.dart';

class RecipeListScreen extends ConsumerWidget {
  final String mealType;
  final String mealLabel;

  const RecipeListScreen({
    super.key,
    required this.mealType,
    required this.mealLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipesProvider(mealType));

    return Scaffold(
      appBar: AppBar(
        title: Text('Recetas para $mealLabel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: recipesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: NutrifitTheme.primary),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: NutrifitTheme.error,
              ),
              const SizedBox(height: NutrifitTheme.spacingMd),
              Text('Error: $e'),
            ],
          ),
        ),
        data: (recipes) {
          if (recipes.isEmpty) {
            return _EmptyRecipes(mealLabel: mealLabel);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(NutrifitTheme.spacingLg),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return _RecipeCard(
                recipe: recipe,
                index: index,
                onTap: () {
                  final mealId =
                      GoRouterState.of(context).uri.queryParameters['mealId'];
                  context.pushNamed(
                    'recipeDetail',
                    pathParameters: {'recipeId': recipe.id},
                    queryParameters: {
                      if (mealId != null) 'mealId': mealId,
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ─── Recipe Card ───────────────────────────────────────────────

class _RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final int index;
  final VoidCallback onTap;

  const _RecipeCard({
    required this.recipe,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: NutrifitTheme.spacingMd),
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.all(NutrifitTheme.spacingMd),
        child: Row(
          children: [
            // Recipe icon placeholder
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: NutrifitTheme.cardGradient,
                borderRadius: BorderRadius.circular(NutrifitTheme.radiusMd),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: Center(
                child: Text(
                  recipe.mealType.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: NutrifitTheme.spacingMd),

            // Recipe info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Metadata chips
                  Row(
                    children: [
                      _MetaChip(
                        icon: Icons.local_fire_department_rounded,
                        label: '${recipe.calories} kcal',
                        color: NutrifitTheme.accent,
                      ),
                      const SizedBox(width: 8),
                      _MetaChip(
                        icon: Icons.timer_outlined,
                        label: '${recipe.prepTimeMinutes} min',
                        color: NutrifitTheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      _MetaChip(
                        icon: Icons.signal_cellular_alt_rounded,
                        label: recipe.difficulty == 'easy' ? 'Fácil' : 'Media',
                        color: NutrifitTheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: NutrifitTheme.textMuted,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 100 + (index * 80)),
          duration: 400.ms,
        )
        .slideX(begin: 0.05, end: 0);
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty State ───────────────────────────────────────────────

class _EmptyRecipes extends StatelessWidget {
  final String mealLabel;

  const _EmptyRecipes({required this.mealLabel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(NutrifitTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: NutrifitTheme.surfaceLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_menu_rounded,
                size: 40,
                color: NutrifitTheme.textMuted,
              ),
            ),
            const SizedBox(height: NutrifitTheme.spacingMd),
            Text(
              'Sin recetas aún',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: NutrifitTheme.spacingSm),
            Text(
              'No hay recetas disponibles para "$mealLabel"\ncon tu objetivo actual.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
      ),
    );
  }
}
