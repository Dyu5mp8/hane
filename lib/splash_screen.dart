import 'package:flutter/material.dart';
import 'package:hane/login/logo.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    super.initState();
    // You can initiate animations or other logic here if needed.
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        // Replace with your custom design, logo, and animations.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Logo(size: 25),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
