import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/user_repository.dart';
import '../../../../domain/models/enums.dart';
import '../../../features/auth/providers/auth_provider.dart';

// ─── Onboarding Actions ────────────────────────────────────────
final onboardingActionsProvider = Provider<OnboardingActions>((ref) {
  return OnboardingActions(
    userRepository: ref.read(userRepositoryProvider),
  );
});

class OnboardingActions {
  final UserRepository _userRepository;

  OnboardingActions({required UserRepository userRepository})
      : _userRepository = userRepository;

  /// Complete onboarding by saving the selected goal.
  Future<void> completeOnboarding(String uid, UserGoal goal) async {
    await _userRepository.completeOnboarding(uid, goal);
  }
}

// ─── Selected Goal State ───────────────────────────────────────
/// Temporary state for the goal selected during onboarding.
final selectedGoalProvider =
    NotifierProvider<SelectedGoalNotifier, UserGoal?>(
  SelectedGoalNotifier.new,
);

class SelectedGoalNotifier extends Notifier<UserGoal?> {
  @override
  UserGoal? build() => null;

  void select(UserGoal goal) {
    state = goal;
  }
}
