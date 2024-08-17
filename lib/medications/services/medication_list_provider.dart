import 'package:flutter/material.dart';
import 'package:hane/medications/models/medication.dart';
import 'package:hane/medications/services/medication_firebase_service.dart';

class MedicationListProvider with ChangeNotifier {
  final String user;
  late MedicationService _medicationService;
  List<Medication> _medications = [];

  MedicationListProvider({required this.user}) {
    _medicationService = MedicationService(user: user);
  }

  List<Medication> get medications => _medications;

  Future<void> fetchMedications({bool forceFromServer = false}) async {
    try {
      List<Medication> fetchedMedications = await _medicationService.getMedications(forceFromServer: forceFromServer);
      _medications = fetchedMedications;

    } catch (e) {
      // Handle error appropriately, maybe through a callback or global handler
      print("Error fetching medications: $e");
    }
  }

    Future<void> refreshList() async {
    await fetchMedications(forceFromServer: true);
    notifyListeners();
  }
}