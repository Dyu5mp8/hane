import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';

class DrugListProvider with ChangeNotifier {
  String? user;
  String masterUID = "master";
  bool? isAdmin;
  List<Drug> drugs = [];

  DrugListProvider({this.user}) {
    isAdmin = user == null ? null : user == masterUID;
  }

   Stream<List<Drug>> getDrugsStream() {
  var db = FirebaseFirestore.instance;

  // Reference the drugs collection for the current user, ordered alphabetically by the 'name' field
  Query<Map<String, dynamic>> drugsCollection = db
      .collection('users')
      .doc(user)
      .collection('drugs')
      .orderBy('name', descending: false); // Apply ordering

  // Return a stream of drugs
  return drugsCollection.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => Drug.fromFirestore(doc.data())).toList();
  });
}
  

  Future<void> addDrug(Drug drug) async {
    var db = FirebaseFirestore.instance;
    CollectionReference drugsCollection = db.collection('users').doc(user).collection('drugs');

    drug.changedByUser = user != masterUID;
    drug.lastUpdated = Timestamp.now();

    await drugsCollection.doc(drug.name).set(drug.toJson());
  }

  Future<void> deleteDrug(Drug drug) async {
    var db = FirebaseFirestore.instance;
    CollectionReference drugsCollection = db.collection('users').doc(user).collection('drugs');
    if (drug.name != null) {
      await drugsCollection.doc(drug.name).delete();
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
    }
  }

  void setUserData(String? user) {
    this.user = user;
    isAdmin = user == null ? null : user == masterUID;
  }

  void clearProvider() {
    
    setUserData(null);
  }
}