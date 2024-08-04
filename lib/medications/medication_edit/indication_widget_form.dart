import "package:flutter/material.dart";
import "package:hane/medications/models/medication.dart";

class IndicationForm {

  late List<Indication> indications;


  IndicationForm({List<Indication>? indications}) {
    this.indications = indications ?? [];
  }



  void updateIndication(Indication indication) {
    int index = indications.indexWhere((i) => i.name == indication.name);
    if (index != -1) {
      indications[index] = indication; // Update existing indication
    } else {
      indications.add(indication); // Add new indication if not found
    }
  }
  void removeIndication(Indication Indication) {
    indications.remove(Indication);

  }

    





}

