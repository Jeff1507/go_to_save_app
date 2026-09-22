import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionStorage {
  const SessionStorage();

  static const _storage = FlutterSecureStorage();
  static const _key = 'session';

  Future<void> save(String sessionId) async {
    await _storage.write(key: _key, value: sessionId);
  }

  Future<String?> get() async {
    return _storage.read(key: _key);
  }

  Future<void> delete() async {
    return _storage.delete(key: _key);
  }
}
