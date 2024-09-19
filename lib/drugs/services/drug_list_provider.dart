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

    Query<Map<String, dynamic>> drugsCollection =
        db.collection('users').doc(user).collection('drugs');

    return drugsCollection.snapshots().map((snapshot) {
      // Check if the data was fetched from the server (billable) or from the cache (non-billable)
      if (!snapshot.metadata.isFromCache) {
        print(
            'Firestore Read: Snapshot received from server with ${snapshot.docs.length} documents at ${DateTime.now()}');
      } else {
        print(
            'Firestore Read: Snapshot served from cache with ${snapshot.docs.length} documents');
      }

      // Convert each document to a Drug object
      var drugsList = snapshot.docs.map((doc) {
        var drug = Drug.fromFirestore(doc.data());
        categories.addAll(drug.categories ?? []);
        drug.id = doc.id;
        return drug;
      }).toList();
      drugsList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
   


      return drugsList;
    });
  }

  Future<void> addDrugNameToIndex(String drugName) async {
    try {
      var db = FirebaseFirestore.instance;
      DocumentReference indexDocRef = db
          .collection('users')
          .doc(user)
          .collection('indexes')
          .doc('drugIndex');

      // Check if the document exists
      DocumentSnapshot snapshot = await indexDocRef.get();

      if (snapshot.exists) {
        // Document exists, update it
        await indexDocRef.update({
          "drugs": FieldValue.arrayUnion([drugName])
        });
      } else {
        // Document does not exist, create it
        await indexDocRef.set({
          "drugs": [drugName]
        });
      }
    } catch (e) {
      print("Failed to add drug name to index: $e");
      rethrow;
    }
  }

  Future<void> removeDrugNameFromIndex(String drugName) async {
    try {
      var db = FirebaseFirestore.instance;
      DocumentReference indexDocRef = db
          .collection('users')
          .doc(user)
          .collection('indexes')
          .doc('drugIndex');

      // Check if the document exists
      DocumentSnapshot snapshot = await indexDocRef.get();

      if (snapshot.exists) {
        // Document exists, update it
        await indexDocRef.update({
          "drugs": FieldValue.arrayRemove([drugName])
        });
      } else {
        print("Index document does not exist. No need to remove.");
      }
    } catch (e) {
      print("Failed to remove drug name from index: $e");
      rethrow;
    }
  }

  Future<Set<String>> getDrugNamesFromMaster(
      {String masterUser = 'master'}) async {
    try {
      var db = FirebaseFirestore.instance;
      DocumentSnapshot indexSnapshot = await db
          .collection('users')
          .doc(masterUser)
          .collection('indexes')
          .doc('drugIndex')
          .get();

      if (indexSnapshot.exists) {
        // Document exists, retrieve the drug names
        List<dynamic> drugNames = indexSnapshot.get('drugs');
        return Set<String>.from(drugNames);
      } else {
        // Document does not exist, return an empty list
        return {};
      }
    } catch (e) {
      print("Failed to retrieve drug names: $e");
      rethrow;
    }
  }

  Future<void> addDrugsFromMaster(List<String> drugNames) async {
    CollectionReference masterDrugsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc('master')
        .collection('drugs');

    try {
      // Await the snapshot
      final snapshot =
          await masterDrugsCollection.where('name', whereIn: drugNames).get();

      // Convert the documents into a list of Drug objects
      final List<Drug> drugs = snapshot.docs
          .map((doc) => Drug.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();

      for (var drug in drugs) {
        await addDrug(drug);
      }
    } catch (e) {
      print("Failed to add drugs from master: $e");
      rethrow;
    }
  }
Future<void> addDrug(Drug drug) async {
  var db = FirebaseFirestore.instance;
  CollectionReference drugsCollection = db.collection('users').doc(user).collection('drugs');

  try {
    // Fetch the existing drug from Firestore by name
 
    drug.changedByUser = !(isAdmin ?? false);
    drug.lastUpdated = Timestamp.now();

  if (drug.id == null) {
    await drugsCollection.doc().set(drug.toJson());
    return;
  }
   DocumentSnapshot existingDrugSnapshot = await drugsCollection.doc(drug.id).get();
    if (existingDrugSnapshot.exists) {
      // Convert the existing data to a Drug object
      Drug existingDrug = Drug.fromFirestore(existingDrugSnapshot.data() as Map<String, dynamic>);

      // Check if the existing drug is equal to the one you're trying to add
      if (existingDrug == drug) {
        // Drug is identical, no need to overwrite
        return; 
      }
    


    // Use set with merge: true to overwrite if the drug already exists
    await drugsCollection.doc(drug.id).set(drug.toJson(), SetOptions(merge: true));
    }

    else{
      await drugsCollection.doc(drug.id).set(drug.toJson());
    
    }

    // If the user is an admin, update the drug index
    if (isAdmin == true) {
      await addDrugNameToIndex(drug.name!);
    }

  } catch (e) {
    print("Failed to add drug: $e");
    rethrow;
  }
}
  Future<void> deleteDrug(Drug drug) async {
    try {
      var db = FirebaseFirestore.instance;
      CollectionReference drugsCollection =
          db.collection('users').doc(user).collection('drugs');
      if (drug.name != null) {
        await drugsCollection.doc(drug.name).delete();
        if (isAdmin == true) {
          await removeDrugNameFromIndex(drug.name!);
        }
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
      QuerySnapshot<Map<String, dynamic>> masterSnapshot =
          await masterDrugsCollection.get();

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
