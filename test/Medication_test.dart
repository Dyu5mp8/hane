import 'package:flutter_test/flutter_test.dart';
import 'package:hane/medications/models/bolus_dosage.dart';
import 'package:hane/medications/models/dose.dart';
import 'package:hane/medications/models/indication.dart';
import 'package:hane/medications/models/medication.dart';



void main() {
  group('test string function for concentration', () {

     Medication testMedication = Medication(
      name: "milrinon",
      contraindication: "Hypotenad kardiell syrgaskons, takykardi, ",
      concentrations: [(amount: 0.05, unit: "fe"), (amount: 0.1, unit: "mg/ml")],
      notes: "<0,375 μg/kn β1-awdasdawdadwadawdawdawddawdawdadsdasdwdawdsdeffekt, blodtrycksstegring, ökad CO och EF.",
      indications: [
        Indication(
          name: "Cirkulatorisk chock",
          isPediatric: false,
          dosages: [
            Dosage(
              instruction: 
                  "Ge därefter kontinuerlig infusion",
              administrationRoute: "IV",
              lowerLimitDose: Dose(amount: 0.37,unit: 'mikrog/kg/min'),
              higherLimitDose: Dose(amount: 0.75, unit: 'mikrog/kg/min'),
              maxDose: Dose(amount: 1.0, unit: 'mg'),
            ),
              Dosage(
                instruction: "bolusdos initialt",
                administrationRoute: "IV",
                dose: Dose(amount: 50.0, unit: 'mikrog/kg'),
            )
          ],
        )
      ]
              

    );

    
    test('initializes with all parameters', () {
      print(testMedication.getConcentrationsAsString());
    }
    );
  }
  );
  
    
    }