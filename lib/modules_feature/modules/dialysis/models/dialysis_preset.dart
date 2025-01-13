class DialysisPreset {

  double? weight;
  double postDilutionFlow;
  double dialysateFlow;
  double fluidRemoval;
  double hematocritLevel;
  bool isCitrateLocked;
  double citrateLevel;
  double preDilutionFlow;
  double bloodFlow;

  DialysisPreset
({
    required this.postDilutionFlow,
    required this.dialysateFlow,
    required this.fluidRemoval,
    required this.hematocritLevel,
    required this.isCitrateLocked,
    required this.citrateLevel,
    required this.preDilutionFlow,
    required this.bloodFlow,
  });

  DialysisPreset
.fromJson(Map<String, dynamic> json)
      : weight = json['weight'],
        postDilutionFlow = json['postDilutionFlow'],
        dialysateFlow = json['dialysateFlow'],
        fluidRemoval = json['fluidRemoval'],
        hematocritLevel = json['hematocritLevel'],
        isCitrateLocked = json['isCitrateLocked'],
        citrateLevel = json['citrateLevel'],
        preDilutionFlow = json['preDilutionFlow'],
        bloodFlow = json['bloodFlow'];


  Map<String, dynamic> toJson() => {
    'weight': weight,
    'postDilutionFlow': postDilutionFlow,
    'dialysateFlow': dialysateFlow,
    'fluidRemoval': fluidRemoval,
    'hematocritLevel': hematocritLevel,
    'isCitrateLocked': isCitrateLocked,
    'citrateLevel': citrateLevel,
    'preDilutionFlow': preDilutionFlow,
    'bloodFlow': bloodFlow,
  };
}