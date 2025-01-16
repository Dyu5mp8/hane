import 'package:flutter/material.dart';

class LetterIcon extends StatelessWidget {

  final String letter;

  const LetterIcon({super.key, required this.letter}) : assert(letter.length == 1, 'Letter must be a single character');

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0, // Ensures the container is square
      child: Container(
        // Removed padding for more space for the "S"
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(color: Colors.blue, width: 1.0),
          ),
        ),
        child: Center(
          child: FittedBox(
            // FittedBox will scale the text to fill available space
            child: Text(
              letter,
              style: const TextStyle(
                color: Colors.blue,
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