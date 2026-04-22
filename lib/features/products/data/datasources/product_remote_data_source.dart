import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(int id);
  Future<List<String>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient client;
  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await client.dio.get<List<dynamic>>(ApiConstants.products);
    final data = response.data;
    if (data == null) throw const ServerException('Empty products response.');
    return data
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await client.dio
        .get<Map<String, dynamic>>(ApiConstants.productById(id));
    final data = response.data;
    if (data == null) throw const ServerException('Product not found.');
    return ProductModel.fromJson(data);
  }

  @override
  Future<List<String>> getCategories() async {
    final response =
        await client.dio.get<List<dynamic>>(ApiConstants.categories);
    final data = response.data;
    if (data == null) throw const ServerException('Empty categories response.');
    return data.map((e) => e as String).toList(growable: false);
  }
}
