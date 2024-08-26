import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hane/login/loginPage.dart';
import 'package:hane/login/drug_init_screen.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/drugs/drug_list_view/drug_list_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserStatus {
  hasExistingUserData,
  noExistingUserData,
  isAdmin 
}


class InitializerWidget extends StatelessWidget {
  const InitializerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initializeApp(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading screen while waiting for the future to complete
          return const Center(child: CircularProgressIndicator());
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
      final drugListProvider =
          Provider.of<DrugListProvider>(context, listen: false);
      print("User status: $userStatus");
      if (userStatus == UserStatus.hasExistingUserData) {
        await drugListProvider
            .setUserData(FirebaseAuth.instance.currentUser!.uid);
        await drugListProvider.queryDrugs(
            isGettingDefaultList: false, forceFromServer: true);
        return DrugListView();
      } else if (userStatus == UserStatus.noExistingUserData) {
        return DrugInitScreen(user: user);
      } else if (userStatus == UserStatus.isAdmin) {
        drugListProvider.setUserData("master");       
        drugListProvider.queryDrugs(
            isGettingDefaultList: false, forceFromServer: true);
        return DrugListView();
      } else {
        throw Exception("Unknown user status");
      }
    } else {
      // Return the login page if the user is not logged in
      return LoginPage();
    }
  }

  Future<UserStatus> checkUserStatus(String user) async {
    // First, check if the user has the 'admin' custom claim
    User? firebaseUser = FirebaseAuth.instance.currentUser;


    if (firebaseUser != null) {
      IdTokenResult idTokenResult = await firebaseUser.getIdTokenResult(true);

      if (idTokenResult.claims != null && idTokenResult.claims!['admin'] == true) {
        print("User is admin");
        return UserStatus.isAdmin;
      }
    }

    // If the user is not an admin, check for existing user data in Firestore
    final userRef = FirebaseFirestore.instance.collection('users').doc(user);
    final userDrugRef = userRef.collection('drugs');

    // Check if the drugs subcollection has any documents
    final snapshot = await userDrugRef.limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      return UserStatus.hasExistingUserData;
    } else {
      return UserStatus.noExistingUserData;
    }
  }
}
