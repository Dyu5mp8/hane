import 'package:hane/models/medication/dose.dart';  

class ContinuousDosage {
  final String instruction;
  final String administrationRoute;
  final Map<String, Dose> dose;
  final Map<String, Dose> weightBasedDose;
  final String timeUnit;

  ContinuousDosage({
    required this.instruction,
    required this.administrationRoute,
    required this.dose,
    required this.weightBasedDose,
    required this.timeUnit,
  });
}