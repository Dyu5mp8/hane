abstract class DialysisPreset {
  String get label;
  double get weight;

  double suggestedPredilutionFlow();

  double suggestedPostdilutionFlow();

  double suggestedDialysateFlow();

  double suggestedFluidRemoval();

  double suggestedBloodFlow();

  void setWeight(double value);
}
