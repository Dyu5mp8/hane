import 'package:flutter_test/flutter_test.dart';
import 'package:hane/utils/UnitValidator.dart';


void main() {
  group('unitvalidator', () {

    test('initializes with all parameters', () {
      
        print(UnitValidator.isSubstanceUnit("mg"));
        print(UnitValidator.isVolumeUnit("ml"));
        print(UnitValidator.isTimeUnit("h")); 
        print(UnitValidator.isValidUnit("mg")); 
        print(UnitValidator.isValidUnitType("substance"));

        print(UnitValidator.isSubstanceUnit("E"));
        print(UnitValidator.isSubstanceUnit("IE"));

    });

    test("testing validSubstanceUnits", () {
      print(UnitValidator.validSubstanceUnits());
    });
    test("isvalidconcentration", () {
      print(UnitValidator.isValidConcentrationUnit("mg/ml"));
      print(UnitValidator.isValidConcentrationUnit("E/ml"));
      print(UnitValidator.isValidConcentrationUnit("ml/kg"));




    });

    }
    
    
    );
  }
