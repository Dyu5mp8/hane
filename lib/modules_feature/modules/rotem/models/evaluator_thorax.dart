class RotemEvaluator {
  final double? ctExtem;
  final double? ctIntem;
  final double? a10Fibtem;
  final double? a5Fibtem;
  final double? a10Extem;
  final double? a5Extem;
  final double? mlExtem;
  final double? ctHeptem;

  RotemEvaluator({
    required this.ctExtem,
    required this.ctIntem,
    required this.a10Fibtem,
    required this.a5Fibtem,
    required this.a10Extem,
    required this.a5Extem,
    required this.mlExtem,
    required this.ctHeptem,
  });

  bool get _lowFibTem {
    if (a10Fibtem != null && a10Fibtem! < 12 ) {
        return true;
      }
    if (a5Fibtem != null && a5Fibtem! < 11 ) {
        return true;
    }
    return false;
  }
  bool get _lowExtem {
    if (a10Extem != null && a10Extem! < 43 ) {
        return true;
      }
    if (a5Extem != null && a5Extem! < 34 ) {
        return true;
    }
    return false;
  }

  bool get _highCTExtem {
    if (ctExtem != null && ctExtem! > 79) {
        return true;
      }
    return false;
  }

  bool get _highCTIntem {
    if (ctIntem != null && ctIntem! > 240) {
        return true;
      }
    return false;
  }

  Map<String, String> evaluate() {
    Map<String, String> actions = {};

    // Rule 1: PCC (EXTEM) and/or FFP (EXTEM/INTEM)

    if (_highCTExtem) {

      switch (_highCTIntem)
      {
        case true:
          actions["FFP"] = "Högt CT EXTEM och INTEM";
          break;
        case false:
          actions["PCC"] = "Högt CT EXTEM";
          break;
      }
    }

    else if (_highCTIntem) {
      actions["FFP"] = "Högt CT INTEM";
    } 

    // Rule 2: Fibrinogen
    if (_lowFibTem) { 
        actions["Fibrinogen"] = "Lågt Fibtem";
      }
    

    // Rule 3: Platelets
    if (!_lowFibTem) {
      if (_lowExtem) {
        actions["Trombocyter"] = "Lågt EXTEM";
      }
    }

    // Rule 4: Tranexamic acid
    if (mlExtem != null && mlExtem! > 15) {

        actions["Tranexamic acid"] = "Högt ML EXTEM";
  
    }

    // Rule 5: Protamine
    if (ctHeptem != null && ctIntem != null) {
      if (ctHeptem!/ctIntem! > 1.1) {
        actions["Protamin"] = "Skillnad mellan CT HEPTEM och INTEM mer än 10%";
      }
  
  }
    print (actions);
    return actions;
}
}