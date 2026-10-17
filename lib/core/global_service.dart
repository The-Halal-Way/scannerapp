import 'package:flutter/foundation.dart';

class GlobalService extends ChangeNotifier {
  GlobalService._();

  static final GlobalService instance = GlobalService._();

  ServerUserData? _currentUser = const ServerUserData(
    id: 'demo-pharmacy-001',
    firebaseId: '',
    username: 'Ayesha Rahman',
    email: 'ayesha@carepoint.demo',
    phone: '+880 1712 345 678',
    pharmacyName: 'CarePoint Pharmacy',
    address: 'House 12, Road 7, Dhanmondi, Dhaka 1205',
    deliveryArea: 'Dhanmondi, Dhaka',
    role: 'Pharmacy owner',
    isEmailVerified: true,
  );
  ServerSessionData? _session;
  ServerAuthData? _auth;
  ServerSubscriptionData? _subscription;
  int _tokenBalance = 0;
  bool _isNewUser = false;
  bool _isGuest = false;

  ServerUserData? get currentUser => _currentUser;
  ServerSessionData? get session => _session;
  ServerAuthData? get auth => _auth;
  ServerSubscriptionData? get subscription => _subscription;
  int get tokenBalance => _tokenBalance;
  bool get isNewUser => _isNewUser;
  bool get isGuest => _isGuest;
  String? get accessToken => _auth?.accessToken;
  String? get refreshToken => _auth?.refreshToken;

  String get username {
    if (_isGuest) return 'Guest';

    final String? value = _currentUser?.username;
    if (value == null || value.trim().isEmpty) {
      return 'Pharmacy partner';
    }
    return value;
  }

  void saveUserData(ServerUserData user) {
    _currentUser = user;
    notifyListeners();
  }

  void saveUserDataFromServer(Map<String, dynamic> json) {
    _currentUser = ServerUserData.fromServer(json);
    notifyListeners();
  }

  void saveSessionFromServer(Map<String, dynamic> json) {
    final userJson = json['user'];
    if (userJson is Map<String, dynamic>) {
      saveUserDataFromServer(userJson);
    }

    final sessionJson = json['session'];
    if (sessionJson is Map<String, dynamic>) {
      _session = ServerSessionData.fromServer(sessionJson);
    }

    final authJson = json['auth'];
    if (authJson is Map<String, dynamic>) {
      _auth = ServerAuthData.fromServer(authJson);
    }

    final subscriptionJson = json['subscription'];
    if (subscriptionJson is Map<String, dynamic>) {
      _subscription = ServerSubscriptionData.fromServer(subscriptionJson);
    }

    _tokenBalance = _safeInt(json['token_balance']);
    _isNewUser = json['is_new_user'] == true;
  }

  void clearUserData() {
    _currentUser = null;
    notifyListeners();
  }

  void clearSession() {
    _session = null;
    _auth = null;
    _subscription = null;
    _tokenBalance = 0;
    _isNewUser = false;
    _isGuest = false;
  }

  void setGuestStatus(bool isGuest) {
    _isGuest = isGuest;
  }

  int _safeInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class ServerUserData {
  const ServerUserData({
    required this.id,
    required this.firebaseId,
    this.email,
    required this.username,
    this.phone,
    this.pharmacyName,
    this.address,
    this.deliveryArea,
    this.role,
    this.isEmailVerified = false,
    this.lastLoginAt,
    this.onboarding = false,
  });

  factory ServerUserData.fromServer(Map<String, dynamic> json) {
    final String username = (json['username'] ?? json['display_name'] ?? '')
        .toString();

    return ServerUserData(
      id: (json['id'] ?? '').toString(),
      firebaseId: (json['firebase_id'] ?? json['firebase_uid'] ?? '')
          .toString(),
      email: json['email']?.toString(),
      username: username,
      phone: json['phone']?.toString(),
      pharmacyName: json['pharmacy_name']?.toString(),
      address: json['address']?.toString(),
      deliveryArea: json['delivery_area']?.toString(),
      role: json['role']?.toString(),
      isEmailVerified: json['is_email_verified'] == true,
      lastLoginAt: json['last_login_at']?.toString(),
      onboarding: json['onboarding'] == null
          ? false
          : json['onboarding'] == true,
    );
  }

  final String id;
  final String firebaseId;
  final String? email;
  final String username;
  final String? phone;
  final String? pharmacyName;
  final String? address;
  final String? deliveryArea;
  final String? role;
  final bool isEmailVerified;
  final String? lastLoginAt;
  final bool onboarding;
}

class ServerSessionData {
  const ServerSessionData({required this.sessionId, this.expiresAt});

  factory ServerSessionData.fromServer(Map<String, dynamic> json) {
    return ServerSessionData(
      sessionId: (json['session_id'] ?? '').toString(),
      expiresAt: json['expires_at']?.toString(),
    );
  }

  final String sessionId;
  final String? expiresAt;
}

class ServerAuthData {
  const ServerAuthData({
    required this.tokenType,
    required this.accessToken,
    this.expiresAt,
    this.refreshToken,
    this.refreshExpiresAt,
  });

  factory ServerAuthData.fromServer(Map<String, dynamic> json) {
    return ServerAuthData(
      tokenType: (json['token_type'] ?? '').toString(),
      accessToken: (json['access_token'] ?? '').toString(),
      expiresAt: json['expires_at']?.toString(),
      refreshToken: json['refresh_token']?.toString(),
      refreshExpiresAt: json['refresh_expires_at']?.toString(),
    );
  }

  final String tokenType;
  final String accessToken;
  final String? expiresAt;
  final String? refreshToken;
  final String? refreshExpiresAt;
}

class ServerSubscriptionData {
  const ServerSubscriptionData({
    this.plan,
    this.status,
    this.currentPeriodEnd,
    this.billingInterval,
  });

  factory ServerSubscriptionData.fromServer(Map<String, dynamic> json) {
    return ServerSubscriptionData(
      plan: json['plan']?.toString(),
      status: json['status']?.toString(),
      currentPeriodEnd: json['current_period_end']?.toString(),
      billingInterval: json['billing_interval']?.toString(),
    );
  }

  final String? plan;
  final String? status;
  final String? currentPeriodEnd;
  final String? billingInterval;
}
