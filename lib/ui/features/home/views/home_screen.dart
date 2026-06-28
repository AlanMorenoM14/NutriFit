import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme.dart';
import '../../../../data/models/daily_log_model.dart';
import '../../../../domain/models/enums.dart';
import '../../../../ui/core/widgets/animated_checkbox.dart';
import '../../../../ui/core/widgets/glass_card.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../providers/daily_log_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final dailyLogAsync = ref.watch(dailyLogProvider);

    return Scaffold(
      body: SafeArea(
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (user) {
            if (user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              color: NutrifitTheme.primary,
              backgroundColor: NutrifitTheme.surface,
              onRefresh: () async {
                ref.invalidate(dailyLogProvider);
              },
              child: CustomScrollView(
                slivers: [
                  // ─── Header ─────────────────────────────────
                  SliverToBoxAdapter(
                    child: _HomeHeader(
                      userName: user.displayName,
                      goal: user.goal,
                    ),
                  ),

                  // ─── Progress Card ──────────────────────────
                  SliverToBoxAdapter(
                    child: dailyLogAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(NutrifitTheme.spacingLg),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: NutrifitTheme.primary,
                          ),
                        ),
                      ),
                      error: (e, _) => Padding(
                        padding: const EdgeInsets.all(NutrifitTheme.spacingLg),
                        child: Text('Error cargando el log: $e'),
                      ),
                      data: (log) {
                        if (log == null) {
                          return const Padding(
                            padding: EdgeInsets.all(NutrifitTheme.spacingLg),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: NutrifitTheme.primary,
                              ),
                            ),
                          );
                        }
                        return _ProgressSection(log: log);
                      },
                    ),
                  ),

                  // ─── Section Title ──────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: NutrifitTheme.spacingLg,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Comidas del día',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('EEEE d', 'es').format(DateTime.now()),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: NutrifitTheme.primary),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 500.ms),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: NutrifitTheme.spacingMd),
                  ),

                  // ─── Meal Checklist ─────────────────────────
                  dailyLogAsync.when(
                    loading: () => const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => SliverToBoxAdapter(
                      child: Text('Error: $e'),
                    ),
                    data: (log) {
                      if (log == null) {
                        return const SliverToBoxAdapter(child: SizedBox());
                      }
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: NutrifitTheme.spacingLg,
                        ),
                        sliver: SliverList.builder(
                          itemCount: log.meals.length,
                          itemBuilder: (context, index) {
                            final meal = log.meals[index];
                            return _MealTile(
                              meal: meal,
                              index: index,
                              onToggle: () {
                                ref
                                    .read(dailyLogProvider.notifier)
                                    .toggleMeal(meal.id);
                              },
                              onViewRecipes: () {
                                context.pushNamed(
                                  'recipes',
                                  pathParameters: {
                                    'mealType': meal.mealType.value
                                  },
                                  queryParameters: {
                                    'label': meal.label,
                                    'mealId': meal.id,
                                  },
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),

                  // ─── Add Meal Button ────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(NutrifitTheme.spacingLg),
                      child: _AddMealButton(
                        onPressed: () => _showAddMealSheet(context, ref),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 700.ms, duration: 500.ms),
                  ),

                  // Bottom spacing
                  const SliverToBoxAdapter(
                    child: SizedBox(height: NutrifitTheme.spacingXl),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddMealSheet(BuildContext context, WidgetRef ref) {
    final labelController = TextEditingController();
    MealType selectedType = MealType.snack;

    showModalBottomSheet(
      context: context,
      backgroundColor: NutrifitTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(NutrifitTheme.radiusXl),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: NutrifitTheme.spacingLg,
                right: NutrifitTheme.spacingLg,
                top: NutrifitTheme.spacingLg,
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    NutrifitTheme.spacingLg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: NutrifitTheme.spacingLg),
                  Text(
                    'Añadir Comida',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: NutrifitTheme.spacingMd),

                  // Name field
                  TextFormField(
                    controller: labelController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Nombre (ej: Merienda, Snack)',
                      prefixIcon: Icon(Icons.restaurant_outlined),
                    ),
                  ),
                  const SizedBox(height: NutrifitTheme.spacingMd),

                  // Meal type selector
                  Text(
                    'Tipo de comida',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: NutrifitTheme.spacingSm),
                  Wrap(
                    spacing: 8,
                    children: MealType.values.map((type) {
                      final isSelected = selectedType == type;
                      return ChoiceChip(
                        label: Text('${type.emoji} ${type.label}'),
                        selected: isSelected,
                        selectedColor:
                            NutrifitTheme.primary.withValues(alpha: 0.2),
                        backgroundColor: NutrifitTheme.surfaceLight,
                        side: BorderSide(
                          color: isSelected
                              ? NutrifitTheme.primary
                              : Colors.transparent,
                        ),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? NutrifitTheme.primary
                              : NutrifitTheme.textSecondary,
                        ),
                        onSelected: (_) {
                          setSheetState(() => selectedType = type);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: NutrifitTheme.spacingLg),

                  // Add button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final label = labelController.text.trim();
                        if (label.isEmpty) return;

                        ref.read(dailyLogProvider.notifier).addMeal(
                              label: label,
                              mealType: selectedType,
                            );
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Añadir'),
                    ),
                  ),
                  const SizedBox(height: NutrifitTheme.spacingSm),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Home Header ───────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  final String userName;
  final UserGoal goal;

  const _HomeHeader({required this.userName, required this.goal});

  @override
  Widget build(BuildContext context) {
    final firstName = userName.split(' ').first;
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Buenos días';
    } else if (hour < 18) {
      greeting = 'Buenas tardes';
    } else {
      greeting = 'Buenas noches';
    }

    return Padding(
      padding: const EdgeInsets.all(NutrifitTheme.spacingLg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting 👋',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  firstName,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                ),
              ],
            ),
          ),
          // Settings button
          GestureDetector(
            onTap: () => context.pushNamed('settings'),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: NutrifitTheme.surfaceLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: NutrifitTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: -0.1, end: 0);
  }
}

// ─── Progress Section ──────────────────────────────────────────

class _ProgressSection extends StatelessWidget {
  final DailyLogModel log;

  const _ProgressSection({required this.log});

  @override
  Widget build(BuildContext context) {
    final progress = log.completionProgress;
    final completed = log.meals.where((m) => m.completed).length;
    final total = log.meals.length;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NutrifitTheme.spacingLg,
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(NutrifitTheme.spacingMd),
        child: Column(
          children: [
            Row(
              children: [
                // Progress circle
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        strokeCap: StrokeCap.round,
                        backgroundColor:
                            NutrifitTheme.surfaceLight,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress == 1.0
                              ? NutrifitTheme.success
                              : NutrifitTheme.primary,
                        ),
                      ),
                      Center(
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: NutrifitTheme.textPrimary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: NutrifitTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        progress == 1.0
                            ? '¡Día completado! 🎉'
                            : 'Progreso del día',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$completed de $total comidas registradas',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 500.ms)
        .slideY(begin: 0.1, end: 0);
  }
}

// ─── Meal Tile ─────────────────────────────────────────────────

class _MealTile extends StatelessWidget {
  final MealEntry meal;
  final int index;
  final VoidCallback onToggle;
  final VoidCallback onViewRecipes;

  const _MealTile({
    required this.meal,
    required this.index,
    required this.onToggle,
    required this.onViewRecipes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: NutrifitTheme.spacingSm),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(
          horizontal: NutrifitTheme.spacingMd,
          vertical: 14,
        ),
        borderColor: meal.completed
            ? NutrifitTheme.primary.withValues(alpha: 0.3)
            : null,
        child: Row(
          children: [
            // Checkbox
            AnimatedCheckbox(
              checked: meal.completed,
              onChanged: (_) => onToggle(),
            ),
            const SizedBox(width: NutrifitTheme.spacingMd),

            // Meal info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${meal.mealType.emoji}  ${meal.label}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: meal.completed
                              ? TextDecoration.lineThrough
                              : null,
                          color: meal.completed
                              ? NutrifitTheme.textMuted
                              : null,
                        ),
                  ),
                  if (meal.completed && meal.completedAt != null)
                    Text(
                      'Completado a las ${DateFormat.jm().format(meal.completedAt!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: NutrifitTheme.primary.withValues(alpha: 0.7),
                          ),
                    ),
                ],
              ),
            ),

            // View recipes button
            IconButton(
              onPressed: onViewRecipes,
              icon: const Icon(
                Icons.menu_book_rounded,
                color: NutrifitTheme.textMuted,
                size: 22,
              ),
              tooltip: 'Ver recetas',
              style: IconButton.styleFrom(
                backgroundColor:
                    NutrifitTheme.surfaceLight.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 450 + (index * 100)),
          duration: 400.ms,
        )
        .slideX(begin: 0.08, end: 0);
  }
}

// ─── Add Meal Button ───────────────────────────────────────────

class _AddMealButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddMealButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(NutrifitTheme.spacingMd),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(NutrifitTheme.radiusLg),
          border: Border.all(
            color: NutrifitTheme.primary.withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ),
          color: NutrifitTheme.primary.withValues(alpha: 0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              color: NutrifitTheme.primary.withValues(alpha: 0.8),
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'Añadir otra comida',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: NutrifitTheme.primary.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
