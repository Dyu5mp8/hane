import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:rxdart/rxdart.dart';

class DrugListProvider with ChangeNotifier {
  String? user;
  String masterUID = "master";
  bool? isAdmin;
  Set<dynamic> categories = {};

  DrugListProvider({this.user}) {
    isAdmin = user == null ? null : user == masterUID;
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


Stream<List<Drug>> getDrugsStream() {
  var db = FirebaseFirestore.instance;

  // Stream for the master drug data
  Query<Map<String, dynamic>> drugsCollection =
      db.collection('users').doc(user).collection('drugs');

  Stream<QuerySnapshot<Map<String, dynamic>>> drugsStream = drugsCollection.snapshots();

  // Stream for the user's custom notes
  DocumentReference<Map<String, dynamic>> userNotesDocRef =
      db.collection('users').doc(user).collection('indexes').doc('userNotesIndex');

  Stream<DocumentSnapshot<Map<String, dynamic>>> userNotesStream = userNotesDocRef.snapshots();

  // Combine both streams
  return Rx.combineLatest2(
    drugsStream,
    userNotesStream,
    (drugsSnapshot, userNotesSnapshot) {
      // Check if the data was fetched from the server (billable) or from the cache (non-billable)
      if (!drugsSnapshot.metadata.isFromCache) {
        print(
            'Firestore Read: Snapshot received from server with ${drugsSnapshot.docs.length} documents at ${DateTime.now()}');
      } else {
        print(
            'Firestore Read: Snapshot served from cache with ${drugsSnapshot.docs.length} documents');
      }

      Map<String, dynamic> userNotesIndex = {};

      if (isAdmin != true) {
        // Extract user notes data
        if (userNotesSnapshot.exists) {
          userNotesIndex = userNotesSnapshot.data() ?? {};
        }
      }

      // Convert each document to a Drug object
      var drugsList = drugsSnapshot.docs.map((doc) {
        var drug = Drug.fromFirestore(doc.data());
        categories.addAll(drug.categories ?? []);
        drug.id = doc.id;

        // Set the userNotes from userNotesIndex
        if (userNotesIndex.containsKey(drug.id)) {
          drug.userNotes = userNotesIndex[drug.id] as String;
        }

        return drug;
      }).toList();

      drugsList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

      return drugsList;
    },
  );
}

  Future<void> addDrugToIndex(String id, Timestamp timestamp) async {
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
        // Document exists, update it with the new ID and timestamp as a key-value pair
        await indexDocRef.update({"drugs.$id": timestamp});
      } else {
        // Document does not exist, create it with the first key-value pair
        await indexDocRef.set({
          "drugs": {id: timestamp}
        });
      }
    } catch (e) {
      print("Failed to add drug ID and timestamp to index: $e");
      rethrow;
    }
  }

  Future<void> removeDrugFromIndex(String id) async {
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
        // Document exists, update it by removing the key-value pair for the drug ID
        print(id);
        await indexDocRef.update({
          "drugs.$id": FieldValue
              .delete() // Remove the key-value pair where the key is the drug ID
        });
      } else {
        print("Index document does not exist. No need to remove.");
      }
    } catch (e) {
      print("Failed to remove drug ID from index: $e");
      rethrow;
    }
  }
Future<void> addUserNotes(String id, String notes) async {
  try {
    var db = FirebaseFirestore.instance;
    DocumentReference userNotesDocRef =
        db.collection('users').doc(user).collection('indexes').doc('userNotesIndex');

    // Use 'set' with 'merge: true' to add/update the notes for the drug ID
    await userNotesDocRef.set({
      id: notes
    }, SetOptions(merge: true));
  } catch (e) {
    print("Failed to add user notes: $e");
    rethrow; // Rethrow any errors
  }
}
  Future<void> addDrug(Drug drug) async {
    var db = FirebaseFirestore.instance;
    CollectionReference drugsCollection =
        db.collection('users').doc(user).collection('drugs');

    try {
      // Mark the drug as changed by the user if not an admin and update the timestamp
      drug.changedByUser = !(isAdmin ?? false);
      drug.lastUpdated = Timestamp.now();

      // Check if the drug is new (i.e., it has no ID)
      if (drug.id == null) {
        // Generate a new document reference with an auto-generated ID
        DocumentReference newDocRef = drugsCollection.doc();

        // Save the new drug document to Firestore
        await newDocRef.set(drug.toJson());

        // If the user is an admin, add the new document's ID to the index
        if (isAdmin == true) {
          await addDrugToIndex(newDocRef.id, drug.lastUpdated!);
        }

        else if (drug.userNotes != null) {

          // If the user is not an admin, add the user notes to the user notes index
          await addUserNotes(newDocRef.id, drug.userNotes!);
        }

        return; // Exit early as we are done adding the new drug
      }

      // If the drug already has an ID, check if the document exists in Firestore
      DocumentSnapshot existingDrugSnapshot =
          await drugsCollection.doc(drug.id).get();

      if (existingDrugSnapshot.exists) {
        // If the document exists, convert it to a Drug object
        Drug existingDrug = Drug.fromFirestore(
            existingDrugSnapshot.data() as Map<String, dynamic>);

        // If the existing drug is identical to the one being added, no further action is needed
        if (existingDrug == drug) {
          return; // Exit early as there's no need to update
        }

        // If the existing drug is different, update it by merging the changes
        await drugsCollection
            .doc(drug.id)
            .set(drug.toJson(), SetOptions(merge: true));
      } else {
        // If the document doesn't exist, create it using the provided ID
        await drugsCollection.doc(drug.id).set(drug.toJson());
      }

      // If the user is an admin, update the drug index with the drug's ID
      if (isAdmin == true) {
        await addDrugToIndex(drug.id!, drug.lastUpdated!);
      }
      else if (drug.userNotes != null) {
        // If the user is not an admin, add the user notes to the user notes index
        await addUserNotes(drug.id!, drug.userNotes!);
      }
    } catch (e) {
      print("Failed to add drug: $e");
      rethrow; // Rethrow the error to handle it further up the call stack
    }
  }

  Future<void> deleteDrug(Drug drug) async {
    try {
      var db = FirebaseFirestore.instance;
      CollectionReference drugsCollection =
          db.collection('users').doc(user).collection('drugs');
      if (drug.id != null) {
        await drugsCollection.doc(drug.id).delete();

        if (isAdmin == true) {
          await removeDrugFromIndex(drug.id!);
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
}
