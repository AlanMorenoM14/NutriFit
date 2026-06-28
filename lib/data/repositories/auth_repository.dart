import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';

/// Repository for authentication operations.
/// Acts as single source of truth for auth state.
class AuthRepository {
  final FirebaseAuthService _authService;

  AuthRepository({required FirebaseAuthService authService})
      : _authService = authService;

  /// Stream of auth state changes.
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  /// Current authenticated user.
  User? get currentUser => _authService.currentUser;

  /// Sign in with email/password.
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signInWithEmail(
      email: email,
      password: password,
    );
    return credential.user;
  }

  /// Register a new account.
  Future<User?> register({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.registerWithEmail(
      email: email,
      password: password,
    );
    return credential.user;
  }

  /// Sign out.
  Future<void> signOut() => _authService.signOut();
}
