import 'package:flutter/material.dart';
import 'Views/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Module App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}


