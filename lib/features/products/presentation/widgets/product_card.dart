import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import 'rating_row.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Hero(
                tag: 'product-image-${product.id}',
                child: ColoredBox(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.contain,
                      placeholder: (_, _) => const SizedBox.shrink(),
                      errorWidget: (_, _, _) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RatingRow(rating: product.rating),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
