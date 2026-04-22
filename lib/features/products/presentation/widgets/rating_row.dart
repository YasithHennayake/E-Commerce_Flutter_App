import 'package:flutter/material.dart';

import '../../domain/entities/rating.dart';

class RatingRow extends StatelessWidget {
  final Rating rating;
  final double iconSize;
  final TextStyle? textStyle;

  const RatingRow({
    super.key,
    required this.rating,
    this.iconSize = 16,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final style = textStyle ?? Theme.of(context).textTheme.bodySmall;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: Colors.amber, size: iconSize),
        const SizedBox(width: 2),
        Text(rating.rate.toStringAsFixed(1), style: style),
        const SizedBox(width: 4),
        Text('(${rating.count})', style: style),
      ],
    );
  }
}
