import 'package:hive/hive.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getAll();
  Future<void> put(CartItemModel item);
  Future<void> delete(int productId);
  Future<void> clear();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final Box<CartItemModel> box;

  CartLocalDataSourceImpl(this.box);

  @override
  Future<List<CartItemModel>> getAll() async {
    try {
      return box.values.toList(growable: false);
    } catch (e) {
      throw CacheException('Failed to read cart: $e');
    }
  }

  @override
  Future<void> put(CartItemModel item) async {
    try {
      await box.put(item.productId, item);
    } catch (e) {
      throw CacheException('Failed to save cart item: $e');
    }
  }

  @override
  Future<void> delete(int productId) async {
    try {
      await box.delete(productId);
    } catch (e) {
      throw CacheException('Failed to delete cart item: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await box.clear();
    } catch (e) {
      throw CacheException('Failed to clear cart: $e');
    }
  }
}
