import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';

enum ProductDetailStatus { initial, loading, loaded, failure }

class ProductDetailState extends Equatable {
  final ProductDetailStatus status;
  final Product? product;
  final List<Product> related;
  final Failure? failure;

  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.related = const [],
    this.failure,
  });

  @override
  List<Object?> get props => [status, product, related, failure];
}
