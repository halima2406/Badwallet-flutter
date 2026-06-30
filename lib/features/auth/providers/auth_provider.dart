import 'package:flutter/foundation.dart';

import '../data/session_service.dart';

class AuthProvider extends ChangeNotifier {
  final SessionService _session;
  AuthProvider(this._session);

  String? _phone;
  String? _pin;
  bool _initializing = true;

  String? get phone => _phone;
  bool get initializing => _initializing;
  bool get isLoggedIn => _phone != null && _phone!.isNotEmpty;
  bool get hasPin => _pin != null && _pin!.isNotEmpty;

  Future<void> loadSession() async {
    _phone = await _session.readPhone();
    _pin = await _session.readPin();
    _initializing = false;
    notifyListeners();
  }

  Future<void> login(String phone) async {
    _phone = phone.trim();
    await _session.savePhone(_phone!);
    notifyListeners();
  }

  Future<void> setPin(String pin) async {
    _pin = pin;
    await _session.savePin(pin);
    notifyListeners();
  }

  bool checkPin(String pin) => _pin == pin;

  Future<void> logout() async {
    _phone = null;
    _pin = null;
    await _session.clear();
    notifyListeners();
  }
}
