import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/wishlist_item.dart';

enum WishlistStatus { initial, loading, success, failure }

class WishlistState extends Equatable {
  final WishlistStatus status;
  final List<WishlistItem> items;
  final Failure? failure;

  const WishlistState({
    this.status = WishlistStatus.initial,
    this.items = const [],
    this.failure,
  });

  bool contains(int productId) => items.any((i) => i.productId == productId);

  WishlistState copyWith({
    WishlistStatus? status,
    List<WishlistItem>? items,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return WishlistState(
      status: status ?? this.status,
      items: items ?? this.items,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [status, items, failure];
}
