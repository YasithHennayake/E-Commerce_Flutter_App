import 'package:flutter/material.dart';

class CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  String _label(String c) =>
      c.isEmpty ? c : '${c[0].toUpperCase()}${c.substring(1)}';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return ChoiceChip(
              label: const Text('All'),
              selected: selected == null,
              onSelected: (_) => onSelected(null),
            );
          }
          final category = categories[index - 1];
          return ChoiceChip(
            label: Text(_label(category)),
            selected: selected == category,
            onSelected: (_) => onSelected(category),
          );
        },
      ),
    );
  }
}
