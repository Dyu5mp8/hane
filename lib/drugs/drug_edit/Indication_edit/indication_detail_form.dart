import "package:flutter/material.dart";
import "package:hane/drugs/models/drug.dart";

class IndicationDetailForm {
  late Indication indication;
  Function(Indication) onSave;
  TextEditingController nameController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  IndicationDetailForm({Indication? indication, required this.onSave}) {
    this.indication =
        indication ?? Indication(name: "", notes: "", isPediatric: false);
    nameController.text = this.indication.name;
    notesController.text = this.indication.notes ?? "";
  }

  void saveIndication() {
    Indication newIndication = Indication(
        name: nameController.text,
        notes: notesController.text,
        isPediatric: indication.isPediatric,
        dosages: indication.dosages);

    onSave(newIndication);
  }

  void addDosage(Dosage dosage) {
    indication.dosages ??= [];

    indication.dosages!.add(dosage);
  }
}
