import "package:flutter/material.dart";
import "package:hane/drugs/ui_components/custom_chip.dart";



class CustomChipWithRadio extends StatelessWidget {
  final String label;
  final VoidCallback? onDeleted;
  final bool isSelected;
  final ValueChanged<bool?> onSelected;

  const CustomChipWithRadio({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.onDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (isSelected) {
            onSelected(false); // Unselect if already selected
          } else {
            onSelected(true); // Select if not selected
          }
        },
      child: InputChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: 0.8,  // Reduce the size of the Radio button
              child: Radio<bool>(
                value: true,
                groupValue: isSelected,
                onChanged: (value) {
                  onSelected(value); // Handle radio tap to select it
                },
                activeColor: Colors.white, // Customize radio button color
              ),
            ),
            const SizedBox(width: 4), // Space between radio button and label
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        visualDensity: VisualDensity.compact,
        backgroundColor: const Color.fromARGB(255, 96, 41, 11),
        padding: const EdgeInsets.symmetric(horizontal: 4), // Reduce padding
        deleteIcon: const Icon(
          Icons.cancel,
          size: 16,
          color: Colors.white,
        ),
        deleteIconColor: Colors.white,
        onDeleted: onDeleted,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}