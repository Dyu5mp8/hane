import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hane/login/initializer_widget.dart';
import 'package:hane/login/loginPage.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hane/drugs/drug_list_view/drug_list_view.dart';
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
          create: (_) => DrugListProvider(),
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
      DrugListProvider drugListProvider = Provider.of<DrugListProvider>(context, listen: false);
      await drugListProvider.setUserData(FirebaseAuth.instance.currentUser!.uid);
      await drugListProvider.queryDrugs(isGettingDefaultList: false, forceFromServer: true);
      print(drugListProvider.drugs);
      return DrugListView();
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

