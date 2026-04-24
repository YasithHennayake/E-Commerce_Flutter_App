import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../widgets/order_tile.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: RefreshIndicator(
        onRefresh: () => context.read<OrdersCubit>().load(),
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state.status == OrdersStatus.loading && state.orders.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.orders.isEmpty) {
              return const _EmptyView();
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: state.orders.length,
              itemBuilder: (context, i) => OrderTile(order: state.orders[i]),
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
    return ListView(
      children: [
        const SizedBox(height: 120),
        Icon(
          Icons.receipt_long_outlined,
          size: 96,
          color: theme.colorScheme.outline,
        ),
        const SizedBox(height: 16),
        Center(
          child: Text('No orders yet', style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Your completed orders will appear here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }
}
