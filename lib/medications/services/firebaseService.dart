
import "package:firebase_auth/firebase_auth.dart";
import "package:hane/medications/models/medication.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class FirebaseService {

  static Future<void> uploadMedication(Medication medication) async {
    var user = FirebaseAuth.instance.currentUser!.uid;

    var db = FirebaseFirestore.instance;
    CollectionReference medicationsCollection = db.collection('users').doc(user).collection('medications');
    if (medication.name != null) {
      await medicationsCollection.doc(medication.name).set(medication.toJson());
      print("Medication added successfully!");
    } else {
      print("Medication name is null. Medication not added.");
    }
  }

  static Future<List<Medication>> getMedications(String user, {bool forceFromServer = true}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var medicationsCollection = db.collection("users").doc(user).collection("medications");
    var source = forceFromServer ? Source.server : Source.cache;
    var snapshot = await medicationsCollection.get(GetOptions(source: source));

    if (snapshot.docs.isEmpty && source == Source.cache) {
      snapshot = await medicationsCollection.get(const GetOptions(source: Source.server));
    }

    return snapshot.docs.map((doc) => Medication.fromFirestore(doc.data())).toList();
  }

  static Future<void> deleteMedication(String user, Medication medication) async {
    var db = FirebaseFirestore.instance;
    CollectionReference medicationsCollection = db.collection('users').doc(user).collection('medications');
    if (medication.name != null) {
      await medicationsCollection.doc(medication.name).delete();
      print("Medication deleted successfully!");
    } else {
      print("Medication name is null. Medication not deleted.");
    }
  }
}

