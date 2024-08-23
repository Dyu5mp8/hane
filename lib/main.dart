import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hane/login/initializer_widget.dart';
import 'package:hane/login/loginPage.dart';
import 'package:hane/medications/models/medication.dart';
import 'package:hane/medications/services/medication_list_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hane/medications/medication_list_view/medication_list_view.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_theme.dart';
import 'package:provider/provider.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Ensure your firebase_options.dart file is properly set up.
  );
  var firestore = FirebaseFirestore.instance;

  firestore.settings = const Settings(persistenceEnabled: true, 
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  
    runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MedicationListProvider(),
        ),
        // Other providers...
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  bool isUserLoggedIn = FirebaseAuth.instance.currentUser != null;

  
  @override
  Widget build(BuildContext context) {
      Future<Widget> startPage() async{
    if (isUserLoggedIn) {
      MedicationListProvider medicationListProvider = Provider.of<MedicationListProvider>(context, listen: false);
      await medicationListProvider.setUserData(FirebaseAuth.instance.currentUser!.uid);
      await medicationListProvider.queryMedications(isGettingDefaultList: false, forceFromServer: true);
      print(medicationListProvider.medications);
      return MedicationListView();
    } else {
      return LoginPage();
    }
  }
   
    return MaterialApp(
      title: 'Module App',
      debugShowCheckedModeBanner: false,

      
    
       theme: appTheme,
      home: InitializerWidget(),
      routes: {

    // Add more routes here
  },
    );
  }

}

