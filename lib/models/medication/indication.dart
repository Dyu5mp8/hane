import 'package:hane/models/medication/bolus_dosage.dart';
import 'package:hane/models/medication/continuous_dosage.dart';

class Indication {
  final String name;
  final List<BolusDosage>? bolus;
  final List<ContinuousDosage>? infusion;
  final String? notes;

  Indication({
    required this.name,
    this.bolus,
    this.infusion,
    this.notes,
  });
}