import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/drugs/services/user_behaviors/behaviors.dart';

import 'package:flutter/material.dart';

import 'package:hane/login/user_status.dart';

class DrugListProvider with ChangeNotifier {
  String _masterUID = "master";
  String? _user;
  UserMode? _userMode;
  Set<dynamic> categories = {};
  UserBehavior? userBehavior;
  bool _preferGeneric = false;
  bool _isSyncedMode = false;

  DrugListProvider({this.userBehavior}) {
    initializeProvider();
  }

  void initializeProvider() async {
    await getIsSyncedModeFromFirestore();
    await getPreferGenericFromFirestore();

    updateUserBehavior();
  }

  String get masterUID => _masterUID;

  set masterUID(String value) {
    _masterUID = value;
    if (userBehavior != null) {
      userBehavior!.masterUID = value;
    }
  }

  String? get user => _user;
  set user(String? value) {
    _user = value;
  }

  UserMode? get userMode => _userMode;
  set userMode(UserMode? value) {
    _userMode = value;
  }

  bool get preferGeneric => _preferGeneric;
  set preferGeneric(bool value) {
    _preferGeneric = value;
    notifyListeners();
    writePreferGeneric();
  }

  bool get isSyncedMode => _isSyncedMode;
  set isSyncedMode(bool value) {
    _isSyncedMode = value;
    writeIsSyncedMode();
    updateUserBehavior();
  }

  bool get isAdmin => userMode == UserMode.isAdmin;

  void setUserBehavior(UserBehavior userBehavior) {
    this.userBehavior = userBehavior;
    notifyListeners();
  }

  void updateUserBehavior() {
    if (_user == null) {
      return;
    }

    if (isAdmin) {
      setUserBehavior(AdminUserBehavior(masterUID: _masterUID));
    } else if (_isSyncedMode) {
      setUserBehavior(SyncedUserBehavior(user: _user!, masterUID: _masterUID));
    } else {
      setUserBehavior(CustomUserBehavior(user: _user!, masterUID: _masterUID));
    }
  }

  void clearProvider() {
    categories.clear();
    user = null;
    userMode = null;
    userBehavior = null;
  }

  @override
  void dispose() {
    clearProvider();
    super.dispose();
  }

  Stream<List<Drug>> getDrugsStream() {
    categories = userBehavior!.categories;

    return userBehavior!.getDrugsStream(sortByGeneric: preferGeneric);
  }

  Future<void> addUserNotes(String id, String notes) async {
    if (userBehavior is SyncedUserBehavior) {
      await (userBehavior as SyncedUserBehavior).addUserNotes(id, notes);
    } else {
      throw Exception("User notes are not supported for this user mode.");
    }
  }

  Future<void> addDrug(Drug drug) async {
    await userBehavior!.addDrug(drug);
  }

  Future<void> deleteDrug(Drug drug) async {
    await userBehavior!.deleteDrug(drug);
  }

  Future<void> copyMasterToUser() async {
    if (userBehavior is CustomUserBehavior) {
      await (userBehavior as CustomUserBehavior).copyMasterToUser();
    } else {
      throw Exception(
          "Copying master drugs is not supported for this user mode.");
    }
  }

  Future<Set<String>> getDrugNamesFromMaster() async {
    if (userBehavior is CustomUserBehavior) {
      return (userBehavior as CustomUserBehavior).getDrugNamesFromMaster();
    } else {
      throw Exception(
          "Getting drug names from master is not supported for this user mode.");
    }
  }

  Future<void> addDrugsFromMaster(List<String> drugNames) async {
    if (userBehavior is CustomUserBehavior) {
      await (userBehavior as CustomUserBehavior).addDrugsFromMaster(drugNames);
    } else {
      throw Exception(
          "Adding drugs from master is not supported for this user mode.");
    }
  }

