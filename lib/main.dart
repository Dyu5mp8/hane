import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'Views/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Ensure your firebase_options.dart file is properly set up.
  );
  var firestore = FirebaseFirestore.instance;
  firestore.settings = const Settings(persistenceEnabled: true, 
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
   
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Module App',
      
    
       theme: ThemeData(
    useMaterial3: true,

    // Define the default brightness and colors.
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      // ···
      brightness: Brightness.light,
    ),

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
      ),
      // ···
      titleLarge: GoogleFonts.syne(
        fontSize: 30,
      ),
      bodyMedium: GoogleFonts.zenMaruGothic(),
      displaySmall: GoogleFonts.pacifico(),
    ),
  ),
      home: HomePage(),
    );
  }
}


