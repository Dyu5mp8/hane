import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hane/login/loginPage.dart';
import 'package:hane/login/medication_initial_screen.dart';
import 'package:provider/provider.dart';
import 'package:hane/medications/services/medication_list_provider.dart';
import 'package:hane/medications/views/medication_list_view/medication_list_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/utils/error_alert.dart';
class InitializerWidget extends StatelessWidget {
  const InitializerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initializeApp(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading screen while waiting for the future to complete
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors accordingly
          return Center(
            child: Text("An error occurred: ${snapshot.error}"),
          );
        } else {
          try {
            // If the future has completed successfully, return the resolved widget
            return snapshot.data!;
          } catch (e) {
            // If an error occurs while trying to build the widget, show an error screen
            return Center(
              child: Text("An error occurred: $e"),
            );
          }
          // Show the resolved widget (either LoginPage or MedicationListView)
        }
      },
    );
  }

  Future<Widget> _initializeApp(BuildContext context) async {
    final isUserLoggedIn = FirebaseAuth.instance.currentUser != null;

    if (isUserLoggedIn) {
      UserStatus userStatus =
          await checkUserStatus(FirebaseAuth.instance.currentUser!.uid);
      String user = FirebaseAuth.instance.currentUser!.uid;
      final medicationListProvider =
            Provider.of<MedicationListProvider>(context, listen: false);

      if (userStatus == UserStatus.hasExistingUserData) {
        
        await medicationListProvider
            .setUserData(FirebaseAuth.instance.currentUser!.uid);
        await medicationListProvider.queryMedications(
            isGettingDefaultList: false, forceFromServer: true);
        return MedicationListView();
      } else if (userStatus == UserStatus.noExistingUserData) {
        return MedicationInitScreen(user: user);
      } else if (userStatus == UserStatus.isAdmin) {
        medicationListProvider.queryMedications(
            isGettingDefaultList: true, forceFromServer: true);
        return MedicationListView();
      }
      else {
        throw Exception("Unknown user status");
      }
    }
     else {
      // Return the login page if the user is not logged in
      return LoginPage();
    }
  
  }

  Future<UserStatus> checkUserStatus(String user) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user);

    // Get the document snapshot for the user
    final userSnapshot = await userRef.get();

    // Directly return the value of the isAdmin field, or false if it's not true or doesn't exist
    if (userSnapshot.data()?['isAdmin'] == true) {
      return UserStatus.isAdmin;
    }

    final userMedicationRef = userRef.collection('medications');

    // Check if the medications subcollection has any documents
    final snapshot = await userMedicationRef.get();

    if (snapshot.docs.isNotEmpty) {
      return UserStatus.hasExistingUserData;
    } else {
      return UserStatus.noExistingUserData;
    }
  }
}
