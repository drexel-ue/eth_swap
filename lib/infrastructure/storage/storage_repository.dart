import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageRepository {
  Future<bool?> getBool(String key);

  Future<int?> getInt(String key);

  Future<double?> getDouble(String key);

  Future<String?> getString(String key);

  Future<Map<String, dynamic>?> getMap(String key);

  Future<List<String>?> getListString(String key);

  Future<bool> setBool({required String key, required bool value});

  Future<bool> setInt({required String key, required int value});

  Future<bool> setDouble({required String key, required double value});

  Future<bool> setString({required String key, required String value});

  Future<bool> setMap({required String key, required Map<String, dynamic> value});

  Future<bool> setListString(String key, List<String> value);

  Future<bool> removePair(String key);

  Future<bool> removeAll();
}

class StorageRepositoryImpl extends StorageRepository {
  late SharedPreferences? _preferences;

  StorageRepositoryImpl({SharedPreferences? preferences}) : _preferences = preferences;

  Future<SharedPreferences> _instance() async => _preferences ??= await SharedPreferences.getInstance();

  @override
  Future<bool?> getBool(String key) async => (await _instance()).getBool(key);

  @override
  Future<int?> getInt(String key) async => (await _instance()).getInt(key);

  @override
  Future<double?> getDouble(String key) async => (await _instance()).getDouble(key);

  @override
  Future<String?> getString(String key) async => (await _instance()).getString(key);

  @override
  Future<Map<String, dynamic>?> getMap(String key) async {
    final map = (await _instance()).getString(key);

    // ignore: unnecessary_null_comparison
    if (map != null) {
      return jsonDecode(map);
    } else {
      return {};
    }
  }

  @override
  Future<List<String>?> getListString(String key) async => (await _instance()).getStringList(key) ?? <String>[];

  @override
  Future<bool> setBool({required String key, required bool value}) async => (await _instance()).setBool(key, value);

  @override
  Future<bool> setInt({required String key, required int value}) async => (await _instance()).setInt(key, value);

  @override
  Future<bool> setDouble({required String key, required double value}) async => (await _instance()).setDouble(key, value);

  @override
  Future<bool> setString({required String key, required String value}) async => (await _instance()).setString(key, value);

  @override
  Future<bool> setMap({required String key, required Map<String, dynamic> value}) async => (await _instance()).setString(key, jsonEncode(value));

  @override
  Future<bool> setListString(String key, List<String> value) async => (await _instance()).setStringList(key, value);

  @override
  Future<bool> removePair(String key) async => (await _instance()).remove(key);

  @override
  Future<bool> removeAll() async {
    try {
      final keys = (await _instance()).getKeys();
      for (final String key in keys) await removePair(key);
      return true;
    } catch (e) {
      return false;
    }
  }
}
