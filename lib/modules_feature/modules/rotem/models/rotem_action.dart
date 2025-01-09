import 'package:hane/drugs/models/drug.dart';


class RotemAction {
  final Dosage dosage;
  final List<Concentration>? availableConcentrations;

  RotemAction({
    required this.dosage,
    this.availableConcentrations,
  });
  
}