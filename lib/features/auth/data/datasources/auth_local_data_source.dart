import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auth_token_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(AuthTokenModel token);
  Future<AuthTokenModel?> getCachedToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;
  AuthLocalDataSourceImpl(this.prefs);

  @override
  Future<void> cacheToken(AuthTokenModel token) async {
    final ok = await prefs.setString(StorageKeys.authToken, token.token);
    if (!ok) throw const CacheException('Failed to cache auth token.');
  }

  @override
  Future<AuthTokenModel?> getCachedToken() async {
    final value = prefs.getString(StorageKeys.authToken);
    if (value == null || value.isEmpty) return null;
    return AuthTokenModel(token: value);
  }

  @override
  Future<void> clearToken() async {
    await prefs.remove(StorageKeys.authToken);
  }
}
