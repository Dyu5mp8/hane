import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hane/Views/medication_view/medication_detail_view/DoseConverter.dart';
import 'package:hane/Views/medication_view/medication_detail_view/dosageViewHandler.dart';
import 'package:hane/models/medication/bolus_dosage.dart';

import 'package:hane/models/medication/medication.dart';


void main(){

  group('dosageViewHandler', () {
 Dosage dosage = Dosage(
        dose: Dose(amount: 5.0, unit: 'mg/min'),
        lowerLimitDose: Dose(amount: 0.01, unit: 'mg/kg/h'),
        higherLimitDose: Dose(amount: 1, unit: 'mg/kg/h'),
        maxDose: Dose(amount: 10.0, unit: 'mg'),
        instruction: "instruction",
        administrationRoute: "administrationRoute",
      );

      double conversionWeight = 70.0;
      String conversionTime = "h";
      Concentration conversionConcentration = Concentration(amount: 0.5, unit: 'mg/ml');
      var availableConcentrations= [Concentration(amount: 0.5, unit: 'mg/ml'), Concentration(amount: 1.0, unit: 'mg/ml')];
        Key key = Key("key");

        var dosageViewHandler = DosageViewHandler(

        key,
        dosage: dosage,
        conversionWeight: conversionWeight,
        conversionTime: conversionTime,
        conversionConcentration: conversionConcentration,
        availableConcentrations: availableConcentrations
      );
    test("create", () {

     


      print(dosageViewHandler.showDosage());


    });

    test("should convert", (){

      print(dosageViewHandler.ableToConvert());
      print(dosageViewHandler.ableToConvert().time);



    
    }
    );


  });



    }