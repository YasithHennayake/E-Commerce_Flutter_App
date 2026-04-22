import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/bloc_transformers.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_products.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final GetCategories getCategories;

  ProductBloc({required this.getProducts, required this.getCategories})
      : super(const ProductState()) {
    on<LoadProducts>(_onLoad);
    on<FilterByCategory>(_onFilter);
    on<SearchProducts>(
      _onSearch,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<SortProducts>(_onSort);
  }

  Future<void> _onLoad(LoadProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading, clearFailure: true));
    final productsResult = await getProducts(const NoParams());
    await productsResult.fold(
      (f) async =>
          emit(state.copyWith(status: ProductStatus.failure, failure: f)),
      (products) async {
        final categoriesResult = await getCategories(const NoParams());
        categoriesResult.fold(
          (f) => emit(state.copyWith(
            status: ProductStatus.success,
            all: products,
            categories: const [],
            failure: f,
          )),
          (categories) => emit(state.copyWith(
            status: ProductStatus.success,
            all: products,
            categories: categories,
            clearFailure: true,
          )),
        );
      },
    );
  }

  void _onFilter(FilterByCategory event, Emitter<ProductState> emit) {
    emit(state.copyWith(
      selectedCategory: event.category,
      clearCategory: event.category == null,
    ));
  }

  void _onSearch(SearchProducts event, Emitter<ProductState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onSort(SortProducts event, Emitter<ProductState> emit) {
    emit(state.copyWith(sort: event.sort));
  }
}
