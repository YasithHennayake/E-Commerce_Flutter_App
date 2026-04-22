import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductGridShimmer extends StatelessWidget {
  final int itemCount;
  const ProductGridShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.colorScheme.surfaceContainerHighest;
    final highlight = theme.colorScheme.surface;

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: itemCount,
      itemBuilder: (_, _) => Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(color: base),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 12, color: base),
                    const SizedBox(height: 6),
                    Container(height: 12, width: 120, color: base),
                    const SizedBox(height: 10),
                    Container(height: 14, width: 80, color: base),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
