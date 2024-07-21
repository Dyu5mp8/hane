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
      "d" : "time",
      "IE" : "unitunit",
      "E" : "unitunit",
      "FE" : "unitunit",
      "mmol" : "molar",
      };


  static get validUnits => _validUnits;

static validSubstanceUnits() {
  return Map.fromEntries(
    _validUnits.entries.where((entry) =>(entry.value == "unitunit"|| entry.value == "molar")|| entry.value == "mass")
  );
}

static validTimeUnits() {
  return Map.fromEntries(
    _validUnits.entries.where((entry) => entry.value == "time")
  );
}

static validVolumeUnits() {
  return Map.fromEntries(
    _validUnits.entries.where((entry) => entry.value == "volume")
  );
}

static isSubstanceUnit(String str) {
    return validSubstanceUnits().keys.contains(str);
  }

  static isVolumeUnit(String str) {
    Set<String> units = {"mikrol", "ml", "l"};
    return units.contains(str);
  }

  static isTimeUnit(String str) {
    Set<String> units = {"s", "min", "h", "d"};
    return units.contains(str);
  }

  static isValidUnit(String str) {
    return _validUnits.containsKey(str);
  }

  static isValidUnitType(String str) {
    return _validUnits.containsValue(str);
  }



}
