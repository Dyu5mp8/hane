import "package:equatable/equatable.dart";
import "package:hane/drugs/models/units.dart";
import "package:hane/utils/unit_service.dart";
import "package:hane/utils/validation_exception.dart";

class Concentration {
  final double amount;
  final SubstanceUnit substance;
  final DiluentUnit diluent;
  final String? mixingInstructions;
  final bool? isStockSolution;
  final String? aliasUnit;

  Concentration({
    required this.amount,
    required this.substance,
    required this.diluent,
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
  })  : substance = SubstanceUnit.fromString(unit.split('/')[0]),
        diluent = DiluentUnit.fromString(unit.split('/')[1]);

  factory Concentration.fromMap(Map<String, dynamic> map) {
    num amount = map['amount'] as num;

    String unit = map['unit'] as String;
    String substance = unit.split('/')[0];
    String diluent = unit.split('/')[1];

    return Concentration(
      amount: amount.toDouble(),
      substance: SubstanceUnit.fromString(substance),
      diluent: DiluentUnit.fromString(diluent),
      mixingInstructions: map['mixingInstructions'] as String?,
      isStockSolution: map['isStockSolution'] as bool?,
      aliasUnit: map['aliasUnit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unitToString,
      'mixingInstructions': mixingInstructions,
      'isStockSolution': isStockSolution,
      'aliasUnit': aliasUnit,
    };
  }

  @override
  List<Object?> get props => [
        amount,
        substance,
        diluent,
        mixingInstructions,
        isStockSolution,
        aliasUnit
      ];

  set amount(double newAmount) {
    if (amount != newAmount) {
      amount = newAmount;
    }
  }

  String get unitToString {
    return "${substance.toString()}/${diluent.toString()}";
  }

  @override
  String toString() {
    return "$amount $unitToString";
  }

  String? getSecondaryRepresentation() {
    if (aliasUnit == null || aliasUnit!.isEmpty) {
      return null;
    }
    return "$aliasUnit";
  }
}
