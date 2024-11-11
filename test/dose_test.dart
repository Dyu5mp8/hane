import 'package:flutter_test/flutter_test.dart';
import 'package:hane/drugs/models/drug.dart';

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


    Concentration concentration = Concentration(
      amount: 5.0,
      unit: "mg/ml"
    );

    
      // 
    });

    test("should convert", () {
      // 
    });
  });
}