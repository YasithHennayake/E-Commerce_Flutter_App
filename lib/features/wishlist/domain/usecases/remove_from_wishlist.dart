import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class RemoveFromWishlist extends UseCase<List<WishlistItem>, int> {
  final WishlistRepository repository;
  RemoveFromWishlist(this.repository);

  @override
  Future<Either<Failure, List<WishlistItem>>> call(int productId) =>
      repository.remove(productId);
}
