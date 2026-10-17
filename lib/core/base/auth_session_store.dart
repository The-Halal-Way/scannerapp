import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class AuthSessionStore {
  AuthSessionStore._();

  static final AuthSessionStore instance = AuthSessionStore._();

  static const String _boxName = 'auth_session_box';
  static const String _payloadKey = 'payload';

  Box<String>? _box;
  bool _isInitialized = false;

  Future<Box<String>> get _sessionBox async {
    if (_box != null) return _box!;

    if (!_isInitialized) {
      await Hive.initFlutter();
      _isInitialized = true;
    }

    _box = await Hive.openBox<String>(_boxName);
    return _box!;
  }

  Future<void> saveSession(Map<String, dynamic> payload) async {
    final box = await _sessionBox;
    await box.put(_payloadKey, jsonEncode(payload));
  }

  Future<Map<String, dynamic>?> readSession() async {
    final box = await _sessionBox;
    final payload = box.get(_payloadKey);
    if (payload == null || payload.isEmpty) return null;

    final decoded = jsonDecode(payload);
    if (decoded is! Map<String, dynamic>) return null;
    return decoded;
  }

  Future<void> clearSession() async {
    final box = await _sessionBox;
    await box.delete(_payloadKey);
  }
}
