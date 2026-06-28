import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../ui/features/auth/providers/auth_provider.dart';
import '../ui/features/auth/views/login_screen.dart';
import '../ui/features/auth/views/register_screen.dart';
import '../ui/features/home/views/home_screen.dart';
import '../ui/features/onboarding/views/onboarding_screen.dart';
import '../ui/features/recipes/views/recipe_detail_screen.dart';
import '../ui/features/recipes/views/recipe_list_screen.dart';
import '../ui/features/settings/views/settings_screen.dart';

/// GoRouter configuration with auth-based redirects.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final userProfile = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isOnAuthPage = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // Not logged in → force to login
      if (!isLoggedIn && !isOnAuthPage) {
        return '/login';
      }

      // Logged in but on auth page → check onboarding
      if (isLoggedIn && isOnAuthPage) {
        final user = userProfile.value;
        if (user != null && !user.onboardingCompleted) {
          return '/onboarding';
        }
        return '/home';
      }

      // Logged in, check if onboarding needed
      if (isLoggedIn && state.matchedLocation == '/home') {
        final user = userProfile.value;
        if (user != null && !user.onboardingCompleted) {
          return '/onboarding';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: _slideUpTransition,
        ),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/recipes/:mealType',
        name: 'recipes',
        pageBuilder: (context, state) {
          final mealType = state.pathParameters['mealType']!;
          final mealLabel = state.uri.queryParameters['label'] ?? 'Recetas';
          return CustomTransitionPage(
            key: state.pageKey,
            child: RecipeListScreen(
              mealType: mealType,
              mealLabel: mealLabel,
            ),
            transitionsBuilder: _slideTransition,
          );
        },
      ),
      GoRoute(
        path: '/recipe-detail/:recipeId',
        name: 'recipeDetail',
        pageBuilder: (context, state) {
          final recipeId = state.pathParameters['recipeId']!;
          final mealId = state.uri.queryParameters['mealId'];
          return CustomTransitionPage(
            key: state.pageKey,
            child: RecipeDetailScreen(
              recipeId: recipeId,
              mealId: mealId,
            ),
            transitionsBuilder: _slideTransition,
          );
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
    ],
  );
});

// ─── Page Transitions ──────────────────────────────────────────

Widget _fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(opacity: animation, child: child);
}

Widget _slideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
    child: child,
  );
}

Widget _slideUpTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
    child: FadeTransition(opacity: animation, child: child),
  );
}
