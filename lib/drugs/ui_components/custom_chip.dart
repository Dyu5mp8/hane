import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final VoidCallback? onDeleted;


  const CustomChip({
    Key? key,
    required this.label,
    this.onDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chipTheme = Theme.of(context).chipTheme;
    return InputChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12, // Smaller font size
          color: chipTheme.labelStyle?.color, // Text color
        ),
        overflow: TextOverflow.ellipsis, // Handle text overflow
      ),
      visualDensity: VisualDensity.compact,
      backgroundColor: chipTheme.backgroundColor, // Use theme color
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Smaller padding
      deleteIcon: Icon(
        Icons.cancel,
        size: 16, // Smaller delete icon
        color: chipTheme.labelStyle?.color, // Use theme color
      ),
      deleteIconColor: chipTheme.labelStyle?.color,  // Consistent delete icon color
      onDeleted: onDeleted,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Slightly rounded edges
      
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Make the chip smaller
    );
  }
}