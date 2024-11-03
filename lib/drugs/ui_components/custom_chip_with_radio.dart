import "package:flutter/material.dart";
import "package:hane/drugs/ui_components/custom_chip.dart";

class CustomChipWithCheckbox extends StatelessWidget {
  final String label;
  final VoidCallback? onDeleted;
  final bool isSelected;
  final ValueChanged<bool?> onSelected;

  const CustomChipWithCheckbox({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.onDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chipTheme = Theme.of(context).chipTheme;
    return GestureDetector(
      onTap: () {
        onSelected(!isSelected); // Toggle selection on tap
      },
      child: InputChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150), // Animation duration
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                    scale: animation, child: child); // Scale animation
              },
              child: Icon(
                  isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                  key: ValueKey<bool>(isSelected), // Key for AnimatedSwitcher
                  size: 16, // Adjust the size as needed
                  color: chipTheme.labelStyle?.color // Customize color
                  ),
            ),
            const SizedBox(width: 4), // Space between checkbox icon and label
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: chipTheme.labelStyle?.color ??
                    Colors.white, // Use theme color
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        labelStyle: chipTheme.labelStyle,
        visualDensity: VisualDensity.compact, // Compact the chip's layout
        backgroundColor: chipTheme.backgroundColor, // Use theme color
        padding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 2), // Reduced padding
        deleteIcon: Icon(
          Icons.cancel,
          size: 16,
          color: chipTheme.labelStyle?.color, // Use theme color
        ),
        deleteIconColor: Colors.white,
        onDeleted: onDeleted,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        materialTapTargetSize:
            MaterialTapTargetSize.shrinkWrap, // Shrink tap target size
      ),
    );
  }
}
