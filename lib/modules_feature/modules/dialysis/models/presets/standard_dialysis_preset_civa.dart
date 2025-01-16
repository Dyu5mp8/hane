import 'package:hane/modules_feature/modules/dialysis/models/dialysis_preset.dart';

class CivaStandardDialysisPreset implements DialysisPreset {
  @override
  double weight;
  @override
  final String label;

@override
  void setWeight(double value) {
    weight = value;
  }

  CivaStandardDialysisPreset({
    required this.weight,
    required this.label,
  });

  @override
  double suggestedBloodFlow() {
    switch (weight) {
      case var w when w < 70:
        return 200;
      case var w when w >= 70 && w < 90:
        return 225;
      case var w when w >= 90:
        return 250;
      default:
        throw Exception('Unexpected weight value: $weight');
    }
  }

  @override
  suggestedDialysateFlow() {
      switch (weight) {
      case var w when w < 70:
        return 500;
      case var w when w >= 70 && w < 90:
        return 1000;
      case var w when w >= 90 && w < 130:
        return 1000 + (w - 90) * (1500 - 1000) / (130 - 90);
      case var w when w >= 130:
        return 1500;
      default:
        throw Exception('Unexpected weight value: $weight');
    }
  }

  @override
  suggestedFluidRemoval() {
    return 0;
  }

  @override 
double suggestedPostdilutionFlow() {
   return 500;
}

 

  @override
  suggestedPredilutionFlow() {
    switch (weight) {
      case var w when w < 70:
        return 1300;
      case var w when w >= 70 && w < 90:
        return 1500 + (w - 70) * (2000 - 1500) / (90 - 70);
      case var w when w >= 90:
        return 2000;
      default:
        throw Exception('Unexpected weight value: $weight');
    }
  }
  

}
