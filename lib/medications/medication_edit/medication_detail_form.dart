import "package:flutter/widgets.dart";
import "package:hane/medications/models/medication.dart";
import "package:hane/medications/services/firebaseService.dart";

class MedicationForm {
  List<Concentration> concentrations = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController contraindicationController = TextEditingController();

  TextEditingController notesController = TextEditingController();
  List<Indication>? indications = [];
  Function (Medication) onSave;

  MedicationForm({Medication? medication, required this.onSave}) {
    if (medication != null) {
      nameController.text = medication.name ?? "";
      contraindicationController.text = medication.contraindication ?? "";
      concentrations = medication.concentrations ?? [];
      notesController.text = medication.notes ?? "";
      indications = medication.indications;
    }
      else {
      indications = [];
    }
  }

  void setIndications(List<Indication> indications) {
    this.indications = indications;
  }
  
 Medication createMedication() {
    return Medication(
      name: nameController.text,
      contraindication: contraindicationController.text,
      concentrations: concentrations,
      notes: notesController.text,
      indications: indications,
    );
  }

  void saveMedication() {
    
    var medication = createMedication();
  
    FirebaseService.uploadMedication("master", medication);
    onSave(medication);

  }
}