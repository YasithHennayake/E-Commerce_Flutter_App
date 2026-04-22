import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/product.dart';
import '../cubit/product_detail_cubit.dart';
import '../cubit/product_detail_state.dart';
import '../widgets/rating_row.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;
  final Product? initialProduct;

  const ProductDetailPage({
    super.key,
    required this.productId,
    this.initialProduct,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductDetailCubit>()..load(productId),
      child: _DetailView(fallback: initialProduct),
    );
  }
}

class _DetailView extends StatelessWidget {
  final Product? fallback;
  const _DetailView({this.fallback});

  void _notifyComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$feature will be wired in a later phase.')),
      );
  }

  void _openImageZoom(BuildContext context, Product product) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _ImageZoomDialog(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        final product = state.product ?? fallback;
        if (product == null) {
          if (state.status == ProductDetailStatus.failure) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text(state.failure?.message ?? 'Error loading product'),
              ),
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final theme = Theme.of(context);
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 320,
                backgroundColor: theme.colorScheme.surface,
                flexibleSpace: FlexibleSpaceBar(
                  background: GestureDetector(
                    onTap: () => _openImageZoom(context, product),
                    child: Hero(
                      tag: 'product-image-${product.id}',
                      child: ColoredBox(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: CachedNetworkImage(
                            imageUrl: product.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          RatingRow(
                            rating: product.rating,
                            iconSize: 20,
                            textStyle: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text(product.category),
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'About',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.description,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  _notifyComingSoon(context, 'Wishlist'),
                              icon: const Icon(Icons.favorite_border),
                              label: const Text('Wishlist'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: FilledButton.icon(
                              onPressed: () =>
                                  _notifyComingSoon(context, 'Add to cart'),
                              icon: const Icon(Icons.shopping_cart_outlined),
                              label: const Text('Add to cart'),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (state.related.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        Text(
                          'Related products',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 200,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.related.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 12),
                            itemBuilder: (_, i) {
                              final r = state.related[i];
                              return _RelatedCard(
                                product: r,
                                onTap: () => context.push(
                                  '/products/${r.id}',
                                  extra: r,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RelatedCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _RelatedCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageZoomDialog extends StatelessWidget {
  final Product product;
  const _ImageZoomDialog({required this.product});

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
