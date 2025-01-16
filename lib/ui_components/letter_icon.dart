import 'package:flutter/material.dart';

class LetterIcon extends StatelessWidget {

  final String letter;
  final Color? color;

  const LetterIcon({super.key, required this.letter, this.color}) : assert(letter.length == 1, 'Letter must be a single character');

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    return AspectRatio(
      aspectRatio: 1.0, // Ensures the container is square
      child: Container(
        // Removed padding for more space for the "S"
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(color: effectiveColor, width: 1.0),
          ),
        ),
        child: Center(
          child: FittedBox(
            // FittedBox will scale the text to fill available space
            child: Text(
              letter,
              style: TextStyle(
                color: effectiveColor,
                fontWeight: FontWeight.bold,
                fontSize: 100, // Large base font size for scaling
              ),
            ),
          ),
        ),
      ),
    );
  }
}