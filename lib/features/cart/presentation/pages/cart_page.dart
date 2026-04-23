import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            buildWhen: (p, c) => p.cart.isEmpty != c.cart.isEmpty,
            builder: (context, state) {
              if (state.cart.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: 'Clear cart',
                onPressed: () => _confirmClear(context),
              );
            },
          ),
        ],
      ),
      body: BlocListener<CartBloc, CartState>(
        listenWhen: (p, c) =>
            p.failure != c.failure && c.failure != null,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.failure!.message)));
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.cart.isEmpty) {
              return const _EmptyView();
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: state.cart.items.length,
                    itemBuilder: (context, i) {
                      final item = state.cart.items[i];
                      return Slidable(
                        key: ValueKey(item.productId),
                        endActionPane: ActionPane(
                          motion: const BehindMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: () => context.read<CartBloc>().add(
                                  RemoveFromCart(item.productId),
                                ),
                          ),
                          children: [
                            SlidableAction(
                              icon: Icons.delete_outline,
                              label: 'Remove',
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onError,
                              onPressed: (_) =>
                                  context.read<CartBloc>().add(
                                        RemoveFromCart(item.productId),
                                      ),
                            ),
                          ],
                        ),
                        child: CartItemTile(
                          item: item,
                          onQuantityChanged: (q) =>
                              context.read<CartBloc>().add(
                                    UpdateQuantity(
                                      productId: item.productId,
                                      quantity: q,
                                    ),
                                  ),
                        ),
                      );
                    },
                  ),
                ),
                CartSummary(
                  cart: state.cart,
                  onCheckout: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                        content: Text('Checkout lands in Phase 7.'),
                      ));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('This will remove all items from your cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<CartBloc>().add(const ClearCart());
    }
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
            Icons.shopping_cart_outlined,
            size: 96,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text('Your cart is empty', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Add items from the shop to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
