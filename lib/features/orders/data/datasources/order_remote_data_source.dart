import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/order_item.dart';

abstract class OrderRemoteDataSource {
  Future<String> submitCart({
    required int userId,
    required List<OrderItem> items,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final DioClient client;
  OrderRemoteDataSourceImpl(this.client);

  @override
  Future<String> submitCart({
    required int userId,
    required List<OrderItem> items,
  }) async {
    final response = await client.dio.post(
      ApiConstants.carts,
      data: {
        'userId': userId,
        'date': DateTime.now().toIso8601String(),
        'products': items
            .map((i) => {'productId': i.productId, 'quantity': i.quantity})
            .toList(),
      },
    );
    final data = response.data;
    if (data is Map && data['id'] != null) {
      return data['id'].toString();
    }
    throw const ServerException('Checkout service did not return an order id.');
  }
}
