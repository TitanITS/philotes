class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.emailVerified,
    required this.isActive,
  });

  final String id;
  final String email;
  final bool emailVerified;
  final bool isActive;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String,
        email: json['email'] as String,
        emailVerified: json['email_verified'] as bool? ?? false,
        isActive: json['is_active'] as bool? ?? true,
      );
}
