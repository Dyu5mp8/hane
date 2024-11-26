import 'package:flutter/material.dart';
import 'package:hane/drugs/services/drug_list_wrapper.dart';
import 'package:hane/drugs/services/user_behaviors/user_behavior.dart';
import 'package:hane/login/drug_init_screen.dart';
import 'package:hane/login/login_page.dart';
import 'package:hane/login/preference_selection_screen.dart';
import 'package:hane/login/user_status.dart';
import 'package:hane/startup_errors.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';





class InitializerWidget extends StatelessWidget {
  final bool firstLogin;

  const InitializerWidget({super.key, this.firstLogin = false});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initializeApp(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("An error occurred: ${snapshot.error}"),
            ),
          );
        } else {
          return snapshot.data!;
        }
      },
    );
  }

  Future<Widget> _initializeApp(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not logged in
      return const LoginPage(); // Or appropriate action
    }

    String userId = user.uid;
    _logUserLogin(userId);

    return _getHomeScreen(context, userId);
  }

  Future<Widget> _getHomeScreen(BuildContext context, String userId) async {
    final drugListProvider =
        Provider.of<DrugListProvider>(context, listen: false);
    drugListProvider.user = userId;

 
    try {
      await drugListProvider.initializeProvider();
      await Future.delayed(const Duration(milliseconds: 300));


      if (drugListProvider.userMode == null) {
        return PreferenceSelectionScreen(user: userId);
      }

  
  
      else if (drugListProvider.userMode == UserMode.customMode && await drugListProvider.getDataStatus() == false)        {

          return DrugInitScreen(user: userId);
        }
        else { return const DrugListWrapper();}
       

    } catch (e) {
      return GenericErrorWidget(errorMessage: e.toString(), onRetry: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
      );
    }
  }

  Future<void> _logUserLogin(String userId) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    try {
      await userRef.set({
        'lastLogin': DateTime.now(),
      }, SetOptions(merge: true)).timeout(const Duration(seconds: 5));
    } catch (e) {
      print("Failed to log user login: $e");
    }
  }
}
