import 'package:flutter/material.dart';

import '../../domain/entities/address.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/payment_info.dart';

class OrderReview extends StatelessWidget {
  final Address address;
  final PaymentInfo payment;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double total;

  const OrderReview({
    super.key,
    required this.address,
    required this.payment,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section(theme, 'Ship to', Text(
          '${address.fullName}\n${address.formatted}\n${address.phone}',
          style: theme.textTheme.bodyMedium,
        )),
        const SizedBox(height: 16),
        _section(theme, 'Payment', Text(
          payment.label,
          style: theme.textTheme.bodyMedium,
        )),
        const SizedBox(height: 16),
        _section(theme, 'Items', Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items
              .map((i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${i.quantity} x ${i.title}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          '\$${i.lineTotal.toStringAsFixed(2)}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ))
              .toList(),
        )),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              _row(theme, 'Subtotal', subtotal),
              _row(theme, 'Tax (10%)', tax),
              const Divider(),
              _row(theme, 'Total', total, isTotal: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _section(ThemeData theme, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleSmall),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  Widget _row(ThemeData theme, String label, double amount,
      {bool isTotal = false}) {
    final labelStyle =
        isTotal ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium;
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
