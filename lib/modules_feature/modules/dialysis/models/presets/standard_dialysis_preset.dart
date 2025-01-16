import 'package:hane/modules_feature/modules/dialysis/models/dialysis_preset.dart';

class StandardDialysisPreset implements DialysisPreset {
  @override
  double weight;
  @override
  final String label;

@override
  void setWeight(double value) {
    weight = value;
  }

  StandardDialysisPreset({
    required this.weight,
    required this.label,
  });

  @override
  suggestedBloodFlow() {
    return weight + 50;
  }

  @override
  suggestedDialysateFlow() {
    return weight * 10 + 500;
  }

  @override
  suggestedFluidRemoval() {
    return 0;
  }

  @override 
double suggestedPostdilutionFlow() {
  // Define the weight-flow mapping
  final weightFlowMap = {
    50: 400,
    60: 500,
    70: 500,
    80: 500,
    90: 600,
    100: 700,
    110: 800,
    120: 1000,
  };

  // Clamp weight within the range of the map keys
  final clampedWeight = weight.clamp(50.0, 120.0);

  // If the exact weight exists in the map, return the corresponding flow
  if (weightFlowMap.containsKey(clampedWeight.toInt())) {
    return weightFlowMap[clampedWeight.toInt()]!.toDouble();
  }

  // Otherwise, perform interpolation
  final keys = weightFlowMap.keys.toList()..sort();
  for (int i = 0; i < keys.length - 1; i++) {
    final lowerWeight = keys[i];
    final upperWeight = keys[i + 1];

    if (clampedWeight > lowerWeight && clampedWeight < upperWeight) {
      final lowerFlow = weightFlowMap[lowerWeight]!;
      final upperFlow = weightFlowMap[upperWeight]!;

      // Linear interpolation formula
      final interpolatedFlow = lowerFlow +
          (upperFlow - lowerFlow) *
              ((clampedWeight - lowerWeight) / (upperWeight - lowerWeight));
      return interpolatedFlow.clamp(400.0, 1000.0);
    }
  }

  // Fallback, though it shouldn't be needed due to clamping
  return 400.0;
}

 

  @override
  suggestedPredilutionFlow() {
    return suggestedBloodFlow() * 10;
  }
  

}
