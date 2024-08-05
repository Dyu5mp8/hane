import "package:flutter/widgets.dart";
import "package:hane/medications/models/medication.dart";
import "package:hane/medications/services/firebaseService.dart";

class MedicationForm {
  List<Concentration> concentrations = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController contraindicationController = TextEditingController();
  List<dynamic> brandNames = [];
  TextEditingController notesController = TextEditingController();
  List<Indication>? indications = [];

  Medication? medication;

  MedicationForm({Medication? medication}) {
    if (medication != null) {
      this.medication = medication;
      nameController.text = medication.name ?? "";
      contraindicationController.text = medication.contraindication ?? "";
      concentrations = medication.concentrations ?? [];
      notesController.text = medication.notes ?? "";
      indications = medication.indications ?? [];
      brandNames = medication.brandNames ?? [];
    }

  }


 Medication createMedication() {
    return Medication(
      name: nameController.text,
      contraindication: contraindicationController.text,
      concentrations: concentrations,
      notes: notesController.text,
      indications: indications,
      brandNames: brandNames
    );
  }

  void saveMedication() {
    if (medication == null) {
      medication = createMedication();
    } else {
      medication!.name = nameController.text;
      medication!.contraindication = contraindicationController.text;
      medication!.concentrations = concentrations;
      medication!.notes = notesController.text;
      medication!.indications = indications;
      medication!.brandNames = brandNames;

    }


    medication!.updateMedication();
    FirebaseService.uploadMedication("master", medication!);

  }
}