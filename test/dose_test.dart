import 'package:flutter_test/flutter_test.dart';
import 'package:hane/medications/models/medication.dart';

void main() {
  group('dose', () {
    test("create", () {

      Dose dose = Dose(
        amount: 20000.0,
        units: {
          "substance": "g",
          "time": "h"
        }
      );
    print(dose);

    Concentration concentration = Concentration(
      amount: 5.0,
      unit: "mg/ml"
    );
    Dose convertedDose = dose.convertedBy(convertTime: "min", convertConcentration: concentration);

    print(convertedDose);
    
      // 
    });

    test("should convert", () {
      // 
    });
  });
}