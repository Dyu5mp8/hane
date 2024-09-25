import 'dart:math';
import 'package:flutter/material.dart';
import 'customClipper.dart';

class BezierContainer extends StatelessWidget {
  const BezierContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipPath(
        clipper: ClipPainter(),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.62,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/images/concrete.jpg"), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Gradient overlay for smooth transition
            Container(
              height: MediaQuery.of(context).size.height * 0.62,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.3, 1], // Adjust this to control fade transition
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}