import 'package:flutter_test/flutter_test.dart';

import 'package:hane/Views/medication_view/medication_detail_view/DoseConverter.dart';import 'package:hane/models/medication/dose.dart';
import 'package:hane/utils/UnitService.dart';

void main() {
  group('DoseConverter', () {
        Dose dose = Dose(amount: 5.0, unit: 'mg/kg/min');
      DoseConverter converter = DoseConverter(
        dose: dose,
        patientWeight: 70,
        infusionTimeUnit: 'h',
        concentration: (amount: 5, unit:'mg/ml'),
      );
    test('initializes with all parameters', () {
      Dose dose = Dose(amount: 5.0, unit: 'mg/kg/min');
    
      print("ojoj ${converter.convertedByTime(5, {"mass": "kg", "time": "min"}, "h")}");
      expect(converter.dose.amount, 5.0);
      expect(converter.dose.unit, 'mg/kg/min');
      expect(converter.patientWeight, 70);
      expect(converter.infusionTimeUnit, 'h');
      expect(converter.concentration, (amount: 5.0, unit: 'mg/ml'));
      expect(converter.units, UnitParser.getUnitsAsMap('mg/kg/min'));
    });


    test("test dose parser", () {

      Dose dose = Dose(amount: 5.0, unit: 'mg/kg/min');
      var result = UnitParser.getUnitsAsMap(dose.unit);
      print(result);
      var afterWeightConversion = converter.convertedByWeight(5, result, 70);

      print(afterWeightConversion);
      print(afterWeightConversion.$2);
      var afterTimeConversion = converter.convertedByTime(afterWeightConversion.$1, afterWeightConversion.$2, "h");

      print(afterTimeConversion);

      


    });

    test('initializes with only dose', () {
      Dose dose = Dose(amount: 5.0, unit: 'mg/kg/min');
      DoseConverter converter = DoseConverter(dose: dose);

      expect(converter.dose.amount, 5.0);
      expect(converter.dose.unit, 'mg/kg/min');
      expect(converter.patientWeight, isNull);
      expect(converter.infusionTimeUnit, isNull);
      expect(converter.concentration, isNull);
      expect(converter.units, UnitParser.getUnitsAsMap('mg/kg/min'));
    });

    test('testPrint method prints expected values', () {
      Dose dose = Dose(amount: 5.0, unit: 'mg/kg/min');
      DoseConverter converter = DoseConverter(
        dose: dose,
        patientWeight: 70,
        infusionTimeUnit: 'h',
        concentration: (amount: 5, unit: 'mg/ml'),
      );

    });
  });
}