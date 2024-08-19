import 'package:flutter/material.dart';
import 'package:hane/medications/models/medication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationListProvider with ChangeNotifier {
  String? user;
  final String masterUID = "master";
  List<Medication> _medications = [];

  MedicationListProvider({this.user});

  bool get hasExistingUserData => _medications.isNotEmpty;

  List<Medication> get medications => _medications;

  Future<void> refreshList() async {
    await queryMedications(forceFromServer: true);
    notifyListeners();
  }

  Future<void> setUserData(String user) async {
    this.user = user;
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
    
    // Check if the current user already has medications
    var userSnapshot = await userMedicationsCollection.get();
    if (userSnapshot.docs.isNotEmpty) {
      throw Exception("User already has medications. Cannot copy master medications.");
    }

    WriteBatch batch = db.batch();

    try {
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
      throw Exception("Failed to copy master medications to user.");
    }
  }

  Future<List<Medication>> queryMedications({bool isGettingDefaultList = false, bool forceFromServer = true}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> medicationsCollection;
    var source = forceFromServer ? Source.server : Source.cache;

    // Determine the correct medications collection
    medicationsCollection = db.collection("users")
                               .doc(isGettingDefaultList ? masterUID : user)
                               .collection("medications");

    try {
      var snapshot = await medicationsCollection.get(GetOptions(source: source));

      if (snapshot.metadata.isFromCache && forceFromServer) {
        print("Cache data used. Forcing server fetch.");
        snapshot = await medicationsCollection.get(GetOptions(source: Source.server));
      }

      _medications = snapshot.docs
                             .map((doc) => Medication.fromFirestore(doc.data()))
                             .toList();
      return _sortMedications(_medications);
    } catch (e) {
      print("Error querying medications: $e");
      throw Exception("Failed to fetch medications: $e");
    }
  }

  List<Medication> _sortMedications(List<Medication> medications) {
    medications.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
    return medications;
  }
}