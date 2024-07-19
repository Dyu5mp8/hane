import "package:hane/utils/UnitValidator.dart";

class UnitParser{
  
  UnitParser();

  
  static Map<String, String> getUnits(String unitInput){
    Map validUnits = UnitValidator.validUnits;

      Map<String, String> unitMap = {};

      List<String> parts = unitInput.split('/');
      if (parts.length > 3){
        throw Exception("Not a valid unit : more than 4 units");
      }

      if (!UnitValidator.isMassUnit(parts[0])){

        throw Exception("Not a valid unit : $parts[0]");
      } 

      else{
      unitMap["mass"] = parts [0];

      for (final part in parts){
        if (validUnits.keys.contains((part))){
          unitMap[validUnits[part]] = part;
        }
        else {
          throw Exception("Not a valid unit");
       
        }
}
      }

      
return unitMap;

      }

}