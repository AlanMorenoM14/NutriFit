import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/enums.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

/// Repository for user profile operations.
class UserRepository {
  static const _collection = 'users';
  final FirestoreService _firestoreService;

  UserRepository({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  /// Create a new user profile in Firestore.
  Future<void> createUser({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    final now = DateTime.now();
    final user = UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      goal: UserGoal.maintain,
      onboardingCompleted: false,
      createdAt: now,
      updatedAt: now,
    );
    await _firestoreService.setDocument(_collection, uid, user.toJson());
  }

  /// Get user profile by UID.
  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestoreService.getDocument(_collection, uid);
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromJson(doc.data()!);
  }

  /// Stream user profile changes in real time.
  Stream<UserModel?> streamUser(String uid) {
    return _firestoreService.streamDocument(_collection, uid).map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromJson(doc.data()!);
    });
  }

  /// Update user goal.
  Future<void> updateGoal(String uid, UserGoal goal) async {
    await _firestoreService.updateDocument(_collection, uid, {
      'goal': goal.value,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  /// Mark onboarding as completed.
  Future<void> completeOnboarding(String uid, UserGoal goal) async {
    await _firestoreService.updateDocument(_collection, uid, {
      'goal': goal.value,
      'onboardingCompleted': true,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  /// Update display name.
  Future<void> updateDisplayName(String uid, String name) async {
    await _firestoreService.updateDocument(_collection, uid, {
      'displayName': name,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }
}
