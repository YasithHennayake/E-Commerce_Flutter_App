import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_token_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> login({
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;
  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<AuthTokenModel> login({
    required String username,
    required String password,
  }) async {
    final response = await client.dio.post(
      ApiConstants.login,
      data: {'username': username, 'password': password},
    );
    final data = response.data;
    if (data is Map<String, dynamic> && data['token'] is String) {
      return AuthTokenModel.fromJson(data);
    }
    throw const ServerException('Invalid login response.');
  }
}
