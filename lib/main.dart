import 'package:flutter/material.dart';
import 'Views/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_theme.dart';



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
      debugShowCheckedModeBanner: false,

      
    
       theme: appTheme,
      home: HomePage(),
      routes: {

    // Add more routes here
  },
    );
  }

}


