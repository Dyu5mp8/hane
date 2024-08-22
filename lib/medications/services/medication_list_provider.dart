import 'package:flutter/material.dart';
import 'package:hane/medications/models/medication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hane/utils/error_alert.dart';

class MedicationListProvider with ChangeNotifier {
  String? user;
  final String masterUID = "master";
  List<Medication> _medications = [];


  MedicationListProvider({this.user});


 bool get isAdmin => user == masterUID;

  bool get hasExistingUserData => _medications.isNotEmpty;

  List<Medication> get medications => _medications;

  Future<void> refreshList() async {
    try {
      await queryMedications(forceFromServer: false);
      notifyListeners();
    } catch (e) {

    }
  }

  setUserData(String user) {
    this.user = user;
  }

  Future<void> addMedication(Medication medication) async {
    var db = FirebaseFirestore.instance;

    CollectionReference medicationsCollection = db.collection('users').doc(user).collection('medications');

    await medicationsCollection.doc(medication.name).set(medication.toJson());
    // Notify listeners that the list has been updated
    print(medication.name); 
   // notifyListeners();
  
  }

  Future<void> deleteMedication(Medication medication) async {
    var db = FirebaseFirestore.instance;
    CollectionReference medicationsCollection = db.collection('users').doc(user).collection('medications');
    if (medication.name != null) {
      await medicationsCollection.doc(medication.name).delete();
      print("Medication deleted successfully!");
    } else {
      print("Medication name is null. Medication not deleted.");
    }
  }

  Future<void> copyMasterToUser() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    print("Copying master medications to user: $user");

    // Reference to the master user's medications collection
    CollectionReference<Map<String, dynamic>> masterMedicationsCollection =
        db.collection("users").doc(masterUID).collection("medications");

    // Reference to the current user's medications collection
    CollectionReference<Map<String, dynamic>> userMedicationsCollection =
        db.collection("users").doc(user).collection("medications");
    
    try {
      // Check if the current user already has medications
      var userSnapshot = await userMedicationsCollection.get();
      if (userSnapshot.docs.isNotEmpty) {
        throw Exception("User already has medications. Cannot copy master medications.");
      }

      WriteBatch batch = db.batch();

      // Fetch all medications from the master user's collection
      QuerySnapshot<Map<String, dynamic>> masterSnapshot = await masterMedicationsCollection.get();

      // Iterate through each document in the master collection and add to the batch
      for (var doc in masterSnapshot.docs) {
        DocumentReference userDocRef = userMedicationsCollection.doc(doc.id);
        batch.set(userDocRef, doc.data());
      }

      // Commit the batch operation
      await batch.commit();

      // Refresh the list after copying
      await refreshList();
    } catch (e) {
      print("Failed to copy master medications to user: $e");
    }
  }

  Future<void> queryMedications({bool isGettingDefaultList = false, bool forceFromServer = true, BuildContext? context}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> medicationsCollection;
    var source = forceFromServer ? Source.server : Source.cache;
    print("Querying medications for user: $user");

    medicationsCollection = db.collection("users")
                               .doc(isGettingDefaultList ? masterUID : user)
                               .collection("medications");

    try {
      var snapshot = await medicationsCollection.get(GetOptions(source: source));
      print(forceFromServer);
      print(source);
      print(snapshot.metadata.isFromCache ? "Cache data used." : "Server data used.");

      if (snapshot.metadata.isFromCache && forceFromServer) {
        print("Cache data used. Forcing server fetch.");
        snapshot = await medicationsCollection.get(GetOptions(source: Source.server));
      }

      _medications = snapshot.docs
                             .map((doc) => Medication.fromFirestore(doc.data()))
                             .toList();
      print("Fetched ${_medications.length} medications");
      _medications = _sortMedications(_medications);
      notifyListeners();
    } catch (e) {
      print("Error querying medications: $e");
      if (context != null) {
        showErrorDialog(context, "Failed to fetch medications: $e");
      }
      throw Exception("Failed to fetch medications: $e");
    }
  }

  List<Medication> _sortMedications(List<Medication> medications) {
    medications.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
    return medications;
  }

  void clearProvider(){
    user = null;
    _medications = [];
    notifyListeners();
  }
}