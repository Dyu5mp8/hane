import "package:hane/medications/models/concentration.dart";
import "package:hane/medications/models/medication.dart";
import "package:hane/utils/UnitService.dart";
import "package:hane/utils/validation_exception.dart";


String? validateConcentrationUnit(String? value) {
  if (value == null || value.isEmpty) {
    return ValidationException("Ange en giltig enhet").toString();
  }
  try {Concentration.getConcentrationsUnitsAsMap(value);
  }
  catch (e) {
    return e.toString();
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