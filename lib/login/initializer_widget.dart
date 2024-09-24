import 'package:flutter/material.dart';
import 'package:hane/drugs/services/drug_list_wrapper.dart';
import 'package:hane/drugs/services/user_behaviors/user_behavior.dart';
import 'package:hane/login/drug_init_screen.dart';
import 'package:hane/login/preference_selection_screen.dart';
import 'package:hane/login/user_status.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InitializerWidget extends StatelessWidget {
  final bool firstLogin;

  const InitializerWidget({Key? key, this.firstLogin = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initializeApp(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: const Center(child: CircularProgressIndicator()),
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
    final user = FirebaseAuth.instance.currentUser!;

    String userId = user.uid;
    UserBehavior? behavior;
    _logUserLogin(userId);

    // 1. Check if user is admin
    final isAdmin = await _checkIfUserIsAdmin(user);
    if (isAdmin) {
      behavior = AdminUserBehavior(masterUID: 'master');
      return _getHomeScreen(context, behavior, userId);
    } else {
      // 2. Check user's preference for synced mode
      final preferSynced = await _preferSyncedMode(userId);

      print("Prefer synced: $preferSynced");

      switch (preferSynced) {
        case null: // No preference set yet
          return PreferenceSelectionScreen(user: userId);

        case true: // User prefers synced mode
          behavior = SyncedUserBehavior(masterUID: 'master', user: userId);
          return _getHomeScreen(context, behavior, userId);

        case false: // User prefers custom mode
          // 3. Set behavior for custom user
          behavior = CustomUserBehavior(masterUID: 'master', user: userId);
          return _getCustomUserHomeScreen(context, behavior, userId);
      }
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

  Future<bool?> _preferSyncedMode(String userId) async {
    final prefs = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc("preferSyncedMode");
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

  

  Widget _getHomeScreen(
      BuildContext context, UserBehavior userBehavior, String userId) {
    final drugListProvider =
        Provider.of<DrugListProvider>(context, listen: false);
    drugListProvider.user = userId;
    drugListProvider.setUserBehavior(userBehavior);
    if (userBehavior is SyncedUserBehavior) {
      drugListProvider.userMode = UserMode.syncedMode;
    } else if (userBehavior is AdminUserBehavior) {
      drugListProvider.userMode = UserMode.isAdmin;
    }
    return const DrugListWrapper();
  }

  Future<Widget> _getCustomUserHomeScreen(
      BuildContext context, UserBehavior behavior, String userId) async {
    final drugListProvider =
        Provider.of<DrugListProvider>(context, listen: false);
    drugListProvider.user = userId;
    drugListProvider.setUserBehavior(behavior);
    drugListProvider.userMode = UserMode.customMode;

    var dataStatus = await drugListProvider.getDataStatus();

    if (dataStatus) {
      return const DrugListWrapper();
    } else {
      return DrugInitScreen(user: userId);
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
