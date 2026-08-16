import 'auth_service.dart';
import 'philotes_auth_service.dart';

class AuthServices {
  const AuthServices._();
  static AuthService current = PhilotesAuthService();
  static void reset() => current = PhilotesAuthService();
}
