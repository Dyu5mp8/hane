import 'package:flutter/foundation.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_preset.dart';
import 'package:hane/modules_feature/modules/dialysis/models/presets/standard_dialysis_preset.dart';
import 'dialysis_parameter.dart'; // path to the new class

class DialysisViewModel extends ChangeNotifier {
  DialysisViewModel() {
    // Initialize with a standard preset as soon as the ViewModel is created
    loadDialysispreset(StandardDialysisPreset(weight: 70, label: 'Standard'));
  }

  // Example parameters:
  final DialysisParameter citrateParam = DialysisParameter(
    initialValue: 3.0,
    minValue: 1.0,
    maxValue: 5.0,
    highWarningValue: 4.5,
    lowWarningMessage: 'Citratnivå är för låg!',
    highWarningMessage:
        'Hög citratnivå. Säkerställ att citrat ej ackumuleras och beakta risken för alkalos.',
  );

  final DialysisParameter bloodFlowParam = DialysisParameter(
    initialValue: 100.0,
    minValue: 50.0,
    maxValue: 300.0,
    lowWarningMessage: 'Blodflöde är för lågt!',
    highWarningMessage: 'Blodflöde är för högt!',
  );

  final DialysisParameter preDilutionFlowParam = DialysisParameter(
    initialValue: 1000.0,
    minValue: 500.0,
    maxValue: 3000.0,
    lowWarningMessage: 'Låg p',
    highWarningMessage: 'Predilutionsflöde är för högt!',
  );

  final DialysisParameter dialysateFlowParam = DialysisParameter(
    initialValue: 1500.0,
    minValue: 500.0,
    maxValue: 3000.0,
    lowWarningMessage: 'Dialysatflöde är för lågt!',
    highWarningMessage: 'Dialysatflöde är för högt!',
  );

  final DialysisParameter fluidRemovalParam = DialysisParameter(
    initialValue: 0.0,
    minValue: 0.0,
    maxValue: 500.0,
    highWarningValue: 250,
    highWarningMessage:
        'Högt vätskeborttag. Säkerställ adekvata hemodynamiska parametrar och noggrann ersättning av elektrolyter och spårämnen',
  );

  final DialysisParameter postDilutionFlowParam = DialysisParameter(
    initialValue: 1500.0,
    minValue: 0.0,
    maxValue: 4000.0,
  );

  // Some fields that remain simple:
  double _hematocritLevel = 0.30; // range [0–1] => 30%
  double _weight = 70.0; // in kg
  double _length = 170.0; // in cm
  bool _isCitrateLocked = true;
  bool _isUpdating = false; // to prevent circular updates

  // ---------------------------------------------------------
  // 1) CITRATE
  //    Moved your cross-updating logic from _onCitrateChanged.
  // ---------------------------------------------------------

  void setCitrate(double newValue) {
    if (!_isUpdating) {
      _isUpdating = true;

      // Update the param's internal value
      citrateParam.value = newValue;

      // Cross-update: preDilutionFlow = (10/3) * citrate * bloodFlow
      preDilutionFlowParam.value =
          (10.0 / 3.0) * citrateParam.value * bloodFlowParam.value;

      _isUpdating = false;
      notifyListeners();
    } else {
      // If we're already updating, just update the param
      citrateParam.value = newValue;
    }
  }

  // ---------------------------------------------------------
  // 2) PRE-DILUTION
  //    Moved logic from _onPreDilutionChanged.
  // ---------------------------------------------------------
  void setPreDilutionFlow(double newValue) {
    if (!_isUpdating) {
      _isUpdating = true;

      preDilutionFlowParam.value = newValue;

      if (isCitrateLocked) {
        bloodFlowParam.value =
            preDilutionFlowParam.value / ((10.0 / 3.0) * citrateParam.value);
      } else {
        citrateParam.value =
            preDilutionFlowParam.value / ((10.0 / 3.0) * bloodFlowParam.value);
      }

      _isUpdating = false;
      notifyListeners();
    } else {
      preDilutionFlowParam.value = newValue;
    }
  }

