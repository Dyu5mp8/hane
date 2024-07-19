class UnitValidator {
  UnitValidator();


  static const Map <String, String>  _validUnits = {
      "g" : "mass",
      "mg" : "mass", 
      "mikrog" : "mass",
      "ng" : "mass",
      "mikrol" : "volume",
      "ml" : "volume",
      "l" : "volume",
      "kg" : "patientWeight",
      "s" : "time",
      "min" : "time",
      "h" : "time",
      "d" : "time"};


  static get validUnits => _validUnits;

  static isPatientWeightUnit(String str) => str == "kg";

  static isMassUnit(String str) {
    Set<String> units = {"g", "mg", "mikrog", "ng"};

    return units.contains(str);
  }

  static isVolumeUnit(String str) {
    Set<String> units = {"mikrol", "ml", "l"};
    return units.contains(str);
  }

  static isTimeUnit(String str) {
    Set<String> units = {"s", "min", "h", "d"};
    return units.contains(str);
  }
}
