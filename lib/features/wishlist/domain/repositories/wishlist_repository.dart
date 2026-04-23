import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/wishlist_item.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<WishlistItem>>> getAll();
  Future<Either<Failure, List<WishlistItem>>> add(WishlistItem item);
  Future<Either<Failure, List<WishlistItem>>> remove(int productId);
}