  // ---------------------------------------------------------
  // 3) BLOOD FLOW
  //    Moved logic from _onBloodFlowChanged.
  // ---------------------------------------------------------
  void setBloodFlow(double newValue) {
    if (!_isUpdating) {
      _isUpdating = true;

      bloodFlowParam.value = newValue;

      if (isCitrateLocked) {
        preDilutionFlowParam.value =
            (10.0 / 3.0) * citrateParam.value * bloodFlowParam.value;
      } else {
        if (bloodFlowParam.value != 0) {
          citrateParam.value =
              preDilutionFlowParam.value /
              ((10.0 / 3.0) * bloodFlowParam.value);
        } else {
          citrateParam.value = 0.0;
        }
      }

      _isUpdating = false;
      notifyListeners();
    } else {
      bloodFlowParam.value = newValue;
    }
  }

  // ---------------------------------------------------------
  // 4) For the rest, we don't have cross-updates. So we just
  //    create simple set-helpers to notify the UI.
  // ---------------------------------------------------------
  void setDialysateFlow(double newValue) {
    dialysateFlowParam.value = newValue;
    notifyListeners();
  }

  void setFluidRemoval(double newValue) {
    fluidRemovalParam.value = newValue;
    notifyListeners();
  }

  void setPostDilutionFlow(double newValue) {
    postDilutionFlowParam.value = newValue;
    notifyListeners();
  }

  // ---------------------------------------------------------
  // 5) Load preset
  // ---------------------------------------------------------
  void loadDialysispreset(DialysisPreset preset) {
    setCitrate(3);
    isCitrateLocked = true;
    preset.setWeight(idealWeight());
    setBloodFlow(preset.suggestedBloodFlow());
    setDialysateFlow(preset.suggestedDialysateFlow());
    setFluidRemoval(preset.suggestedFluidRemoval());

    setPostDilutionFlow(preset.suggestedPostdilutionFlow());
    setPreDilutionFlow(preset.suggestedPredilutionFlow());
  }

  // ---------------------------------------------------------
  // 6) Accessors for weight, hematocrit, locked, etc.
  // ---------------------------------------------------------
  double get weight => _weight;
  set weight(double val) {
    if (_weight != val) {
      _weight = val;
      notifyListeners();
    }
  }

  double get bmi => weight / (patientLength * patientLength / 10000);

  double get patientLength => _length;
  set patientLength(double val) {
    if (_length != val) {
      _length = val;
      notifyListeners();
    }
  }

  double idealWeight() {
    if (bmi < 25) {
      return weight;
    }

    var idealWeight =
        (patientLength - 100) + 0.25 * (weight - (patientLength - 100));

    return idealWeight;
  }

  double get hematocritLevel => _hematocritLevel;
  set hematocritLevel(double val) {
    if (_hematocritLevel != val) {
      _hematocritLevel = val;
      notifyListeners();
    }
  }

  bool get isCitrateLocked => _isCitrateLocked;
  set isCitrateLocked(bool val) {
    if (_isCitrateLocked != val) {
      _isCitrateLocked = val;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------
  // 7) Derived computations
  // ---------------------------------------------------------
  double get dose {
    final bfPerHour = bloodFlowParam.value * 60;
    final plasmaFraction = 1 - _hematocritLevel;
    final dilutionFactor =
        (bfPerHour * plasmaFraction) /
        (bfPerHour * plasmaFraction + preDilutionFlowParam.value);

    final numerator =
        (preDilutionFlowParam.value +
            dialysateFlowParam.value +
            postDilutionFlowParam.value +
            fluidRemovalParam.value) *
        dilutionFactor;

    final denominator = idealWeight();
    if (denominator == 0) return 0.0;
    return numerator / denominator;
  }

  double get filtrationFraction {
    final qpl = bloodFlowParam.value * 60 * (1 - _hematocritLevel);
    final quf =
        preDilutionFlowParam.value +
        postDilutionFlowParam.value +
        fluidRemovalParam.value;

    return quf / (qpl + preDilutionFlowParam.value);
  }

  String? get doseWarning {
    if (dose < 20.0)
      return 'Låg dialysdos. Kontrollera att patienten är väldialyserad.';
    if (dose > 35.0)
      return 'Hög dialysdos. Kontrollera att patienten inte överdialyseras. Patienter med sepsis och/eller leversvikt kan behöva betydligt högre doser.';
    return null;
  }

  String? get filtrationFractionWarning {
    final ff = filtrationFraction;
    if (ff < 0.2) return 'Filtration fraction is too low!';
    if (ff > 0.8) return 'Filtration fraction is too high!';
    return null;
  }
}
