import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/models/auth/auth_session.dart';
import 'package:philotes/models/auth/auth_user.dart';
import 'package:philotes/screens/auth/sign_in_screen.dart';
import 'package:philotes/screens/welcome_screen.dart';
import 'package:philotes/services/auth/auth_service.dart';
import 'package:philotes/services/auth/auth_services.dart';

class FakeAuth implements AuthService {
  AuthUser user = const AuthUser(
    id: 'u1',
    email: 'member@example.com',
    emailVerified: false,
    isActive: true,
  );
  int loginCalls = 0;

  @override
  AuthSession? get currentSession => const AuthSession(
        accessToken: 'a',
        refreshToken: 'r',
        expiresIn: 900,
      );
  @override
  AuthUser? get cachedUser => user;
  @override
  Future<AuthUser> register(
          {required String email, required String password}) async =>
      user;
  @override
  Future<AuthUser> login(
      {required String email, required String password}) async {
    loginCalls++;
    return user;
  }
  @override
  Future<AuthUser> currentUser() async => user;
  @override
  Future<void> resendVerification() async {}
  @override
  Future<void> forgotPassword(String email) async {}
  @override
  Future<void> logout() async {}
}

void main() {
  late FakeAuth fake;

  setUp(() {
    fake = FakeAuth();
    AuthServices.current = fake;
  });
  tearDown(AuthServices.reset);

  testWidgets('Welcome Sign In opens real sign-in screen', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: PhilotesWelcomeScreen()),
    );
    final signInButton = find.byKey(const Key('signInButton'));
    await tester.ensureVisible(signInButton);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('signInScreen')), findsOneWidget);
  });

  testWidgets('Sign In uses auth service', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignInScreen()));
    await tester.enterText(
        find.byKey(const Key('signInEmailField')), 'member@example.com');
    await tester.enterText(
        find.byKey(const Key('signInPasswordField')), 'LongSecurePass!123');
    await tester.pump();
    await tester.tap(find.byKey(const Key('performSignInButton')));
    await tester.pumpAndSettle();
    expect(fake.loginCalls, 1);
  });
}
