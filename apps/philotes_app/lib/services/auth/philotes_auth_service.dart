import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../config/philotes_api_config.dart';
import '../../models/auth/auth_session.dart';
import '../../models/auth/auth_user.dart';
import 'auth_service.dart';

class PhilotesAuthService implements AuthService {
  PhilotesAuthService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? PhilotesApiConfig.baseUrl;

  final http.Client _client;
  final String _baseUrl;
  AuthSession? _session;
  AuthUser? _user;

  @override
  AuthSession? get currentSession => _session;
  @override
  AuthUser? get cachedUser => _user;

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');
  Map<String, String> get _json => const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Map<String, String> get _device {
    if (kIsWeb) {
      return const {
        'X-Philotes-Device-Name': 'Web Browser',
        'X-Philotes-Platform': 'Web',
        'X-Philotes-Client': 'Philotes Web',
      };
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return const {
          'X-Philotes-Device-Name': 'Windows PC',
          'X-Philotes-Platform': 'Windows',
          'X-Philotes-Client': 'Philotes Desktop',
        };
      case TargetPlatform.android:
        return const {
          'X-Philotes-Device-Name': 'Android Device',
          'X-Philotes-Platform': 'Android',
          'X-Philotes-Client': 'Philotes Mobile',
        };
      case TargetPlatform.iOS:
        return const {
          'X-Philotes-Device-Name': 'iPhone / iPad',
          'X-Philotes-Platform': 'iOS',
          'X-Philotes-Client': 'Philotes Mobile',
        };
      case TargetPlatform.macOS:
        return const {
          'X-Philotes-Device-Name': 'Mac',
          'X-Philotes-Platform': 'macOS',
          'X-Philotes-Client': 'Philotes Desktop',
        };
      case TargetPlatform.linux:
        return const {
          'X-Philotes-Device-Name': 'Linux PC',
          'X-Philotes-Platform': 'Linux',
          'X-Philotes-Client': 'Philotes Desktop',
        };
      case TargetPlatform.fuchsia:
        return const {
          'X-Philotes-Device-Name': 'Philotes Device',
          'X-Philotes-Platform': 'Other',
          'X-Philotes-Client': 'Philotes',
        };
    }
  }

  Map<String, dynamic> _body(http.Response r) {
    if (r.body.trim().isEmpty) return <String, dynamic>{};
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Never _fail(http.Response r) {
    String message = 'Philotes could not complete that request.';
    try {
      final detail = _body(r)['detail'];
      if (detail is String && detail.isNotEmpty) message = detail;
    } catch (_) {}
    throw AuthApiException(message, statusCode: r.statusCode);
  }

  Map<String, String> _authHeaders() {
    final s = _session;
    if (s == null) throw const AuthApiException('Authentication required.');
    return {..._json, 'Authorization': 'Bearer ${s.accessToken}'};
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) async {
    final r = await _client.post(
      _uri('/auth/register'),
      headers: _json,
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (r.statusCode != 201) _fail(r);
    return AuthUser.fromJson(_body(r));
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final r = await _client.post(
      _uri('/auth/login'),
      headers: {..._json, ..._device},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (r.statusCode != 200) _fail(r);
    _session = AuthSession.fromJson(_body(r));
    _user = await currentUser();
    return _user!;
  }

  Future<void> _refresh() async {
    final s = _session;
    if (s == null) throw const AuthApiException('Authentication required.');
    final r = await _client.post(
      _uri('/auth/refresh'),
      headers: _json,
      body: jsonEncode({'refresh_token': s.refreshToken}),
    );
    if (r.statusCode != 200) {
      _session = null;
      _user = null;
      _fail(r);
    }
    _session = AuthSession.fromJson(_body(r));
  }

  Future<http.Response> _getAuth(String path) async {
    var r = await _client.get(_uri(path), headers: _authHeaders());
    if (r.statusCode == 401 && _session != null) {
      await _refresh();
      r = await _client.get(_uri(path), headers: _authHeaders());
    }
    return r;
  }

  Future<http.Response> _postAuth(String path) async {
    var r = await _client.post(_uri(path), headers: _authHeaders());
    if (r.statusCode == 401 && _session != null) {
      await _refresh();
      r = await _client.post(_uri(path), headers: _authHeaders());
    }
    return r;
  }

  @override
  Future<AuthUser> currentUser() async {
    final r = await _getAuth('/auth/me');
    if (r.statusCode != 200) _fail(r);
    _user = AuthUser.fromJson(_body(r));
    return _user!;
  }

  @override
  Future<void> resendVerification() async {
    final r = await _postAuth('/auth/resend-verification');
    if (r.statusCode != 202) _fail(r);
  }

  @override
  Future<void> forgotPassword(String email) async {
    final r = await _client.post(
      _uri('/auth/forgot-password'),
      headers: _json,
      body: jsonEncode({'email': email}),
    );
    if (r.statusCode != 202) _fail(r);
  }

  @override
  Future<void> logout() async {
    final s = _session;
    try {
      if (s != null) {
        await _client.post(
          _uri('/auth/logout'),
          headers: _json,
          body: jsonEncode({'refresh_token': s.refreshToken}),
        );
      }
    } finally {
      _session = null;
      _user = null;
    }
  }
}
