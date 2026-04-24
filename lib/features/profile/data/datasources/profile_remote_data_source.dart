import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<List<UserModel>> getUsers();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient client;
  ProfileRemoteDataSourceImpl(this.client);

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await client.dio.get<List<dynamic>>(ApiConstants.users);
    final data = response.data;
    if (data == null) throw const ServerException('Empty users response.');
    return data
        .map((e) => UserModel.fromApiJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }
}
