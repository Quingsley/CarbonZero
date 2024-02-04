import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/auth/data/remote_data_source/auth_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [AuthRepository] class is a repository for authentication
class AuthRepository {
  /// const constructor
  AuthRepository({required this.dataSource});

  /// instance of [AuthDataSource]
  final AuthDataSource dataSource;

  /// forgot password method
  Future<UserModel?> forgotPassword(String email) async {
    return dataSource.forgotPassword(email);
  }

  /// sign in method
  Future<UserModel> signIn(String email, String password) async {
    final data = await dataSource.signIn(email, password);
    return data;
  }

  /// sign up method
  Future<UserModel> signUp(UserModel user, String password) async {
    final data = await dataSource.signUp(password, user);
    return data;
  }

  /// upload profile image method
  Future<UserModel> uploadProfileImage(String path, String userId) async {
    return dataSource.uploadProfileImage(path, userId);
  }

  /// sign out method
  Future<UserModel?> signOut() {
    return dataSource.signOut();
  }
}

/// will provide an instance of [AuthRepository]
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.read(authDataSourceProvider);
  return AuthRepository(dataSource: dataSource);
});