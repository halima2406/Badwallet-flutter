import 'package:flutter/foundation.dart';

import '../data/session_service.dart';

// gere la connexion : garde le numero de l'utilisateur
class AuthProvider extends ChangeNotifier {
  final SessionService _session;
  AuthProvider(this._session);

  String? _phone;
  bool _initializing = true;

  String? get phone => _phone;
  bool get initializing => _initializing;
  bool get isLoggedIn => _phone != null && _phone!.isNotEmpty;

  // au demarrage on regarde si un numero est deja enregistré
  Future<void> loadSession() async {
    _phone = await _session.readPhone();
    _initializing = false;
    notifyListeners();
  }

  // connexion : on enregistre juste le numero
  Future<void> login(String phone) async {
    _phone = phone.trim();
    await _session.savePhone(_phone!);
    notifyListeners();
  }

  Future<void> logout() async {
    _phone = null;
    await _session.clear();
    notifyListeners();
  }
}
