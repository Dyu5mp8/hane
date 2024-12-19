// A class that holds cutoff values for ROTEM parameters.
/// Values at or below a certain cutoff might be considered "normal" or "acceptable",
/// while values above (or below) indicate deviations that trigger certain actions.
class RotemReference {
  final String? scenarioName;

  /// CT EXTEM cutoff in seconds. If patient's CT EXTEM > ctExtemCutoff, it's considered prolonged.
  final double? ctExtemCutoff;

  /// CT INTEM cutoff in seconds. If patient's CT INTEM > ctIntemCutoff, it's considered prolonged.
  final double? ctIntemCutoff;

  /// A10 Fibtem cutoff in mm. If patient's A10 Fibtem < a10FibtemCutoff, it's considered low.
  final double? a10FibtemCutoff;

  /// A5 Fibtem cutoff in mm. If patient's A5 Fibtem < a5FibtemCutoff, it's considered low.
  final double? a5FibtemCutoff;

  /// A10 EXTEM cutoff in mm. If patient's A10 EXTEM < a10ExtemCutoff, it's considered low.
  final double? a10ExtemCutoff;

  /// A5 EXTEM cutoff in mm. If patient's A5 EXTEM < a5ExtemCutoff, it's considered low.
  final double? a5ExtemCutoff;

  /// ML EXTEM cutoff in %. If patient's ML EXTEM > mlExtemCutoff, it's considered elevated.
  final double? mlExtemCutoff;

  /// CT HEPTEM/CT INTEM ratio cutoff. If ratio > ctHeptemRatioCutoff,
  /// it's considered indicative of heparin effect.
  final double? ctHeptemRatioCutoff;

  RotemReference({
    this.scenarioName,
    this.ctExtemCutoff,
    this.ctIntemCutoff,
    this.a10FibtemCutoff,
    this.a5FibtemCutoff,
    this.a10ExtemCutoff,
    this.a5ExtemCutoff,
    this.mlExtemCutoff,
    this.ctHeptemRatioCutoff,
  });
}
