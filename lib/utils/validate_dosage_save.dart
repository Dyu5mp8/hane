import "package:hane/drugs/models/drug.dart";

String? validateTextInput(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ange ett giltigt värde';
  }

  return null;
} 

String? validateAmountInput(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  var s = value.replaceAll(',', '.'); // Replace comma with dot

  // Try parsing it as double
  try {
    double.parse(s);
    return null;
  }
  catch (e) {
    return 'Ange ett giltigt värde';
  }
}

String? validateUnitInput(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  
  try {


  }
  catch (e) {
  
    return 'Felaktig enhet: ${e.toString()}';
  }
  return null;
}

