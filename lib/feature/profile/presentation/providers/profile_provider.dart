import 'package:flutter/foundation.dart';
import 'package:scannerapp/core/global_service.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider._() {
    final user = GlobalService.instance.currentUser;
    _name = user?.username ?? 'Jb Jason';
    _pharmacyName = user?.pharmacyName ?? 'CarePoint Pharmacy';
    _email = user?.email ?? 'jb@carepoint.demo';
    _phone = user?.phone ?? '+880 1700 123456';
    _address = user?.address ?? '12 Lake Road, Dhanmondi';
    _deliveryArea = user?.deliveryArea ?? 'Dhaka, Bangladesh';
  }

  static final ProfileProvider instance = ProfileProvider._();

  late String _name;
  late String _pharmacyName;
  late String _email;
  late String _phone;
  late String _address;
  late String _deliveryArea;

  String get name => _name;
  String get pharmacyName => _pharmacyName;
  String get email => _email;
  String get phone => _phone;
  String get address => _address;
  String get deliveryArea => _deliveryArea;

  String get initials {
    final words = _name.trim().split(RegExp(r'\s+'));
    return words
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0])
        .join()
        .toUpperCase();
  }

  void update({
    required String name,
    required String pharmacyName,
    required String email,
    required String phone,
    required String address,
    required String deliveryArea,
  }) {
    _name = name.trim();
    _pharmacyName = pharmacyName.trim();
    _email = email.trim();
    _phone = phone.trim();
    _address = address.trim();
    _deliveryArea = deliveryArea.trim();

    final current = GlobalService.instance.currentUser;
    GlobalService.instance.saveUserData(
      ServerUserData(
        id: current?.id ?? 'demo-buyer',
        firebaseId: current?.firebaseId ?? '',
        username: _name,
        email: _email,
        phone: _phone,
        pharmacyName: _pharmacyName,
        address: _address,
        deliveryArea: _deliveryArea,
        role: current?.role,
        isEmailVerified: current?.isEmailVerified ?? false,
        lastLoginAt: current?.lastLoginAt,
        onboarding: current?.onboarding ?? false,
      ),
    );
    notifyListeners();
  }
}
