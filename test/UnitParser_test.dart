import 'package:flutter_test/flutter_test.dart';
import 'package:hane/utils/UnitService.dart';

void main() {
  group('parser', () {
    test('initializes with all parameters', () {
      String input = "mg/ml";
      try {
        var units = UnitParser.getConcentrationsUnitsAsMap(input);
        print(units);
      } catch (e) {
        print(e);
      }

    });

    test('testing getDoseUnitsAsMap', () {
      String input = "msg/kg/min";
      var units = UnitParser.getDoseUnitsAsMap(input);
      print(units);
    });

    test("testing conversion", () {
      String input = "mg/ml";

      var result= UnitParser.getUnitConversionFactor(fromUnit: "E", toUnit: "g");
      print(result);
    });


   

  });
}