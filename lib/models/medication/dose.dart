import 'package:hane/models/medication/medication.dart';
import 'package:hane/models/medication/concentration.dart';
import 'package:hane/utils/UnitService.dart';

class Dose {
  final double amount;
  final Map<String, String> units;



  Dose({required this.amount, required this.units}); 

  Dose.fromString({required double amount, required String unit}) : this.amount = amount, units = _getDoseUnitsAsMap(unit); 

String unitString() {
  return units.values.join('/');
}

 static Map<String, String> _getDoseUnitsAsMap(String unitInput){
    Map validUnits = UnitValidator.validUnits;

      Map<String, String> unitMap = {};

      List<String> parts = unitInput.split('/');
      if (parts.length > 3){
        throw Exception("Not a valid unit : more than 4 units");
      }
      if (!UnitValidator.isSubstanceUnit(parts[0])){  
        throw Exception("Not a valid unit : $parts[0]");
      } 

      else{

        unitMap["substance"] = parts[0];
      } 
      for (final part in parts.sublist(1)){
        if (validUnits.keys.contains((part))){
          unitMap[validUnits[part]] = part;
        }
        else {
          throw Exception("Not a valid unit");
       
        }

    }
    return unitMap;
 }


// Factory constructor to create a Dose from a Map
  factory Dose.fromFirestore(Map<String, dynamic> map) {
    num amount = map['amount'] as num;
    return Dose.fromString(
      amount: amount.toDouble(),
      unit: map['unit'] as String,
    );
  }

  // Convert a Dose instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unitString(),
    };
  }

   
  Dose convertedBy({double? convertWeight, String? convertTime, Concentration? convertConcentration}) {
    Dose convertedDose = Dose(amount: amount, units: units);
    Map fromUnits = convertedDose.units;
    double value = convertedDose.amount;


    if (convertWeight != null && fromUnits.containsKey("patientWeight")) {
      var result = _convertedByWeight(value, fromUnits, convertWeight);
      value = result.$1;
      fromUnits = result.$2;
    }

    if (convertTime != null && fromUnits.containsKey("time")) {
      var result = _convertedByTime(value, fromUnits, convertTime);
      value = result.$1;
      fromUnits = result.$2;
    }

    if (convertConcentration != null) {
      var result = _convertedByConcentration(value, fromUnits, convertConcentration);
      value = result.$1;
      fromUnits = result.$2 as Map<String, String>;
    }
    return convertedDose;
  }


// The following methods are used to convert the dose to the desired unit

  _convertedByWeight(double value, Map fromUnits, double conversionWeight) {

    final newValue = value * conversionWeight;
    
    fromUnits.remove("patientWeight");
    final newUnits = fromUnits;

    return (newValue, newUnits);
  }
  
  _convertedByTime(double value, Map fromUnits, String toUnit) {

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

  static (double, Map) _convertedByConcentration(double value, Map fromUnits, Concentration concentration) {

    final concentrationUnitMap = UnitParser.getConcentrationsUnitsAsMap(concentration.unit); 
    double substanceConversionFactor = UnitParser.getUnitConversionFactor(fromUnit: concentrationUnitMap["substance"] , toUnit: fromUnits["substance"]);

    var newValue = value/concentration.amount * substanceConversionFactor;  

    fromUnits["substance"] = concentrationUnitMap["volume"];
    var newUnits = fromUnits;
   

    return (newValue, newUnits);

}


 int _conversionStep(double amount) {
  int count = 0;
  if (amount <= 0) return count;

    while (amount < 0.1) {
      amount = amount * 1000;
      count = count + 1;
    }

    while (amount > 1000) {
      amount = amount / 1000;
      count = count - 1;
    
  }
  return count;
}


}
