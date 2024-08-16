import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hane/medications/models/medication.dart';

class MedicationService {
  final String user;

  MedicationService({required this.user});

  Future<List<Medication>> getMedications({bool forceFromServer = true}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var medicationsCollection = db.collection("users").doc(user).collection("medications");
    var source = forceFromServer ? Source.server : Source.cache;

    try {
      var snapshot = await medicationsCollection.get(GetOptions(source: source));

      if (snapshot.metadata.isFromCache && forceFromServer) {
        throw Exception("Kunde inte hämta ny data från servern. Försök igen senare.");
      }

      if (snapshot.docs.isEmpty) {
        print("No data in cache. Fetching from server.");
        snapshot = await medicationsCollection.get(const GetOptions(source: Source.server));
      }

      List<Medication> medications = List.from(snapshot.docs.map((doc) => Medication.fromFirestore(doc.data())));
      return _sortMedications(medications);
    } catch (e) {
      var snapshot = await medicationsCollection.get(const GetOptions(source: Source.server));
      List<Medication> medications = List.from(snapshot.docs.map((doc) => Medication.fromFirestore(doc.data())));
      return _sortMedications(medications);
    }
  }

  List<Medication> _sortMedications(List<Medication> medications) {
    medications.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
    return medications;
  }
}