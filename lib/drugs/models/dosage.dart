import 'package:hane/drugs/models/administration_route.dart';
import 'package:hane/drugs/models/dose.dart';
import 'package:equatable/equatable.dart';
import 'package:hane/drugs/models/units.dart';

class Dosage with EquatableMixin {
  String? _instruction;
  AdministrationRoute? _administrationRoute;
  Dose? _dose;
  Dose? _lowerLimitDose;
  Dose? _higherLimitDose;
  Dose? _maxDose;

  Dosage({
    String? instruction,
    AdministrationRoute? administrationRoute,
    Dose? dose,
    Dose? lowerLimitDose,
    Dose? higherLimitDose,
    Dose? maxDose,
  }) : _instruction = instruction,
       _administrationRoute = administrationRoute,
       _dose = dose,
       _lowerLimitDose = lowerLimitDose,
       _higherLimitDose = higherLimitDose,
       _maxDose = maxDose;

  Dosage.from(Dosage dosage)
    : _instruction = dosage.instruction,
      _administrationRoute = dosage.administrationRoute,
      _dose = dosage.dose,
      _lowerLimitDose = dosage.lowerLimitDose,
      _higherLimitDose = dosage.higherLimitDose,
      _maxDose = dosage.maxDose;

  @override
  List<Object?> get props => [
    _instruction,
    _administrationRoute,
    _dose,
    _lowerLimitDose,
    _higherLimitDose,
    _maxDose,
  ];

  // Getters
  String? get instruction => _instruction;
  AdministrationRoute? get administrationRoute => _administrationRoute;
  Dose? get dose => _dose;
  Dose? get lowerLimitDose => _lowerLimitDose;
  Dose? get higherLimitDose => _higherLimitDose;
  Dose? get maxDose => _maxDose;

  SubstanceUnit? getSubstanceUnit() {
    return _dose?.substanceUnit ??
        _lowerLimitDose?.substanceUnit ??
        _higherLimitDose?.substanceUnit ??
        _maxDose?.substanceUnit;
  }

  WeightUnit? getWeightUnit() {
    return _dose?.weightUnit ??
        _lowerLimitDose?.weightUnit ??
        _higherLimitDose?.weightUnit ??
        _maxDose?.weightUnit;
  }

  TimeUnit? getTimeUnit() {
    return _dose?.timeUnit ??
        _lowerLimitDose?.timeUnit ??
        _higherLimitDose?.timeUnit ??
        _maxDose?.timeUnit;
  }

  // Setters with notification
  set instruction(String? newInstruction) {
    _instruction = newInstruction;
  }

  set administrationRoute(AdministrationRoute? newRoute) {
    _administrationRoute = newRoute;
  }

  set dose(Dose? newDose) {
    _dose = newDose;
  }

  set lowerLimitDose(Dose? newLowerLimitDose) {
    _lowerLimitDose = newLowerLimitDose;
  }

  set higherLimitDose(Dose? newHigherLimitDose) {
    _higherLimitDose = newHigherLimitDose;
  }

  set maxDose(Dose? newMaxDose) {
    _maxDose = newMaxDose;
  }

  // Convert Dosage to JSON
  Map<String, dynamic> toJson() {
    return {
      'instruction': _instruction,
      'administration_route': _administrationRoute?.name,
      'dose': _dose?.toJson(),
      'lower_limit_dose': _lowerLimitDose?.toJson(),
      'higher_limit_dose': _higherLimitDose?.toJson(),
      'max_dose': _maxDose?.toJson(),
    };
  }

  // Factory to create Dosage from Firestore
  factory Dosage.fromFirestore(Map<String, dynamic> map) {
    return Dosage(
      instruction: map['instruction'] as String?,
      administrationRoute: AdministrationRoute.fromString(
        map['administration_route'] as String?,
      ),
      dose:
          map['dose'] != null
              ? Dose.fromFirestore(map['dose'] as Map<String, dynamic>)
              : null,
      lowerLimitDose:
          map['lower_limit_dose'] != null
              ? Dose.fromFirestore(
                map['lower_limit_dose'] as Map<String, dynamic>,
              )
              : null,
      higherLimitDose:
          map['higher_limit_dose'] != null
              ? Dose.fromFirestore(
                map['higher_limit_dose'] as Map<String, dynamic>,
              )
              : null,
      maxDose:
          map['max_dose'] != null
              ? Dose.fromFirestore(map['max_dose'] as Map<String, dynamic>)
              : null,
    );
  }
}
