import 'package:equatable/equatable.dart';

import 'product_state.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => const [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class FilterByCategory extends ProductEvent {
  final String? category;
  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchProducts extends ProductEvent {
  final String query;
  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

class SortProducts extends ProductEvent {
  final ProductSort sort;
  const SortProducts(this.sort);

  @override
  List<Object?> get props => [sort];
}
