import 'package:flutter_test/flutter_test.dart';
import 'package:hane/models/medication/medication.dart';

void main() {
  group('dose', () {
    test("create", () {

      Dose dose = Dose(
        amount: 20000.0,
        units: {
          "substance": "gs",
          "time": "h"
        }
      );
    print(dose.toString());

    Concentration concentration = Concentration(
      amount: 5.0,
      unit: "mg/l"
    );
    Dose convertedDose = dose.convertedBy(convertTime: "min", convertConcentration: concentration);

    print(convertedDose.toString());
    
      // 
    });

    test("should convert", () {
      // 
    });
  });
}