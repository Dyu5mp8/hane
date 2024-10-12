import 'package:flutter/material.dart';
import 'package:hane/login/initializer_widget.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/login/loginPage.dart';
import 'package:hane/startup_errors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<FirebaseApp> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = initializeFirebase();
  }

  Future<FirebaseApp> initializeFirebase() async {
    try {
      final app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      var firestore = FirebaseFirestore.instance;
      firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      return app;
    } catch (e) {
      rethrow; // Propagate the error to be caught in the FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          // Show error widget with retry option
          return MaterialApp(
            home: GenericErrorWidget(
              errorMessage: 'Failed to initialize Firebase: ${snapshot.error}',
              onRetry: () {
                setState(() {
                  _initialization = initializeFirebase();
                });
              },
            ),
          );
        } else {
          // Firebase initialized successfully
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => DrugListProvider(),
              ),
              // Other providers...
            ],
            child: MaterialApp(
              title: 'AnestesiH',
              debugShowCheckedModeBanner: false,
              theme: appTheme,
              home: AuthGate(),
            ),
          );
        }
      },
    );
  }
}
class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in
      return InitializerWidget();
    } else {
      // User is not logged in
      return LoginPage();
    }
  }
}