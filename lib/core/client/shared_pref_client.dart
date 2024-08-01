import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefClient {
  SharedPrefClient._();

  static final SharedPrefClient _instance = SharedPrefClient._();

  static SharedPrefClient get instance => _instance;

  SharedPreferences? sharedPreferences;

  Future<SharedPreferences> get _client async {
    if (sharedPreferences != null) {
      return sharedPreferences!;
    }
    return sharedPreferences = await SharedPreferences.getInstance();
  }

  /// get shared pref by key
  Future<String?> getByKey({required String key}) async {
    try {
      SharedPreferences sharedPref = await _client;
      return sharedPref.getString(key);
    } catch (e) {
      rethrow;
    }
  }

  /// save to shared pref. only string
  Future<void> saveKey({required String key, required String data}) async {
    try {
      SharedPreferences sharedPref = await _client;
      await sharedPref.setString(key, data);
    } catch (e) {
      rethrow;
    }
  }

  /// remove key shared pref
  Future<void> removeKey({required String key}) async {
    try {
      SharedPreferences sharedPref = await _client;
      await sharedPref.remove(key);
    } catch (e) {
      rethrow;
    }
  }

  /// remove all shared pref
  Future<void> clear() async {
    try {
      SharedPreferences sharedPref = await _client;
      await sharedPref.clear();
    } catch (e) {
      rethrow;
    }
  }
}
