import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class GetWishlist extends UseCase<List<WishlistItem>, NoParams> {
  final WishlistRepository repository;
  GetWishlist(this.repository);

  @override
  Future<Either<Failure, List<WishlistItem>>> call(NoParams params) =>
      repository.getAll();
}
