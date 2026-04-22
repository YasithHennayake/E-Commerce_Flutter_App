import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_product_by_id.dart';
import '../../domain/usecases/get_products.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final GetProductById getProductById;
  final GetProducts getProducts;

  ProductDetailCubit({
    required this.getProductById,
    required this.getProducts,
  }) : super(const ProductDetailState());

  Future<void> load(int productId) async {
    emit(const ProductDetailState(status: ProductDetailStatus.loading));
    final result = await getProductById(productId);
    await result.fold(
      (f) async => emit(
        ProductDetailState(status: ProductDetailStatus.failure, failure: f),
      ),
      (product) async {
        final allResult = await getProducts(const NoParams());
        final related = allResult.fold<List<Product>>(
          (_) => const [],
          (all) => all
              .where((p) => p.category == product.category && p.id != product.id)
              .toList(),
        );
        emit(ProductDetailState(
          status: ProductDetailStatus.loaded,
          product: product,
          related: related,
        ));
      },
    );
  }
}
