import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CategoryChips extends StatelessWidget {
  final List<dynamic> categories;
  final String? selectedCategory;
  final void Function(String?) onCategorySelected;
  final bool acceptAll;
  final TextStyle? style;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.acceptAll = true,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    const isWeb = kIsWeb;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Wrap(
        spacing: isWeb ? 5.0 : 5.0,
        runSpacing: isWeb ? 5.0 : -8,
        alignment: WrapAlignment.start,
        children: [
          if (acceptAll)
            ChoiceChip(
              visualDensity: VisualDensity.compact,
              side: BorderSide.none,
              showCheckmark: false,
              label: const Text("Alla"),
              selected: selectedCategory == null,

              onSelected: (_) => onCategorySelected(null),
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 4.0,
              ),
            ),
          ...categories.map((dynamic category) {
            return ChoiceChip(
              visualDensity: VisualDensity.compact,
              side: BorderSide.none,
              showCheckmark: false,
              labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              label: Text(category),
              selected: selectedCategory == category,
              onSelected:
                  (selected) => {
                    if (selected)
                      {onCategorySelected(category)}
                    else
                      {
                        if (acceptAll) {onCategorySelected(null)},
                      },
                  },

              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 4.0,
              ),
            );
          }),
        ],
      ),
    );
  }
}
