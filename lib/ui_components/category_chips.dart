import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CategoryChips extends StatelessWidget {
  final List<dynamic> categories;
  final String? selectedCategory;
  final void Function(String?) onCategorySelected;
  final bool acceptAll;

  const CategoryChips({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.acceptAll = true,
  }) : super(key: key);

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
              label: Text(
                "Alla",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: isWeb ? 14 : 11,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              selected: selectedCategory == null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isWeb ? 12 : 10),
              ),
              onSelected: (_) => onCategorySelected(null),
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            ),
          ...categories.map((dynamic category) {
            return ChoiceChip(
              visualDensity: VisualDensity.compact,
              side: BorderSide.none,
              showCheckmark: false,
              labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              label: Text(
                category,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: isWeb ? 14 : 11,
                    ),
              ),
              selected: selectedCategory == category,
              onSelected: (selected) => {
                if (selected)
                  {onCategorySelected(category)}
                else
                  {
                    if (acceptAll) {onCategorySelected(null)}
                  }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isWeb ? 12 : 10),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            );
          }),
        ],
      ),
    );
  }
}
