import "package:hane/utils/unit_service.dart";
import "package:hane/utils/validation_exception.dart";

class Concentration {
  final double amount;
  final String unit;

Concentration({required this.amount, required this.unit});

 factory Concentration.fromMap(Map<String, dynamic> map) {
    num amount = map['amount'] as num;
    return Concentration(
      amount: amount.toDouble(),
      unit: map['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unit,
    };
  }

  set amount(double newAmount) {
    if (amount != newAmount) {
      amount = newAmount;
    }
  }

  set unit(String newUnit) {
    if (unit != newUnit) {
      unit = newUnit;
    }
  }

  @override
  String toString() {
    return "$amount $unit";
  }

  Map concentrationUnit = {
    "mg" : "mass",
    "g" : "mass",
    "mL" : "volume",
    "L" : "volume",
    "mcg" : "mass",
    "units" : "substance",


  };

  static Map<String, String> getConcentrationsUnitsAsMap(String unitInput) {
    Map validUnits = UnitValidator.validUnits;

    Map<String, String> unitMap = {};

    List<String> parts = unitInput.split('/');
    if (parts.length != 2) {
      throw ValidationException("Måste vara mängd/volym");
    }
    if (!UnitValidator.isSubstanceUnit(parts[0])) {
      throw ValidationException("Felaktig enhet: [${parts[0]}], bör vara ${UnitValidator.validSubstanceUnits().keys.join(", ")}");
    
    } 
    else if (!UnitValidator.isVolumeUnit(parts[1]))
    {
      throw ValidationException("Felaktig enhet: [${parts[1]}], bör vara ${UnitValidator.validVolumeUnits().keys.join(", ")}");
    }
  
    else {
      unitMap["substance"] = parts[0];
    }
    for (final part in parts.sublist(1)) {
      if (validUnits.keys.contains((part))) {
        unitMap[validUnits[part]] = part;
      } else {
        throw ValidationException("$part inte en giltig enhet");
      }
    }
    return unitMap;
  }
}