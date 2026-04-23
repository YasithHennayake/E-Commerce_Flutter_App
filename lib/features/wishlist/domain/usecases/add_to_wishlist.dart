import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class AddToWishlist extends UseCase<List<WishlistItem>, WishlistItem> {
  final WishlistRepository repository;
  AddToWishlist(this.repository);

  @override
  Future<Either<Failure, List<WishlistItem>>> call(WishlistItem item) =>
      repository.add(item);
}
