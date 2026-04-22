import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';

enum ProductStatus { initial, loading, success, failure }

enum ProductSort { none, priceAsc, priceDesc, ratingDesc }

class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> all;
  final List<String> categories;
  final String? selectedCategory;
  final String searchQuery;
  final ProductSort sort;
  final Failure? failure;

  const ProductState({
    this.status = ProductStatus.initial,
    this.all = const [],
    this.categories = const [],
    this.selectedCategory,
    this.searchQuery = '',
    this.sort = ProductSort.none,
    this.failure,
  });

  List<Product> get visible {
    var list = all;
    if (selectedCategory != null) {
      list = list.where((p) => p.category == selectedCategory).toList();
    }
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      list = list.where((p) => p.title.toLowerCase().contains(q)).toList();
    } else {
      list = List.of(list);
    }
    switch (sort) {
      case ProductSort.priceAsc:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSort.priceDesc:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSort.ratingDesc:
        list.sort((a, b) => b.rating.rate.compareTo(a.rating.rate));
        break;
      case ProductSort.none:
        break;
    }
    return list;
  }

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? all,
    List<String>? categories,
    String? selectedCategory,
    bool clearCategory = false,
    String? searchQuery,
    ProductSort? sort,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ProductState(
      status: status ?? this.status,
      all: all ?? this.all,
      categories: categories ?? this.categories,
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      sort: sort ?? this.sort,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [
        status,
        all,
        categories,
        selectedCategory,
        searchQuery,
        sort,
        failure,
      ];
}
