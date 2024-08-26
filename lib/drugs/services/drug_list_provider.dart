import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hane/utils/error_alert.dart';

class DrugListProvider with ChangeNotifier {
  String? user;
  List<Drug> _drugs = [];
  String masterUID = "master";

  DrugListProvider({this.user});

  bool get hasExistingUserData => _drugs.isNotEmpty;

  List<Drug> get drugs => _drugs;

  Future<void> refreshList() async {
    try {
      await queryDrugs(forceFromServer: false);
      notifyListeners();
    } catch (e) {

    }
  }

  setUserData(String user) {
    this.user = user;
  }

  bool isAdmin() => user == masterUID;

  Future<void> addDrug(Drug drug) async {
    var db = FirebaseFirestore.instance;

    CollectionReference drugsCollection = db.collection('users').doc(user).collection('drugs');

    await drugsCollection.doc(drug.name).set(drug.toJson());
    // Notify listeners that the list has been updated
    print(drug.name); 
   // notifyListeners();
  
  }

  Future<void> deleteDrug(Drug drug) async {
    var db = FirebaseFirestore.instance;
    CollectionReference drugsCollection = db.collection('users').doc(user).collection('drugs');
    if (drug.name != null) {
      await drugsCollection.doc(drug.name).delete();
      print("Drug deleted successfully!");
    } else {
      print("Drug name is null. Drug not deleted.");
    }
  }

  Future<void> copyMasterToUser() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    print("Copying master drugs to user: $user");

    // Reference to the master user's drugs collection
    CollectionReference<Map<String, dynamic>> masterDrugsCollection =
        db.collection("users").doc(masterUID).collection("drugs");

    // Reference to the current user's drugs collection
    CollectionReference<Map<String, dynamic>> userDrugsCollection =
        db.collection("users").doc(user).collection("drugs");
    
    try {
      // Check if the current user already has drugs
      var userSnapshot = await userDrugsCollection.get();
      if (userSnapshot.docs.isNotEmpty) {
        throw Exception("User already has drugs. Cannot copy master drugs.");
      }

      WriteBatch batch = db.batch();

      // Fetch all drugs from the master user's collection
      QuerySnapshot<Map<String, dynamic>> masterSnapshot = await masterDrugsCollection.get();

      // Iterate through each document in the master collection and add to the batch
      for (var doc in masterSnapshot.docs) {
        DocumentReference userDocRef = userDrugsCollection.doc(doc.id);
        batch.set(userDocRef, doc.data());
      }

      // Commit the batch operation
      await batch.commit();

      // Refresh the list after copying
      await refreshList();
    } catch (e) {
      print("Failed to copy master drugs to user: $e");
    }
  }

  Future<void> queryDrugs({bool forceFromServer = true, BuildContext? context}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> drugsCollection;
    var source = forceFromServer ? Source.server : Source.cache;
    print("Querying drugs for user: $user");

    drugsCollection = db.collection("users")
                               .doc(user)
                               .collection("drugs");

    try {
      var snapshot = await drugsCollection.get(GetOptions(source: source));
      print(forceFromServer);
      print(source);
      print(snapshot.metadata.isFromCache ? "Cache data used." : "Server data used.");

      if (snapshot.metadata.isFromCache && forceFromServer) {
        print("Cache data used. Forcing server fetch.");
        snapshot = await drugsCollection.get(GetOptions(source: Source.server));
      }

      _drugs = snapshot.docs
                             .map((doc) => Drug.fromFirestore(doc.data()))
                             .toList();
      print("Fetched ${_drugs.length} drugs");
      _drugs = _sortDrugs(_drugs);
      notifyListeners();
    } catch (e) {
      print("Error querying drugs: $e");
      if (context != null) {
        showErrorDialog(context, "Failed to fetch drugs: $e");
      }
      throw Exception("Failed to fetch drugs: $e");
    }
  }

  List<Drug> _sortDrugs(List<Drug> drugs) {
    drugs.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
    return drugs;
  }

  void clearProvider(){
    user = null;
    _drugs = [];
    notifyListeners();
  }
}