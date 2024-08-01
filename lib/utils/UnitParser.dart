import "package:hane/models/medication/dose.dart";
import "package:hane/utils/UnitValidator.dart";


class UnitParser{
  
  UnitParser();

    static getUnitConversionFactor({required String fromUnit, required String toUnit}){

    if (UnitValidator.validUnits[fromUnit] != (UnitValidator.validUnits[toUnit])){

      throw Exception("Both units must be of the same type");

    }

    Map conversionFactorMap;

    if (UnitValidator.validUnits[fromUnit] == "mass"){
      conversionFactorMap = 
      {
        "g": 1,
        "mg": 1000,
        "mikrog": 1000000,
        "ng": 1000000000,
      };
      return conversionFactorMap[fromUnit] / conversionFactorMap[toUnit];
    }

    if (UnitValidator.validUnits[fromUnit] == "unitunit"){
      conversionFactorMap = 
      {
        "IE": 1,
        "E": 1,
        "FE": 1,
      };
      return {conversionFactorMap[fromUnit] / conversionFactorMap[toUnit]};
    }

    if (UnitValidator.validUnits[fromUnit] == "molar"){
      conversionFactorMap = 
      {
        "mmol": 1,
      };
      return {conversionFactorMap[fromUnit] / conversionFactorMap[toUnit]};
    }

    if (UnitValidator.validUnits[fromUnit] == "volume"){
      conversionFactorMap = 
      {
        "mikrol": 1,
        "ml": 1,
        "l": 1000,
      };

       return {conversionFactorMap[fromUnit] / conversionFactorMap[toUnit]};
    } 

    if (UnitValidator.validUnits[fromUnit] == "time"){
      conversionFactorMap = 
      {
        "s": 1,
        "min": 60,
        "h": 3600,
        "d": 86400,
      };
       return {conversionFactorMap[fromUnit] / conversionFactorMap[toUnit]};
    }

    else {
      throw Exception("Not a valid unit");
    }

    }
  
    static getConcentrationsUnitsAsMap(String unitInput){

    Map<String, String> unitMap = {};

    List<String> parts = unitInput.split('/');
    if (parts.length != 2){
      throw Exception("Not a valid unit");
    }

    if (!UnitValidator.isSubstanceUnit(parts[0])){  
      throw Exception("Not a valid unit : $parts[0]");
    } 

    if (!UnitValidator.isVolumeUnit(parts[1])){
      throw Exception("Not a valid unit : $parts[1]");
    }

    else{
    unitMap["substance"] = parts[0];
    unitMap["volume"] = parts[1];
    }

    return unitMap;
    }


}