import "package:flutter/material.dart";
import "package:web_app/models/medication/medication.dart";

class ConcentrationForm {

  List<Concentration> concentrations;
  TextEditingController concentrationAmountController = TextEditingController();
  TextEditingController concentrationUnitController = TextEditingController();

  ConcentrationForm({required this.concentrations});

  void addConcentration() {
      concentrations.add(Concentration(
        amount: double.parse(concentrationAmountController.text),
        unit: concentrationUnitController.text,
      ));
      concentrationAmountController.clear();
      concentrationUnitController.clear();
    }
  

  void removeConcentration(Concentration concentration) {
    concentrations.remove(concentration);

  }

  void saveConcentration(Concentration concentration) {
    
  }
}




