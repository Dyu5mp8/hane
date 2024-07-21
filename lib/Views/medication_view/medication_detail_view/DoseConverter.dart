import "package:hane/models/medication/dose.dart";
import "package:hane/utils/UnitService.dart";

class DoseConverter {
  Dose dose;
  double? patientWeight;
  String? infusionTimeUnit;
  ({double amount, String unit})? concentration;
  Dose? convertedDose;
  Map<String, String>? units;

  DoseConverter(
      {required this.dose,
      this.patientWeight,
      this.infusionTimeUnit,
      this.concentration})
      : units = UnitParser.getUnitsAsMap(dose.unit);


  
   convertedByWeight(double value, Map units, double conversionWeight) {
    value = value * conversionWeight;
    units.remove("patientWeight");

    return (value, units);
  }
  
  (double, Map) convertedByTime(double value, Map fromUnits, String toUnit) {

    Map <String, double> validTimeUnits = {
      "h": 1,
      "min": 60
    };

    if (fromUnits == null || !validTimeUnits.containsKey(fromUnits["time"]) || !validTimeUnits.containsKey(toUnit)) {
    Exception("$fromUnits is not an valid unit");
  }
    double factor = validTimeUnits[fromUnits["time"]]! / validTimeUnits[toUnit]!;
    value = value * factor;
    var newUnits = fromUnits;
    newUnits["time"] = toUnit;


    return (value, newUnits);
  }

//   (double, Map) convertedByConcentration(double value, Map fromUnits, String toUnit) {
// Awaiting implementaiton
// }
}
