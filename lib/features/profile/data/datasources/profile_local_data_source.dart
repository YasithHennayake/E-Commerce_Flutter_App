import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<String?> getLoggedInUsername();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences prefs;
  ProfileLocalDataSourceImpl(this.prefs);

  @override
  Future<UserModel?> getCachedUser() async {
    final raw = prefs.getString(StorageKeys.cachedUser);
    if (raw == null || raw.isEmpty) return null;
    try {
      return UserModel.fromCacheJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      throw CacheException('Cached user is corrupt: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final ok = await prefs.setString(
      StorageKeys.cachedUser,
      jsonEncode(user.toCacheJson()),
    );
    if (!ok) throw const CacheException('Failed to cache user.');
  }

  @override
  Future<String?> getLoggedInUsername() async {
    final value = prefs.getString(StorageKeys.authUsername);
    if (value == null || value.isEmpty) return null;
    return value;
  }
}
