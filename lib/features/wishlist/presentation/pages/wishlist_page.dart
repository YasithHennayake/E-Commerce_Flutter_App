import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../domain/entities/wishlist_item.dart';
import '../cubit/wishlist_cubit.dart';
import '../cubit/wishlist_state.dart';
import '../widgets/wishlist_item_tile.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  void _moveToCart(BuildContext context, WishlistItem item) {
    context.read<CartBloc>().add(
          AddToCart(
            CartItem(
              productId: item.productId,
              title: item.title,
              price: item.price,
              image: item.image,
              quantity: 1,
            ),
          ),
        );
    context.read<WishlistCubit>().remove(item.productId);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Moved to cart'),
          duration: Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: BlocListener<WishlistCubit, WishlistState>(
        listenWhen: (p, c) =>
            p.failure != c.failure && c.failure != null,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.failure!.message)),
            );
        },
        child: BlocBuilder<WishlistCubit, WishlistState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return const _EmptyView();
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: state.items.length,
              itemBuilder: (context, i) {
                final item = state.items[i];
                return WishlistItemTile(
                  item: item,
                  onTap: () => context.push('/products/${item.productId}'),
                  onRemove: () =>
                      context.read<WishlistCubit>().remove(item.productId),
                  onMoveToCart: () => _moveToCart(context, item),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 96,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text('Your wishlist is empty', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Tap the heart on any product to save it here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
