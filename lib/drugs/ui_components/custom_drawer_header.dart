import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawerHeader extends StatefulWidget {
  const CustomDrawerHeader({super.key});

  @override
  _CustomDrawerHeaderState createState() => _CustomDrawerHeaderState();
}

class _CustomDrawerHeaderState extends State<CustomDrawerHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,  // Remove margin
      padding: EdgeInsets.zero, // Remove padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.7),
                      Colors.purple.withOpacity(0.7),
                    ],
                    begin: Alignment(-0.5 + _controller.value, -0.5 + _controller.value),
                    end: Alignment(1.5 - _controller.value, 1.5 - _controller.value),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.center,

            child: Column(
              children: [
                Text(
                  'AnestesiH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                ),
                if (FirebaseAuth.instance.currentUser != null)
                Text("Inloggad som " + FirebaseAuth.instance.currentUser!.email!, style: TextStyle(color: Colors.white), textAlign: TextAlign.center, ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}