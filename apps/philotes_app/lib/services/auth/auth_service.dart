import '../../models/auth/auth_session.dart';
import '../../models/auth/auth_user.dart';

class AuthApiException implements Exception {
  const AuthApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => message;
}

abstract class AuthService {
  Future<AuthUser> register({required String email, required String password});
  Future<AuthUser> login({required String email, required String password});
  Future<AuthUser> currentUser();
  Future<void> resendVerification();
  Future<void> forgotPassword(String email);
  Future<void> logout();
  AuthSession? get currentSession;
  AuthUser? get cachedUser;
}
