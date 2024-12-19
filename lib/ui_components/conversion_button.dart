import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class ConversionButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;
  final Color activeColor;
  final Color inactiveColor;

  const ConversionButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onPressed,
    this.activeColor = const Color.fromARGB(255, 254, 112, 56),
    this.inactiveColor = const Color.fromARGB(255, 195, 225, 240),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        visualDensity: VisualDensity.compact,
        icon: Text(
          label,
          style: GoogleFonts.comfortaa(
            fontSize: 13,
            color: Colors.black
          ),
        ),
        onPressed: buttonPressed,
      ),
    );
  }

  void buttonPressed() {
    HapticFeedback.selectionClick();

    onPressed();

  }
}