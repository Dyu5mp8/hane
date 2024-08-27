import 'package:flutter/material.dart';
import 'package:hane/login/initializer_widget.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_theme.dart';
import 'package:provider/provider.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var firestore = FirebaseFirestore.instance;

  firestore.settings = const Settings(persistenceEnabled: true, 
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  
    runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DrugListProvider(),
        ),
        // Other providers...
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      title: 'AnestesiH',
      debugShowCheckedModeBanner: false,
   
       theme: appTheme,
      home: const InitializerWidget(),

    );
  }

}

