String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ange ett giltigt namn';
  }

  return null;
}


String validateConcentrationUnit(String? value) {
  return 'Ange en giltig enhet';
}

String validateConcentrationAmount(String? value) {
  return 'Ange en giltig koncentration';
}