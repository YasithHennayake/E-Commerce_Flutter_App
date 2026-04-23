import 'package:hive/hive.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/wishlist_item_model.dart';

abstract class WishlistLocalDataSource {
  Future<List<WishlistItemModel>> getAll();
  Future<void> put(WishlistItemModel item);
  Future<void> delete(int productId);
}

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  final Box<WishlistItemModel> box;

  WishlistLocalDataSourceImpl(this.box);

  @override
  Future<List<WishlistItemModel>> getAll() async {
    try {
      return box.values.toList(growable: false);
    } catch (e) {
      throw CacheException('Failed to read wishlist: $e');
    }
  }

  @override
  Future<void> put(WishlistItemModel item) async {
    try {
      await box.put(item.productId, item);
    } catch (e) {
      throw CacheException('Failed to save wishlist item: $e');
    }
  }

  @override
  Future<void> delete(int productId) async {
    try {
      await box.delete(productId);
    } catch (e) {
      throw CacheException('Failed to delete wishlist item: $e');
    }
  }
}
