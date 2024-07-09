import 'package:hane/models/medication/dose.dart';

class BolusDosage {
  final String instruction;
  final String administrationRoute;
  final Map<String, Dose> dose;
  final Map<String, Dose> weightBasedDose;

  BolusDosage({
    required this.instruction,
    required this.administrationRoute,
    required this.dose,
    required this.weightBasedDose,
  });
}