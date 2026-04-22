import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../injection_container.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/product_grid_shimmer.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductBloc>()..add(const LoadProducts()),
      child: const _ProductListView(),
    );
  }
}

class _ProductListView extends StatefulWidget {
  const _ProductListView();

  @override
  State<_ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<_ProductListView> {
  final _searchController = TextEditingController();
  bool _searchOpen = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _searchOpen = !_searchOpen;
      if (!_searchOpen) {
        _searchController.clear();
        context.read<ProductBloc>().add(const SearchProducts(''));
      }
    });
  }

  void _onSortSelected(ProductSort sort) {
    context.read<ProductBloc>().add(SortProducts(sort));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchOpen
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                ),
                onChanged: (q) =>
                    context.read<ProductBloc>().add(SearchProducts(q)),
              )
            : const Text('Shop'),
        actions: [
          IconButton(
            icon: Icon(_searchOpen ? Icons.close : Icons.search),
            tooltip: _searchOpen ? 'Close search' : 'Search',
            onPressed: _toggleSearch,
          ),
          PopupMenuButton<ProductSort>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort',
            onSelected: _onSortSelected,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: ProductSort.none,
                child: Text('Default'),
              ),
              PopupMenuItem(
                value: ProductSort.priceAsc,
                child: Text('Price: low to high'),
              ),
              PopupMenuItem(
                value: ProductSort.priceDesc,
                child: Text('Price: high to low'),
              ),
              PopupMenuItem(
                value: ProductSort.ratingDesc,
                child: Text('Rating'),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return Column(
            children: [
              if (state.categories.isNotEmpty)
                CategoryFilterBar(
                  categories: state.categories,
                  selected: state.selectedCategory,
                  onSelected: (c) =>
                      context.read<ProductBloc>().add(FilterByCategory(c)),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProductBloc>().add(const LoadProducts());
                  },
                  child: _buildBody(context, state),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductState state) {
    if (state.status == ProductStatus.loading && state.all.isEmpty) {
      return const ProductGridShimmer();
    }
    if (state.status == ProductStatus.failure && state.all.isEmpty) {
      return _ErrorView(
        message: state.failure?.message ?? 'Something went wrong.',
        onRetry: () =>
            context.read<ProductBloc>().add(const LoadProducts()),
      );
    }
    final products = state.visible;
    if (products.isEmpty) {
      return const _EmptyView();
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) {
        final product = products[i];
        return ProductCard(
          product: product,
          onTap: () => context.push('/products/${product.id}', extra: product),
        );
      },
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 120),
        Icon(
          Icons.inventory_2_outlined,
          size: 72,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'No products match',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 120),
        Icon(
          Icons.wifi_off_rounded,
          size: 72,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(message, style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: 16),
        Center(
          child: FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ),
      ],
    );
  }
}

