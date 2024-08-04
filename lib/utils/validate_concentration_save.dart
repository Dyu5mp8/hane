import "package:hane/utils/UnitService.dart";


String? validateConcentrationUnit(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ange en giltig enhet';
  }
  if (!UnitValidator.isValidConcentrationUnit(value)){
    return 'Ange en giltig enhet';
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