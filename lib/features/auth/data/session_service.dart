import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// enregistre le numero sur le telephone (stockage securisé)
class SessionService {
  static const _kPhoneKey = 'badwallet_phone';

  final FlutterSecureStorage _storage;

  SessionService([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> savePhone(String phone) =>
      _storage.write(key: _kPhoneKey, value: phone);

  Future<String?> readPhone() => _storage.read(key: _kPhoneKey);

  Future<void> clear() => _storage.delete(key: _kPhoneKey);
}
