import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageClient {
  SecureStorageClient._();

  static final SecureStorageClient _instance = SecureStorageClient._();

  static SecureStorageClient get instance => _instance;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Get data by key
  Future<String?> getByKey(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      rethrow;
    }
  }

  /// Save data. Only String data can be saved.
  Future<void> saveKey(String key, String data) async {
    try {
      await _secureStorage.write(key: key, value: data);
    } catch (e) {
      rethrow;
    }
  }

  /// Remove data by key
  Future<void> removeKey(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      rethrow;
    }
  }

  /// Remove all data
  Future<void> clear() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      rethrow;
    }
  }

  //create function to check if key exists
  Future<bool> containsKey(String key) async {
    try {
      return await _secureStorage.containsKey(key: key);
    } catch (e) {
      rethrow;
    }
  }
}
