import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/failure_from_exception.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_local_data_source.dart';
import '../models/wishlist_item_model.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource local;

  WishlistRepositoryImpl(this.local);

  @override
  Future<Either<Failure, List<WishlistItem>>> getAll() async {
    try {
      final items = await local.getAll();
      return Right(items);
    } catch (e) {
      return Left(failureFromException(e));
    }
  }

  @override
  Future<Either<Failure, List<WishlistItem>>> add(WishlistItem item) async {
    try {
      await local.put(WishlistItemModel.fromEntity(item));
      return Right(await local.getAll());
    } catch (e) {
      return Left(failureFromException(e));
    }
  }

  @override
  Future<Either<Failure, List<WishlistItem>>> remove(int productId) async {
    try {
      await local.delete(productId);
      return Right(await local.getAll());
    } catch (e) {
      return Left(failureFromException(e));
    }
  }
}
