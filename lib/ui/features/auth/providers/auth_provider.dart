import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../data/services/firebase_auth_service.dart';
import '../../../../data/services/firestore_service.dart';

// ─── Service Providers ─────────────────────────────────────────
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// ─── Repository Providers ──────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(authService: ref.watch(firebaseAuthServiceProvider));
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(firestoreService: ref.watch(firestoreServiceProvider));
});

// ─── Auth State Provider ───────────────────────────────────────
/// Streams Firebase Auth state changes (login/logout).
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// ─── Current User Profile Provider ─────────────────────────────
/// Streams the current user's Firestore profile.
/// Returns null if not logged in.
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.watch(userRepositoryProvider).streamUser(user.uid);
    },
    loading: () => Stream.value(null),
    error: (_, _) => Stream.value(null),
  );
});

// ─── Auth Actions Provider ─────────────────────────────────────
/// Handles login, register, and sign-out actions.
final authActionsProvider = Provider<AuthActions>((ref) {
  return AuthActions(
    authRepository: ref.read(authRepositoryProvider),
    userRepository: ref.read(userRepositoryProvider),
  );
});

class AuthActions {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthActions({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _authRepository.signIn(email: email, password: password);
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final user = await _authRepository.register(
      email: email,
      password: password,
    );
    if (user != null) {
      await _userRepository.createUser(
        uid: user.uid,
        email: email,
        displayName: displayName,
      );
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
