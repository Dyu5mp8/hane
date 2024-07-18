import "dart:ffi";

import "package:hane/Views/medication_view/medication_detail_view/DoseConverter.dart";
import "package:hane/models/medication/bolus_dosage.dart";
import "package:hane/models/medication/dose.dart";



 class DosageViewHandler {
  final Dosage dosage;
  final bool shouldConvertDoses;
  DoseConverter _doseConverter;

  DosageViewHandler({
    required this.dosage,
    required DoseConverter doseConverter,
    this.shouldConvertDoses = false,
  }) : _doseConverter = DoseConverter();
 


  Dosage _convertDosage(Dosage dosage){

    return Dosage(
      dose: shouldConvertDoses ? _doseConverter.convert(dosage.dose) : dosage.dose,

      lowerLimitDose: shouldConvertDoses ? _doseConverter.convert(dosage.lowerLimitDose) : dosage.lowerLimitDose,
      
      higherLimitDose: shouldConvertDoses ? _doseConverter.convert(dosage.higherLimitDose) : dosage.higherLimitDose,
      maxDose: shouldConvertDoses ? _doseConverter.convert(dosage.maxDose) : dosage.maxDose,
      instruction: dosage.instruction,
      administrationRoute: dosage.administrationRoute,
    );
  }
  




  String showDosage(Dosage dosage) {
    var dose = shouldConvertDoses ? _doseConverter.convert(dosage.dose) : dosage.dose;
    var lowerLimitDose = shouldConvertDoses ? _doseConverter.convert(dosage.lowerLimitDose) : dosage.lowerLimitDose;
    var higherLimitDose = shouldConvertDoses ? _doseConverter.convert(dosage.higherLimitDose) : dosage.higherLimitDose;
    var maxDose = shouldConvertDoses ? _doseConverter.convert(dosage.maxDose) : dosage.maxDose;

    // Using buffer for efficient string concatenation
    StringBuffer doseString = StringBuffer();
    if (dosage.instruction != null) {
      doseString.write(dosage.instruction);
    }
    // Adding the basic dose information if available
    if (dose != null) {
      doseString.write("${dose.amount} ${dose.unit}");
    }

    // Range display if both limits are available
    if (lowerLimitDose != null && higherLimitDose != null) {
      if (doseString.isNotEmpty) {
        doseString.write(" (");
      }
      doseString.write("${lowerLimitDose.amount} ${lowerLimitDose.unit} - ${higherLimitDose.amount} ${higherLimitDose.unit}");
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
