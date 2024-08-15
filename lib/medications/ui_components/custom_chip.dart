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
    return InputChip(
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 12, // Smaller font size
          color: Colors.white, // Text color
        ),
        overflow: TextOverflow.ellipsis, // Handle text overflow
      ),
      backgroundColor: Color.fromARGB(255, 96, 41, 11), // Adjusted background color
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Smaller padding
      deleteIcon: const Icon(
        Icons.cancel,
        size: 16, // Smaller delete icon
        color: Colors.white, // Delete icon color
      ),
      deleteIconColor: Colors.white, // Consistent delete icon color
      onDeleted: onDeleted,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6), // Slightly rounded edges
        side: const BorderSide(
          color: Colors.teal, // Border color matching background
          width: 0.5, // Thin border
        ),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Make the chip smaller
    );
  }
}