  Future<bool> getDataStatus() async {
    if (userBehavior is CustomUserBehavior) {
      return await (userBehavior as CustomUserBehavior).getDataStatus();
    } else {
      throw Exception(
          "Getting data status is not supported for this user mode.");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatStream(String drugId) {
    var db = FirebaseFirestore.instance;

    return db
        .collection('users')
        .doc(masterUID)
        .collection('drugs')
        .doc(drugId)
        .collection('chat')
        .orderBy('timestamp', descending: true) // Fetch newest messages first
        .snapshots();
  }

  Future<void> sendChatMessage(String drugId, String message) async {
    String? currentUserEmail =
        FirebaseAuth.instance.currentUser?.email ?? 'Anonym';

    try {
      var db = FirebaseFirestore.instance;

      // Reference to the drug document in 'users/{masterUID}/drugs/{drugId}'
      DocumentReference drugDocRef =
          db.collection('users').doc(masterUID).collection('drugs').doc(drugId);

      // Create a batch write to perform atomic operations
      WriteBatch batch = db.batch();

      // Create a new document reference for the message
      DocumentReference messageRef = drugDocRef.collection('chat').doc();

      // Prepare the message data
      Map<String, dynamic> messageData = {
        'user': currentUserEmail,
        'message': message,
        'timestamp': Timestamp.now(), // Add a timestamp to the message
      };

      // Add the message to the 'chat' subcollection using the batch
      batch.set(messageRef, messageData);

      // Use batch.set with merge:true to create or update the drug document
      batch.set(
        drugDocRef,
        {
          'lastMessageTimestamp': Timestamp.now(),
        },
        SetOptions(
            merge:
                true), // This will merge with existing data or create the document if it doesn't exist
      );

      // Commit the batch
      await batch.commit();
    } catch (e) {
      // Handle any errors that occur during the batch write
      print("Failed to send message: $e");
      // Optionally, throw the error to handle it further up
      throw e;
    }
  }

  Future<void> getIsSyncedModeFromFirestore() async {
    try {
      var db = FirebaseFirestore.instance;
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await db.collection('users').doc(userId).get();

      if (userDoc.exists) {
        isSyncedMode =
            (userDoc.data() as Map<String, dynamic>?)?['preferSyncedMode'] ??
                false;
      } else {
        isSyncedMode = false;
      }
    } catch (e) {
      print("Failed to get preferSyncedMode: $e");
      rethrow;
    }
  }

  Future<void> writeIsSyncedMode() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(_user).set({
        'preferSyncedMode': _isSyncedMode,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Failed to write preferSyncedMode: $e");
      rethrow;
    }
  }

  // Existing methods for preferGeneric
  Future<void> getPreferGenericFromFirestore() async {
    try {
      var db = FirebaseFirestore.instance;
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await db.collection('users').doc(userId).get();

      if (userDoc.exists) {
        preferGeneric =
            (userDoc.data() as Map<String, dynamic>?)?['preferGeneric'] ?? true;
      } else {
        preferGeneric = true;
      }
    } catch (e) {
      print("Failed to get preferGeneric: $e");
      rethrow;
    }
  }

  Future<void> writePreferGeneric() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(_user).set({
        'preferGeneric': preferGeneric,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Failed to write preferGeneric: $e");
      rethrow;
    }
  }

  void setPreferGeneric(bool value) async {
    preferGeneric = value;
    try {
      await writePreferGeneric();
    } catch (e) {
      print("Failed to set preferGeneric: $e");
      rethrow;
    }
  }

  Future<void> updateLastReadTimestamp(String drugId) async {
    await FirebaseFirestore.instance.collection('users').doc(_user).set({
      'lastReadTimestamps': {
        drugId: Timestamp.now(),
      },
    }, SetOptions(merge: true));
  }

  Future<void> markEveryMessageAsRead(List<Drug> drugs) async {
    try {
      var db = FirebaseFirestore.instance;
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDocRef = db.collection('users').doc(userId);

      Map<String, dynamic> lastReadTimestamps = {};
      Timestamp now = Timestamp.now();

      for (var drug in drugs) {
        if (drug.id != null) {
          lastReadTimestamps[drug.id!] = now;
        }
      }

      // Update the user's lastReadTimestamps field
      await userDocRef.set({
        'lastReadTimestamps': lastReadTimestamps,
      }, SetOptions(merge: true));

      // Optionally, set a flag indicating that lastReadTimestamps have been initialized
      await userDocRef.set({
        'lastReadTimestampsInitialized': true,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Failed to mark every message as read: $e");
      rethrow;
    }
  }
}
