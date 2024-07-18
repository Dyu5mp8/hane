
import "package:hane/models/medication/dose.dart";


class DoseConverter {
  static final DoseConverter _singleton = DoseConverter._internal();

  factory DoseConverter() {
    return _singleton;
  }

  DoseConverter._internal();

  Dose convert(Dose originalDose) {

    return Dose(amount: originalDose.amount / 1000, unit: "grams");
  }
}


enum  SubstanceUnit { mg, g, mikrog, IE, E, ng, mmol}
enum TimeUnit { h, min}

class DoseConverter{
  
  bool convertingTime = false;
  bool convertingWeight = false;
  bool convertingConcentration = false;


  void setConversionMode({
    bool convertingTime = false, 
    bool convertingWeight = false, 
    bool convertingConcentration = false,
  }) {
    // Set the conversion mode
    this.convertingTime = convertingTime;
    this.convertingWeight = convertingWeight;
    this.convertingConcentration = convertingConcentration;
  }


  final Map<SubstanceUnit, double> conversionFactors = {
    SubstanceUnit.mg: 1.0,
    SubstanceUnit.g: 1000.0,
    SubstanceUnit.mikrog: 0.001,
    SubstanceUnit.IE: 1.0,
    SubstanceUnit.E: 1.0,
    SubstanceUnit.ng: 0.000001,
    SubstanceUnit.mmol: 1.0,
  };

final Map<TimeUnit, String> timeUnitStrings = {
    TimeUnit.h: 'h',
    TimeUnit.min: 'min',
  };  

List<dynamic> parseUnit(String unitString) {
    var units = unitString.split('/');
    return units.map((u) => Unit.values.firstWhere((e) => e.toString().split('.').last == u, orElse: () => null)).whereType<Unit>().toList();
  }

Dose convert(Dose? dose) {  
  var parts = parseUnit(dose.unit);

  return 

}



}