
String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Ange ett giltigt namn';
  }

  return null;
}

