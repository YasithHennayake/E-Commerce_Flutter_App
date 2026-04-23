import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/usecases/add_to_wishlist.dart';
import '../../domain/usecases/get_wishlist.dart';
import '../../domain/usecases/remove_from_wishlist.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final GetWishlist getWishlistUseCase;
  final AddToWishlist addToWishlistUseCase;
  final RemoveFromWishlist removeFromWishlistUseCase;

  WishlistCubit({
    required this.getWishlistUseCase,
    required this.addToWishlistUseCase,
    required this.removeFromWishlistUseCase,
  }) : super(const WishlistState());

  Future<void> load() async {
    emit(state.copyWith(status: WishlistStatus.loading));
    final result = await getWishlistUseCase(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: WishlistStatus.failure, failure: f)),
      (items) => emit(state.copyWith(
        status: WishlistStatus.success,
        items: items,
        clearFailure: true,
      )),
    );
  }

  Future<void> add(WishlistItem item) async {
    final result = await addToWishlistUseCase(item);
    result.fold(
      (f) => emit(state.copyWith(status: WishlistStatus.failure, failure: f)),
      (items) => emit(state.copyWith(
        status: WishlistStatus.success,
        items: items,
        clearFailure: true,
      )),
    );
  }

  Future<void> remove(int productId) async {
    final result = await removeFromWishlistUseCase(productId);
    result.fold(
      (f) => emit(state.copyWith(status: WishlistStatus.failure, failure: f)),
      (items) => emit(state.copyWith(
        status: WishlistStatus.success,
        items: items,
        clearFailure: true,
      )),
    );
  }

  Future<void> toggle(WishlistItem item) {
    if (state.contains(item.productId)) {
      return remove(item.productId);
    }
    return add(item);
  }
}
