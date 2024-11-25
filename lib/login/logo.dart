import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final Color accentColor = const Color.fromARGB(255, 41, 51, 81);
  final double? size;

  const Logo({super.key, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '',
        style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
        children: [
          TextSpan(
            text: 'Anestesi',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  fontSize: size,
                ),
          ),
          TextSpan(
            text: 'H',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 112, 30),
                  fontSize: size,
                ),
          ),
        ],
      ),
    );
  }
}