import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/services/drug_list_wrapper.dart';
import 'package:hane/login/loginPage.dart';
import 'package:hane/login/drug_init_screen.dart';
import 'package:hane/login/preference_selection_screen.dart';
import 'package:hane/login/user_status.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InitializerWidget extends StatelessWidget {
  final bool firstLogin;

  const InitializerWidget({Key? key, this.firstLogin = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initializeApp(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: const BoxDecoration(color: Colors.white),
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

      // 1. Check if user is admin
      final isAdmin = await _checkIfUserIsAdmin(user);
      if (isAdmin) {
        await _logUserLogin(userId);
        return _getHomeScreen(context, UserMode.isAdmin, userId);
      }

      // 2. Check user's preference for synced mode
      bool? preferSynced = await _preferSyncedMode(userId);

      if (preferSynced == null) {
        // No preference set yet; prompt user to select
        return PreferenceSelectionScreen(user: userId);
      } else if (preferSynced == true) {
        // User prefers synced mode
        await _logUserLogin(userId);
        return _getHomeScreen(context, UserMode.syncedMode, userId);
      } else {
        // User prefers custom mode
        // 3. Check if user has existing data
        UserDataStatus dataStatus = await _determineUserDataStatus(userId);
        await _logUserLogin(userId);
        return _getCustomUserHomeScreen(context, dataStatus, userId);
      }
    } else {
      return const LoginPage();
    }
  }

  Future<bool> _checkIfUserIsAdmin(User user) async {
    try {
      final idTokenResult = await user.getIdTokenResult(true);
      return idTokenResult.claims?['admin'] == true;
    } catch (e) {
      print("Failed to check if user is admin: $e");
      return false;
    }
  }

  Future<UserDataStatus> _determineUserDataStatus(String userId) async {
    try {
      final userDrugRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('drugs');

      final snapshot =
          await userDrugRef.limit(1).get().timeout(const Duration(seconds: 5));

      return snapshot.docs.isNotEmpty
          ? UserDataStatus.hasExistingData
          : UserDataStatus.noExistingData;
    } catch (e) {
      print("Fetching from network failed or timed out, trying from cache: $e");
      return _getUserDataStatusFromCache(userId);
    }
  }

  Future<UserDataStatus> _getUserDataStatusFromCache(String userId) async {
    final userDrugRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('drugs');

    final snapshot =
        await userDrugRef.get(const GetOptions(source: Source.cache));

    return snapshot.docs.isNotEmpty
        ? UserDataStatus.hasExistingData
        : UserDataStatus.noExistingData;
  }

  Future<bool?> _preferSyncedMode(String userId) async {
    final prefs = FirebaseFirestore.instance.collection('users').doc(userId).collection('preferences').doc("preferSyncedMode");
    final snapshot = await prefs.get();
    print("Snapshot: $snapshot");
    print(snapshot.data());
    print(userId);


    if (snapshot.exists) {
      return snapshot.data()?['preferSyncedMode'];
    } else {
      return null;
    }
  }

  Widget _getHomeScreen(BuildContext context, UserMode userMode, String userId) {
    final drugListProvider =
        Provider.of<DrugListProvider>(context, listen: false);

    drugListProvider.setUserData(user: userId, userMode: userMode);

    return const DrugListWrapper();
  }

  Widget _getCustomUserHomeScreen(
      BuildContext context, UserDataStatus dataStatus, String userId) {
    final drugListProvider =
        Provider.of<DrugListProvider>(context, listen: false);

    drugListProvider.setUserData(user: userId, userMode: UserMode.customMode);

    switch (dataStatus) {
      case UserDataStatus.hasExistingData:
        return const DrugListWrapper();

      case UserDataStatus.noExistingData:
        return DrugInitScreen(user: userId);

      default:
        throw Exception("Unknown user data status");
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

  Future<void> _firstLoginSetup(String userId) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      await userRef.set({
        'registerTime': DateTime.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Failed to set up first login: $e");
    }
  }
}