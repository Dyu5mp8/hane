import 'package:flutter_test/flutter_test.dart';

import 'package:hane/Views/medication_view/medication_detail_view/DoseConverter.dart';

import 'package:hane/models/medication/dose.dart';

void main(){

  group('DoseConverter', () {


    test('test convertedByConcentration method', () {
      Dose dose = Dose(amount: 5.0, unit: 'mg/min');
      DoseConverter converter = DoseConverter(
        dose: dose,
        patientWeight: 80,
        infusionTimeUnit: 'h',
        concentration: (amount: 5, unit:'mg/ml'),
      );

    


      var result = converter.convertedByConcentration(5, {"substance": "mg","patientWeight": "kg", "time": "min"}, (amount: 5, unit: 'mg/ml'));
      print (result);

      result = converter.convertedByTime(result.$1, result.$2, "h");

      print(result);

      result = converter.convertedByWeight(result.$1, result.$2, 50);

      print(result);

      result =converter.convertedByTime(result.$1, result.$2, "min");

      print(result);

      
    });
    test("testing whole method", () {
      Dose dose = Dose(amount: 5.0, unit: 'mg/min');
      DoseConverter converter = DoseConverter(
        dose: dose,
        patientWeight: 80,
        infusionTimeUnit: 'h',
        concentration: (amount: 5, unit:'mg/ml'),
      );

      var result = converter.convertDose(convertWeight: 50, convertTime: "h", convertConcentration: (amount: 5, unit: 'mg/ml'));
      print("${result.amount} ${result.unit}");
    });
  
  });

}