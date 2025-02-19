import 'package:flutter/material.dart';
import 'package:hane/login/initializer_widget.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hane/login/signup.dart';
import 'package:hane/modules_feature/modules/dialysis/dialysis_view.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_view_model.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:hane/splash_screen.dart';
import 'package:hane/theme_provider.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/startup_errors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
      // Begin Firebase initialization and delay concurrently
      final results = await Future.wait([
        Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
        // Ensures a minimum of 3 seconds
        Future.delayed(Duration(seconds: 1)),
      ]);

      // Extract the FirebaseApp from the results (first item in the list)
      final app = results[0] as FirebaseApp;

      // Configure Firestore settings
      var firestore = FirebaseFirestore.instance;
      firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      return app;
    } catch (e) {
      rethrow; // Propagate errors to be caught by the FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().themeData;
    return FutureBuilder<FirebaseApp>(
      future: _initialization,
      builder: (context, snapshot) {
        Widget homeWidget;

        if (snapshot.connectionState == ConnectionState.waiting) {
          homeWidget = Theme(data: theme, child: const SplashScreenWidget());
        } else if (snapshot.hasError) {
          homeWidget = GenericErrorWidget(
            errorMessage: 'Failed to initialize Firebase: ${snapshot.error}',
            onRetry: () {
              setState(() {
                _initialization = initializeFirebase();
              });
            },
          );
        } else {
          homeWidget = const AuthGate(); // test OnboardingScreen();
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DrugListProvider()),

            ChangeNotifierProvider(create: (_) => NutritionViewModel()),

            ChangeNotifierProvider(create: (_) => DialysisViewModel()),
            // Other providers...
          ],
          child: MaterialApp(
            title: 'AnestesiH',
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: homeWidget,
            builder: (context, child) {
              // Retrieve the current MediaQuery data
              final MediaQueryData data = MediaQuery.of(context);

              // Clamp the text scale factor to be between 0.8 and 1.2
              final scale = data.textScaler.clamp(
                maxScaleFactor: 1.2,
                minScaleFactor: 0.8,
              );

              // Apply the modified MediaQuery data to the app
              return MediaQuery(
                data: data.copyWith(textScaler: scale),
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in
      return const InitializerWidget();
    } else {
      // User is not logged in
      return const SignUpPage();
    }
  }
}
