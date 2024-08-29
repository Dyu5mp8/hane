import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';


class DrugListProvider with ChangeNotifier {
  String? user;
  String masterUID = "master";
  bool? isAdmin;
  Set<dynamic> categories = {};


  DrugListProvider({this.user}) {
    isAdmin = user == null ? null : user == masterUID;
  }

  Stream<List<Drug>> getDrugsStream() {
    var db = FirebaseFirestore.instance;

    Query<Map<String, dynamic>> drugsCollection = db
        .collection('users')
        .doc(user)
        .collection('drugs');

    return drugsCollection.snapshots().map((snapshot) {
      // Check if the data was fetched from the server (billable) or from the cache (non-billable)
      if (!snapshot.metadata.isFromCache) {
        print('Firestore Read: Snapshot received from server with ${snapshot.docs.length} documents at ${DateTime.now()}');
      } else {
        print('Firestore Read: Snapshot served from cache with ${snapshot.docs.length} documents');
      }

      // Convert each document to a Drug object
      var drugsList = snapshot.docs.map((doc) {
        var drug = Drug.fromFirestore(doc.data());
        categories.addAll(drug.categories ?? []);
        return drug;
      }).toList();
       drugsList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

      return drugsList;
    });
  }

  Future<void> addDrug(Drug drug) async {
    try {
      var db = FirebaseFirestore.instance;
      CollectionReference drugsCollection = db.collection('users').doc(user).collection('drugs');

      // Update the metadata before saving
      drug.changedByUser = user != masterUID;
      drug.lastUpdated = Timestamp.now();

      // Use set with merge: true to overwrite if the drug already exists
      await drugsCollection.doc(drug.name).set(drug.toJson(), SetOptions(merge: true));
    } catch (e) {
      print("Failed to add drug: $e");
      rethrow;
    }
  }

  Future<void> deleteDrug(Drug drug) async {
    try {
      var db = FirebaseFirestore.instance;
      CollectionReference drugsCollection = db.collection('users').doc(user).collection('drugs');
      if (drug.name != null) {
        await drugsCollection.doc(drug.name).delete();
      }
    } catch (e) {
      print("Failed to delete drug: $e");
      rethrow;
    }
  }

  Future<void> copyMasterToUser() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    CollectionReference<Map<String, dynamic>> masterDrugsCollection =
        db.collection("users").doc(masterUID).collection("drugs");

    CollectionReference<Map<String, dynamic>> userDrugsCollection =
        db.collection("users").doc(user).collection("drugs");

    try {
      var userSnapshot = await userDrugsCollection.limit(1).get();
      if (userSnapshot.docs.isNotEmpty) {
        throw Exception("User already has drugs. Cannot copy master drugs.");
      }

      WriteBatch batch = db.batch();
      QuerySnapshot<Map<String, dynamic>> masterSnapshot = await masterDrugsCollection.get();

      for (var doc in masterSnapshot.docs) {
        DocumentReference userDocRef = userDrugsCollection.doc(doc.id);
        batch.set(userDocRef, doc.data());
      }

      await batch.commit();
    } catch (e) {
      print("Failed to copy master drugs to user: $e");
      rethrow;
    }
  }

  void setUserData(String? user) {
    this.user = user;
    isAdmin = user == null ? null : user == masterUID;
  }

  void clearProvider() {
    // Clear any user-specific data and resources
    categories.clear();
    setUserData(null);
  }

  @override
  void dispose() {
    clearProvider();
    super.dispose();
  }
}