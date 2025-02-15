import "package:hane/drugs/models/concentration.dart";
import "package:hane/drugs/models/drug.dart";
import "package:hane/drugs/models/units.dart";

import "package:hane/utils/validation_exception.dart";


String? validateConcentrationUnit(SubstanceUnit? value) {
  if (value == null) {
    print("Ange en giltig substansenhet");
    return "Ange en giltig substansenhet";
  }

  return null;
}

String? validateConcentrationAmount(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ange en giltig koncentration';
  }
    var s = value.replaceAll(',', '.'); // Replace comma with dot

  // Try parsing it as double
  try {
    double.parse(s);
    return null;
  }
  catch (e) {
    return 'Ange en giltig koncentration';
  }
}