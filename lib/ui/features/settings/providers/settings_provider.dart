import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/user_repository.dart';
import '../../../../domain/models/enums.dart';
import '../../../features/auth/providers/auth_provider.dart';

// ─── Settings Actions ──────────────────────────────────────────
final settingsActionsProvider = Provider<SettingsActions>((ref) {
  return SettingsActions(
    userRepository: ref.read(userRepositoryProvider),
  );
});

class SettingsActions {
  final UserRepository _userRepository;

  SettingsActions({required UserRepository userRepository})
      : _userRepository = userRepository;

  /// Update user's physical goal.
  Future<void> updateGoal(String uid, UserGoal goal) async {
    await _userRepository.updateGoal(uid, goal);
  }

  /// Update display name.
  Future<void> updateDisplayName(String uid, String name) async {
    await _userRepository.updateDisplayName(uid, name);
  }
}
