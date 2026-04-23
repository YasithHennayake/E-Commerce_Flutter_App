import 'package:flutter/material.dart';

import '../../domain/entities/cart.dart';

class CartSummary extends StatelessWidget {
  final Cart cart;
  final VoidCallback onCheckout;

  const CartSummary({super.key, required this.cart, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 4,
      color: theme.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _row(theme, 'Subtotal', cart.subtotal),
              _row(theme, 'Tax (10%)', cart.tax),
              const Divider(),
              _row(theme, 'Total', cart.total, isTotal: true),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: cart.isEmpty ? null : onCheckout,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Proceed to checkout'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(ThemeData theme, String label, double amount,
      {bool isTotal = false}) {
    final labelStyle = isTotal
        ? theme.textTheme.titleMedium
        : theme.textTheme.bodyMedium;
    final valueStyle = isTotal
        ? theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          )
        : theme.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle),
          Text('\$${amount.toStringAsFixed(2)}', style: valueStyle),
        ],
      ),
    );
  }
}
