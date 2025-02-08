import "package:equatable/equatable.dart";
import "package:hane/drugs/models/units.dart";
import "package:hane/utils/unit_service.dart";
import "package:hane/utils/validation_exception.dart";

class Concentration with EquatableMixin {
  final double amount;
  final SubstanceUnit substanceUnit;
  final DiluentUnit diluentUnit;
  final String? mixingInstructions;
  final bool? isStockSolution;
  final String? aliasUnit;

  Concentration({
    required this.amount,
    required this.substanceUnit
    this.mixingInstructions,
    this.isStockSolution,
    this.aliasUnit,
  });

  Concentration.fromString({
    required this.amount,
    required String unit,
    this.mixingInstructions,
    this.isStockSolution,
    this.aliasUnit,
  }) : unit = unit.replaceAll("μg", "mikrog");

  factory Concentration.fromMap(Map<String, dynamic> map) {
    num amount = map['amount'] as num;
    return Concentration(
      amount: amount.toDouble(),
      unit: map['unit'] as String,
      mixingInstructions: map['mixingInstructions'] as String?,
      isStockSolution: map['isStockSolution'] as bool?,
      aliasUnit: map['aliasUnit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unit,
      'mixingInstructions': mixingInstructions,
      'isStockSolution': isStockSolution,
      'aliasUnit': aliasUnit,
    };
  }

  @override
  List<Object?> get props => [amount, unit, mixingInstructions, isStockSolution, aliasUnit];

  set amount(double newAmount) {
    if (amount != newAmount) {
      amount = newAmount;
    }
  }

  String firstUnit() {
    return unit.split('/')[0];
  }

  String normalizeFirstdUnit() {
    return unit.replaceAll("mikrog", "μg").split('/')[0];
  }

  set unit(String newUnit) {
    if (unit != newUnit) {
      unit = newUnit;
    }
  }

  @override
  String toString() {
    if (aliasUnit != null && aliasUnit!.isNotEmpty) {
    
      return "$aliasUnit";
    }
    var visuallyModifiedUnit = unit.replaceAll("mikrog", "μg");
    return "$amount $visuallyModifiedUnit";
  }

  String getPrimaryRepresentation() {
    return "$amount ${unit.replaceAll("mikrog", "μg")}";
  }

  String? getSecondaryRepresentation() {
    if (aliasUnit == null || aliasUnit!.isEmpty) {
      return null;
    }
    return "$aliasUnit";
  }


  final Map concentrationUnit = {
    "mg": "mass",
    "g": "mass",
    "mL": "volume",
    "L": "volume",
    "mikrog": "mass",
    "ng": "mass",

  };

  static Map<String, String> getConcentrationsUnitsAsMap(String unitInput) {
    Map validUnits = UnitValidator.validUnits;

    Map<String, String> unitMap = {};

    List<String> parts = unitInput.split('/');
    if (parts.length != 2) {
      throw ValidationException("Måste vara mängd/volym");
    }
    if (!UnitValidator.isSubstanceUnit(parts[0])) {
      throw ValidationException(
          "Felaktig enhet: [${parts[0]}], bör vara ${UnitValidator.validSubstanceUnits().keys.join(", ")}");
    } else if (!UnitValidator.isVolumeUnit(parts[1])) {
      throw ValidationException(
          "Felaktig enhet: [${parts[1]}], bör vara ${UnitValidator.validVolumeUnits().keys.join(", ")}");
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
}
