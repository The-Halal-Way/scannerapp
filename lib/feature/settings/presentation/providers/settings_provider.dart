import 'package:flutter/foundation.dart';

class SettingsProvider extends ChangeNotifier {
  bool _orderAlerts = true;
  bool _offerAlerts = false;

  bool get orderAlerts => _orderAlerts;
  bool get offerAlerts => _offerAlerts;

  void setOrderAlerts(bool value) {
    if (_orderAlerts == value) return;
    _orderAlerts = value;
    notifyListeners();
  }

  void setOfferAlerts(bool value) {
    if (_offerAlerts == value) return;
    _offerAlerts = value;
    notifyListeners();
  }
}
