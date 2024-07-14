import "dart:ffi";

import "package:hane/Views/medication_view/medication_detail_view/DoseConverter.dart";
import "package:hane/models/medication/bolus_dosage.dart";
import "package:hane/models/medication/dose.dart";



  class DosageViewHandler {
    final Dosage dosage;
    DoseConverter _doseConverter = DoseConverter();

    DosageViewHandler( {
      required this.dosage
    }
    );

  set doseConverter(DoseConverter doseConverter) {
    _doseConverter = doseConverter;
  } 

  Dose dose() {
    
    return dosage.dose!;
  }


    

  String showDosage(Dosage dosage) {
    // Using buffer for efficient string concatenation
    StringBuffer doseString = StringBuffer();
    if (dosage.instruction != null) {
      doseString.write(dosage.instruction);
    }
    // Adding the basic dose information if available
    if (dosage.dose != null) {
      doseString.write("${dosage.dose!.amount} ${dosage.dose!.unit}");
    }

    // Range display if both limits are available
    if (dosage.lowerLimitDose != null && dosage.higherLimitDose != null) {
      if (doseString.isNotEmpty) {
        doseString.write(" (");
      }
      doseString.write("${dosage.lowerLimitDose!.amount} ${dosage.lowerLimitDose!.unit} - ${dosage.higherLimitDose!.amount} ${dosage.higherLimitDose!.unit}");
      if (doseString.toString().contains("(")) {
        doseString.write(")");
      }
    }

    // Compose final message
    String result = "${dosage.instruction}: ${dosage.administrationRoute} ${doseString.toString()}.";

    // Append max dose if available
    if (dosage.maxDose != null) {
      result += " Maxdos: ${dosage.maxDose!.amount} ${dosage.maxDose!.unit}.";
    }

    return result;
  }
}