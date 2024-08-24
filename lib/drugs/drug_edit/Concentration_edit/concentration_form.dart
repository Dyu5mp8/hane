import "package:flutter/material.dart";
import "package:hane/drugs/models/drug.dart";
import "package:hane/utils/unit_parser.dart";

class ConcentrationForm {

  List<Concentration> concentrations;
  TextEditingController concentrationAmountController = TextEditingController();
  TextEditingController concentrationUnitController = TextEditingController();

  ConcentrationForm({required this.concentrations});

  void addConcentration() {
      concentrations.add(Concentration(
        amount: UnitParser.normalizeDouble(concentrationAmountController.text),
        unit: concentrationUnitController.text,
      ));
      concentrationAmountController.clear();
      concentrationUnitController.clear();
    }
  

  void removeConcentration(Concentration concentration) {
    concentrations.remove(concentration);

  }
}




