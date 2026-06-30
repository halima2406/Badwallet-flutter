import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService {
  static const _kPhoneKey = 'badwallet_phone';
  static const _kPinKey = 'badwallet_pin';

  final FlutterSecureStorage _storage;

  SessionService([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> savePhone(String phone) =>
      _storage.write(key: _kPhoneKey, value: phone);

  Future<String?> readPhone() => _storage.read(key: _kPhoneKey);

  Future<void> savePin(String pin) => _storage.write(key: _kPinKey, value: pin);

  Future<String?> readPin() => _storage.read(key: _kPinKey);

  Future<void> clear() async {
    await _storage.delete(key: _kPhoneKey);
    await _storage.delete(key: _kPinKey);
  }
}
