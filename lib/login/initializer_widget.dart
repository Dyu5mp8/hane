import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/services/drug_list_wrapper.dart';
import 'package:hane/login/loginPage.dart';
import 'package:hane/login/drug_init_screen.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserStatus {
  hasExistingUserData,
  noExistingUserData,
  isAdmin,
}

class InitializerWidget extends StatelessWidget {
  final bool firstLogin;

  const InitializerWidget({super.key, this.firstLogin = false});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initializeApp(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(color: Colors.white),
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("An error occurred: ${snapshot.error}"),
          );
        } else {
          return snapshot.data!;
        }
      },
    );
  }

  Future<Widget> _initializeApp(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      if (firstLogin) {
        await _firstLoginSetup(userId);
      }

      await _logUserLogin(userId);

      UserStatus userStatus = await _determineUserStatus(user);

      return _getHomeScreen(context, userStatus, userId);
    } else {
      return LoginPage();
    }
  }

  Future<UserStatus> _determineUserStatus(User user) async {
    final idTokenResult = await user.getIdTokenResult(true);
    final isAdmin = idTokenResult.claims?['admin'] == true;

    if (isAdmin) {
      print("User is admin");
      return UserStatus.isAdmin;
    }

    final userDrugRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('drugs');
    final snapshot = await userDrugRef.limit(1).get();

    return snapshot.docs.isNotEmpty
        ? UserStatus.hasExistingUserData
        : UserStatus.noExistingUserData;
  }

  Widget _getHomeScreen(BuildContext context, UserStatus status, String userId) {
    final drugListProvider = Provider.of<DrugListProvider>(context, listen: false);

    switch (status) {
      case UserStatus.isAdmin:
        drugListProvider.setUserData("master");
        return DrugListWrapper();
      case UserStatus.hasExistingUserData:
        drugListProvider.setUserData(userId);
        return DrugListWrapper();
      case UserStatus.noExistingUserData:
        drugListProvider.setUserData(userId);
        return DrugInitScreen(user: userId);
      default:
        throw Exception("Unknown user status");
    }
  }

  Future<void> _logUserLogin(String userId) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    await userRef.set({
      'lastLogin': DateTime.now(),
    }, SetOptions(merge: true));
  }

  Future<void> _firstLoginSetup(String userId) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    await userRef.set({
      'registerTime': DateTime.now(),
    }, SetOptions(merge: true));
  }
}