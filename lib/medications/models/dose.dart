import 'package:hane/medications/models/medication.dart';
import 'package:hane/medications/models/concentration.dart';
import 'package:hane/utils/unit_service.dart';
import 'package:hane/utils/smart_rounder.dart';
import 'package:hane/utils/validation_exception.dart';

class Dose {
  final double amount;
  final Map<String, String> units;

  Dose({required this.amount, required this.units});

  // Constructor to create a Dose from a string representation
  Dose.fromString({required double amount, required String unit})
      : this.amount = amount,
        units = getDoseUnitsAsMap(unit);

  // Get the unit string representation
  String unitString() {
    return units.values.join('/');
  }

  @override
  String toString() {
    return "${smartRound(amount)} ${unitString()}";
  }

  // Get the dose units as a map
  static Map<String, String> getDoseUnitsAsMap(String unitInput) {
    Map validUnits = UnitValidator.validUnits;

    Map<String, String> unitMap = {};

    List<String> parts = unitInput.split('/');
    if (parts.length > 3) {
      throw ValidationException("Måste vara max 3 enheter (t.ex. mg/kg/h)");
    }
    if (!UnitValidator.isSubstanceUnit(parts[0])) {
      throw ValidationException(" [${parts[0]}], bör vara ${UnitValidator.validSubstanceUnits().keys.join(", ")}");
    } else {
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

  // Factory constructor to create a Dose from a Map
  factory Dose.fromFirestore(Map<String, dynamic> map) {
    num amount = map['amount'] as num;
    return Dose.fromString(
      amount: amount.toDouble(),
      unit: map['unit'] as String,
    );
  }

  // Convert a Dose instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unitString(),
    };
  }

  // Convert the dose by weight, time, concentration, and adjust scale
  Dose convertedBy(
      {double? convertWeight,
      String? convertTime,
      Concentration? convertConcentration,
      bool adjustScale = true}) {
    Map<String, String> fromUnits = Map.from(units);
    double value = amount;

    if (convertWeight != null && fromUnits.containsKey("patientWeight")) {
      var result = _convertedByWeight(value, fromUnits, convertWeight);
      value = result.$1;
      fromUnits = result.$2;
   
    }

    if (convertTime != null && fromUnits.containsKey("time")) {
      var result = _convertedByTime(value, fromUnits, convertTime);
      value = result.$1;
      fromUnits = result.$2;
     
    }

    if (convertConcentration != null) {
      var result =
          _convertedByConcentration(value, fromUnits, convertConcentration);
      value = result.$1;
      fromUnits = result.$2 as Map<String, String>;


      return Dose(amount: value, units: fromUnits);
    }

    if (adjustScale) {
      var result = _scaledDose(value, fromUnits);
      value = result.$1;
      fromUnits = result.$2 as Map<String, String>;

    }

    return Dose(amount: value, units: fromUnits);
  }

  // Convert the dose by weight
  _convertedByWeight(double value, Map fromUnits, double conversionWeight) {
    final newValue = value * conversionWeight;

    fromUnits.remove("patientWeight");
    final newUnits = fromUnits;

    return (newValue, newUnits);
  }

  // Convert the dose by time
  _convertedByTime(double value, Map fromUnits, String toUnit) {
    Map<String, double> validTimeUnits = {"h": 1, "min": 60, "d": 1 / 24};

    if (!validTimeUnits.containsKey(fromUnits["time"]) ||
        !validTimeUnits.containsKey(toUnit)) {
      Exception("$fromUnits is not an valid unit");
    }
    if (validTimeUnits[fromUnits["time"]] == null ||
        validTimeUnits[toUnit] == null) {
      throw Exception("$fromUnits or $toUnit is not a valid unit");
    }

    double factor =
        validTimeUnits[fromUnits["time"]]! / validTimeUnits[toUnit]!;
    var newValue = value * factor;
    var newUnits = fromUnits;
    newUnits["time"] = toUnit;

    return (newValue, newUnits);
  }

  // Convert the dose by concentration
  (double, Map) _convertedByConcentration(
      double value, Map fromUnits, Concentration concentration) {
    final concentrationUnitMap =
        UnitParser.getConcentrationsUnitsAsMap(concentration.unit);
    double substanceConversionFactor = UnitParser.getUnitConversionFactor(
        fromUnit: concentrationUnitMap["substance"],
        toUnit: fromUnits["substance"]);

    var newValue = value / concentration.amount * substanceConversionFactor;

    fromUnits["substance"] = concentrationUnitMap["volume"];
    var newUnits = fromUnits;

    return (newValue, newUnits);
  }

  // Scale the dose
  (double, Map) _scaledDose(double value, Map fromUnits) {
    List<String> units = ["g", "mg", "mikrog"];

    // Check if the substance unit is valid
    if (fromUnits["substance"] == null ||
        !units.contains(fromUnits["substance"])) {
      return (value, fromUnits);
    }

    int currentIndex = units.indexOf(fromUnits["substance"]!);
    int newIndex =
        currentIndex + _conversionStep(value, minimum: 0.5, maximum: 1000);

    // Ensure the new index is within bounds
    if (newIndex < 0) {
      newIndex = 0; // Can't scale below the smallest unit
    } else if (newIndex >= units.length) {
      newIndex = units.length - 1; // Can't scale above the largest unit
    }

    // Adjust the dose value according to the units changing
    double newValue = value;
    if (newIndex > currentIndex) {
      for (int i = currentIndex; i < newIndex; i++) {
        newValue *= 1000; // Scaling down
      }
    } else if (newIndex < currentIndex) {
      for (int i = currentIndex; i > newIndex; i--) {
        newValue /= 1000; // Scaling up
      }
    }

    // Continue scaling down if possible
    while (newValue < 0.1 && newIndex < units.length - 1) {
      newValue *= 1000;
      newIndex++;
    }
    Map<String, String> newUnits = Map.from(fromUnits);

    newUnits["substance"] = units[newIndex];

    // Return the new Dose with adjusted value and unit
    return (newValue, newUnits);
  }

  // Calculate the conversion step for scaling the dose
  int _conversionStep(double amount,
      {double minimum = 0.1, double maximum = 1000}) {
    int count = 0;
    if (amount <= 0) return count;
    var conversionAmount = amount;

    while (conversionAmount < minimum) {
      conversionAmount = conversionAmount * 1000;
      count = count + 1;
    }

    while (conversionAmount > maximum) {
      conversionAmount = conversionAmount / 1000;
      count = count - 1;
    }
    return count;
  }
}
