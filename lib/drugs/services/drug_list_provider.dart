import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/drugs/drug_detail/drug_chat/drug_chat.dart';
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
  Map<String, String> _possibleReviewerUIDs = {};
  bool _isReviewer = false;

  Future<void> initializeProvider() async {
    _userMode = await determineUserMode(FirebaseAuth.instance.currentUser!);
    await _checkIfUserIsReviewer(FirebaseAuth.instance.currentUser!);
    await getPreferGenericFromFirestore();
    await _getPossibleReviewerUIDs();
    updateUserBehavior();
  }

  Future<UserMode> determineUserMode(User user) async {
          final idTokenResult = await user.getIdTokenResult();
      if (idTokenResult.claims?['admin'] == true) {
        return UserMode.isAdmin;
      }
      else if (await getIsSyncedModeFromFirestore()) {
        return UserMode.syncedMode;
      } else {
        return UserMode.customMode;
      }

  }




  bool get isReviewer => _isReviewer;

  String get masterUID => _masterUID;

  Map<String, String> get possibleReviewerUIDs => _possibleReviewerUIDs;

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
    updateUserBehavior();

  }

  Future<void> _checkIfUserIsAdmin(User user) async {
    try {
      final idTokenResult = await user.getIdTokenResult();
      if (idTokenResult.claims?['admin'] == true) {
        userMode = UserMode.isAdmin;
      }

      return;
    } catch (e) {
      print("Failed to check if user is admin: $e");
      // Assume not admin when offline
      return;
    }
  }

  Future<void> _checkIfUserIsReviewer(User user) async {
    try {
      final idTokenResult = await user.getIdTokenResult();
      if (idTokenResult.claims?['reviewer'] == true) {
        _isReviewer = true;
      }
      return;
    } catch (e) {
      print("Failed to check if user is reviewer: $e");
      // Assume not reviewer when offline
      return;
    }
  }

  bool get preferGeneric => _preferGeneric;
  set preferGeneric(bool value) {
    _preferGeneric = value;
    writePreferGeneric();
    notifyListeners();
  }

  bool get isSyncedMode => _userMode == UserMode.syncedMode;
  set isSyncedMode(bool value) {
    _isSyncedMode = value;
    updateUserBehavior();
    writeIsSyncedMode();
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

    if (_userMode == UserMode.isAdmin) {
      setUserBehavior(AdminUserBehavior(masterUID: _masterUID));
    } else if (_userMode == UserMode.syncedMode) {
      setUserBehavior(SyncedUserBehavior(user: _user!, masterUID: _masterUID));
    } else if (_userMode == UserMode.customMode) {
      setUserBehavior(CustomUserBehavior(user: _user!, masterUID: _masterUID));
    }
    else {
      throw Exception("User mode not supported.");
    }

    print("User behavior updated: $userBehavior");
  }

  void clearProvider() {
    categories.clear();
    user = null;
    userMode = null;
    userBehavior = null;
    _preferGeneric = false;
    _isSyncedMode = false;
    _possibleReviewerUIDs.clear();
    _isReviewer = false;
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

  Future<bool> checkIfDrugChanged(Drug drug) async {
    var db = FirebaseFirestore.instance;

    // Try to get the document from the cache first
    DocumentSnapshot<Map<String, dynamic>> drugDoc;
    try {
      drugDoc = await db
          .collection('users')
          .doc(masterUID)
          .collection('drugs')
          .doc(drug.id)
          .get(const GetOptions(source: Source.cache));
    } catch (e) {
      // If the document is not in the cache, fetch it from the server
      drugDoc = await db
          .collection('users')
          .doc(masterUID)
          .collection('drugs')
          .doc(drug.id)
          .get(const GetOptions(source: Source.server));
    }

    if (!drugDoc.exists) {
      return true;
    }

    Drug drugToUpdate = Drug.fromFirestore(drugDoc.data()!);
    return drug != drugToUpdate;
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

  Future<void> sendChatMessage(String drugId , ChatMessage chatMessage) async {
    print("Sending chat message: ${chatMessage.message}, ${chatMessage.id}");
    final db = FirebaseFirestore.instance;

    CollectionReference chatCollection = db
        .collection('users')
        .doc(masterUID)
        .collection('drugs')
        .doc(drugId)
        .collection('chat');

    
      // The chatMessage doesn't have an id, create a new document
      DocumentReference docRef = await chatCollection.add(chatMessage.toMap());
      // Set the generated id back to the chatMessage object
      chatMessage.id = docRef.id;
    
  }

  Future<void> markMessageSolvedStatus(String drugId, ChatMessage chatMessage) async {
    final db = FirebaseFirestore.instance;
      CollectionReference chatCollection = db
        .collection('users')
        .doc(masterUID)
        .collection('drugs')
        .doc(drugId)
        .collection('chat');

     if (chatMessage.id != null && chatMessage.id!.isNotEmpty) {
      // The chatMessage has an id
      DocumentReference docRef = chatCollection.doc(chatMessage.id);
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await docRef.get() as DocumentSnapshot<Map<String, dynamic>>;

      if (snapshot.exists) {
        // Document exists, update it
        await docRef.update(chatMessage.toMap());
  
    } else {
     return ;
    }

     }
     else {
      return ;
  }
  }

  Future<bool> getIsSyncedModeFromFirestore() async {
    
      var db = FirebaseFirestore.instance;
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await db.collection('users').doc(userId).get();

      if (userDoc.exists) {
        // Set private variable directly to avoid calling setter
        return
            (userDoc.data() as Map<String, dynamic>?)?['preferSyncedMode'] ??
                false;
      } 
      else {
        return false;
      }
    
  }

  Future<void> addReviewUID(String drugId) async {
    if (!_isReviewer) {
      throw Exception("User is not a reviewer.");
    }
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(masterUID)
          .collection('drugs')
          .doc(drugId)
          .set({
        'reviewerUIDs': FieldValue.arrayUnion([_user]),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Failed to add reviewUID: $e");
      rethrow;
    }
  }

  Future<void> _getPossibleReviewerUIDs() async {
    try {
      var db = FirebaseFirestore.instance;
      DocumentSnapshot masterDoc =
          await db.collection('users').doc(masterUID).get();
      if (masterDoc.exists) {
        Map<String, dynamic>? data = masterDoc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('reviewers')) {
          _possibleReviewerUIDs =
              Map<String, String>.from(data['reviewers'] as Map);
        } else {
          _possibleReviewerUIDs = {};
        }
      } else {
        _possibleReviewerUIDs = {};
      }
    } catch (e) {
      print("Failed to get reviewerUIDs: $e");
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

  Future<void> getPreferGenericFromFirestore() async {
    try {
      var db = FirebaseFirestore.instance;
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await db.collection('users').doc(userId).get();

      if (userDoc.exists) {
        // Set private variable directly to avoid calling setter
        _preferGeneric =
            (userDoc.data() as Map<String, dynamic>?)?['preferGeneric'] ?? true;
      } else {
        _preferGeneric = true;
      }
    } catch (e) {
      print("Failed to get preferGeneric: $e");
      rethrow;
    }
  }

  Future<void> writePreferGeneric() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(_user).set({
        'preferGeneric': _preferGeneric,
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

  Future<void> markEveryDrugAsReviewed(List<Drug> drugs) async {
    try {
      var db = FirebaseFirestore.instance;
      WriteBatch batch = db.batch();
      DocumentReference masterDocRef = db.collection('users').doc(masterUID);

      for (var drug in drugs) {
        if (drug.id != null) {
          DocumentReference drugDocRef =
              masterDocRef.collection('drugs').doc(drug.id);
          batch.set(
              drugDocRef,
              {
                'hasReviewedUIDs': drug.shouldReviewUIDs,
              },
              SetOptions(merge: true));
        }
      }

      await batch.commit();
      print("Successfully marked every drug as reviewed.");
    } catch (e) {
      print("Failed to mark every drug as reviewed: $e");
      rethrow;
    }
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
