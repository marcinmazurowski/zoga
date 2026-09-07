import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/app_user.dart';

/// Handles the email + one-time-code login flow and the securely stored session.
///
/// PoC note: there is no backend yet, so the "sent" code is generated and
/// returned locally instead of being emailed. Swap [requestCode] /
/// [verifyCode] for real backend calls (e.g. Firebase Auth + a Firestore
/// "loginCodes" collection) once available.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _storage = FlutterSecureStorage();
  static const _keyEmail = 'user_email';
  static const _keyIsAdmin = 'user_is_admin';

  /// Emails allowed to sign in as admin.
  /// TODO: move to a Firestore "admins" collection.
  static const List<String> _adminEmails = ['admin@zoga.com'];

  String? _pendingEmail;
  String? _pendingCode;

  /// Simulates sending a login code to [email]. Returns the generated code
  /// so the PoC UI can display it (a real backend would email it instead).
  Future<String> requestCode(String email) async {
    final code = (100000 + Random().nextInt(900000)).toString();
    _pendingEmail = email.trim().toLowerCase();
    _pendingCode = code;
    return code;
  }

  /// Verifies the code entered by the user and, if correct, persists the
  /// session to secure storage. Returns the logged-in user, or null if the
  /// code didn't match.
  Future<AppUser?> verifyCode(String email, String code) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (_pendingEmail != normalizedEmail || _pendingCode != code) {
      return null;
    }
    final user = AppUser(
      email: normalizedEmail,
      isAdmin: _adminEmails.contains(normalizedEmail),
    );
    await _storage.write(key: _keyEmail, value: user.email);
    await _storage.write(key: _keyIsAdmin, value: user.isAdmin.toString());
    _pendingEmail = null;
    _pendingCode = null;
    return user;
  }

  Future<AppUser?> getStoredUser() async {
    try {
      final email = await _storage.read(key: _keyEmail);
      if (email == null) return null;
      final isAdmin = await _storage.read(key: _keyIsAdmin) == 'true';
      return AppUser(email: email, isAdmin: isAdmin);
    } catch (_) {
      // No secure storage available (e.g. platform channel missing in tests).
      return null;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: _keyEmail);
    await _storage.delete(key: _keyIsAdmin);
  }
}
