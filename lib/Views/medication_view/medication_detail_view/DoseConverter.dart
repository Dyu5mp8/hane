import "package:hane/models/medication/medication.dart";
import "package:hane/utils/UnitService.dart";

class DoseConverter {

  static double? patientWeight;

// exposed method
  
  static Dose convertDose({required Dose dose, double? convertWeight, String? convertTime, Concentration? convertConcentration}) {
    double value = dose.amount;
    Map fromUnits = UnitParser.getDoseUnitsAsMap(dose.unit);


    if (convertWeight != null && fromUnits.containsKey("patientWeight")) {
      var result = convertedByWeight(value, fromUnits, convertWeight);
      value = result.$1;
      fromUnits = result.$2;
    }

    if (convertTime != null && fromUnits.containsKey("time")) {
      var result = convertedByTime(value, fromUnits, convertTime);
      value = result.$1;
      fromUnits = result.$2;
    }

    if (convertConcentration != null) {
      var result = convertedByConcentration(value, fromUnits, convertConcentration);
      value = result.$1;
      fromUnits = result.$2;
    }

    return UnitParser.calculatedDose(value, fromUnits);
  }


// The following methods are used to convert the dose to the desired unit

   static convertedByWeight(double value, Map fromUnits, double conversionWeight) {
    patientWeight = conversionWeight;
    final newValue = value * conversionWeight;
    
    fromUnits.remove("patientWeight");
    final newUnits = fromUnits;

    return (newValue, newUnits);
  }
  
  static (double, Map) convertedByTime(double value, Map fromUnits, String toUnit) {

    Map <String, double> validTimeUnits = {
      "h": 1,
      "min": 60
    };

    if (fromUnits == null || !validTimeUnits.containsKey(fromUnits["time"]) || !validTimeUnits.containsKey(toUnit)) {
    Exception("$fromUnits is not an valid unit");
  }
    if (validTimeUnits[fromUnits["time"]] == null ||  validTimeUnits[toUnit] == null) { 
      throw Exception("$fromUnits or $toUnit is not a valid unit");
    }
    
    double factor = validTimeUnits[fromUnits["time"]]! / validTimeUnits[toUnit]!;
    var newValue = value * factor;
    var newUnits = fromUnits;
    newUnits["time"] = toUnit;

    return (newValue, newUnits);
  }

  static (double, Map) convertedByConcentration(double value, Map fromUnits, Concentration concentration) {

    final concentrationUnitMap = UnitParser.getConcentrationsUnitsAsMap(concentration.unit); 
    double substanceConversionFactor = UnitParser.getUnitConversionFactor(fromUnit: concentrationUnitMap["substance"] , toUnit: fromUnits["substance"]);

    var newValue = value/concentration.amount * substanceConversionFactor;  

    fromUnits["substance"] = concentrationUnitMap["volume"];
    var newUnits = fromUnits;
   

    return (newValue, newUnits);

}
}
