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

  DrugListProvider({this.userBehavior});

  String get masterUID => _masterUID;

  set masterUID(String value) {
    _masterUID = value;
    userBehavior!.masterUID = value;
  }

  String? get user => _user;
  set user(String? value) {
    _user = value;
  }

  UserMode? get userMode => _userMode;
  set userMode(UserMode? value) {
    _userMode = value;
  }

  void setUserBehavior(UserBehavior userBehavior) {
    this.userBehavior = userBehavior;
  }

  bool get isAdmin => userMode == UserMode.isAdmin;

  void clearProvider() {
    // Clear any user-specific data and resources
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

    return userBehavior!.getDrugsStream();
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
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? 'Anonym';

    try {
      var db = FirebaseFirestore.instance;

      // Reference to the drug document in 'users/{masterUID}/drugs/{drugId}'
      DocumentReference drugDocRef = db
          .collection('users')
          .doc(masterUID)
          .collection('drugs')
          .doc(drugId);

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
        SetOptions(merge: true), // This will merge with existing data or create the document if it doesn't exist
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


  Future<void> updateLastReadTimestamp(String drugId) async {
  await FirebaseFirestore.instance.collection('users').doc(_user).set({
    'lastReadTimestamps': {
      drugId: Timestamp.now(),
    },
  }, SetOptions(merge: true));
}
}
