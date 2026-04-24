import 'dart:convert';

import 'package:hive/hive.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/order_model.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderModel>> getAll();
  Future<void> put(OrderModel order);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final Box<String> box;

  OrderLocalDataSourceImpl(this.box);

  @override
  Future<List<OrderModel>> getAll() async {
    try {
      final orders = box.values
          .map((raw) =>
              OrderModel.fromJson(jsonDecode(raw) as Map<String, dynamic>))
          .toList();
      orders.sort((a, b) => b.placedAt.compareTo(a.placedAt));
      return orders;
    } catch (e) {
      throw CacheException('Failed to read orders: $e');
    }
  }

  @override
  Future<void> put(OrderModel order) async {
    try {
      await box.put(order.id, jsonEncode(order.toJson()));
    } catch (e) {
      throw CacheException('Failed to save order: $e');
    }
  }
}
