import 'package:flutter/foundation.dart';

class DialysisViewModel extends ChangeNotifier {
  // Private variables with initial values
  double _weight = 93.0; // ordinationsvikt
  double _postDilutionFlow = 1500.0; // postdilutionsflöde
  double _dialysateFlow = 1500.0; // dialysatflöde
  double _fluidRemoval = 0.0; // vätskeborttag
  double _hematocritLevel = 0.30; // hematokrit
  bool _isCitrateLocked = true;

  List<double> citrateSteps = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0];

  double _citrateLevel = 3.0;
  double _preDilutionFlow = 1000.0;
  double _bloodFlow = 100.0;

  bool _isUpdating = false;

  // Getter and setter for weight
  double get weight => _weight;
  set weight(double value) {
    if (_weight != value) {
      _weight = value;
      // Update related values when weight changes

      notifyListeners();
    }
  }

  // Getter and setter for postDilutionFlow
  double get postDilutionFlow => _postDilutionFlow;
  set postDilutionFlow(double value) {
    if (_postDilutionFlow != value) {
      _postDilutionFlow = value;
      notifyListeners();
    }
  }

  // Getter and setter for dialysateFlow
  double get dialysateFlow => _dialysateFlow;
  set dialysateFlow(double value) {
    if (_dialysateFlow != value) {
      _dialysateFlow = value;
      notifyListeners();
    }
  }

  // Getter and setter for fluidRemoval
  double get fluidRemoval => _fluidRemoval;
  set fluidRemoval(double value) {
    if (_fluidRemoval != value) {
      _fluidRemoval = value;
      notifyListeners();
    }
  }

  // Getter and setter for hematocritLevel
  double get hematocritLevel => _hematocritLevel;
  set hematocritLevel(double value) {
    if (_hematocritLevel != value) {
      _hematocritLevel = value;
      notifyListeners();
    }
  }

  // Getter and setter for isCitrateLocked
  bool get isCitrateLocked => _isCitrateLocked;
  set isCitrateLocked(bool value) {
    if (_isCitrateLocked != value) {
      _isCitrateLocked = value;
      notifyListeners();
    }
  }

  // Getter and setter for citrateLevel
  double get citrateLevel => _citrateLevel;
  set citrateLevel(double value) {
    if (value != _citrateLevel) {
      _citrateLevel = value;
      if (!_isUpdating) {
        _isUpdating = true;
        preDilutionFlow = (10.0 / 3.0) * _citrateLevel * _bloodFlow;
        _isUpdating = false;
      }
      notifyListeners();
    }
  }

  // Getter and setter for preDilutionFlow
  double get preDilutionFlow => _preDilutionFlow;
  set preDilutionFlow(double value) {
    if (value != _preDilutionFlow) {
      _preDilutionFlow = value;
      if (!_isUpdating) {
        _isUpdating = true;
        if (isCitrateLocked) {
          bloodFlow = _preDilutionFlow / ((10.0 / 3.0) * _citrateLevel);
        } else {
          citrateLevel = _preDilutionFlow / ((10.0 / 3.0) * _bloodFlow);
        }
        _isUpdating = false;
      }
      notifyListeners();
    }
  }

  // Getter and setter for bloodFlow
  double get bloodFlow => _bloodFlow;
  set bloodFlow(double value) {
    if (value != _bloodFlow) {
      _bloodFlow = value;
      if (!_isUpdating) {
        _isUpdating = true;
        if (isCitrateLocked) {
          preDilutionFlow = (10.0 / 3.0) * _citrateLevel * _bloodFlow;
        } else {
          if (_bloodFlow != 0) {
            citrateLevel = _preDilutionFlow / ((10.0 / 3.0) * _bloodFlow);
          } else {
            _citrateLevel = 0.0;
          }
        }
        _isUpdating = false;
      }
      notifyListeners();
    }
  }

  // Computed property for dose
  double get dose {
    double plasmaFraction = 1 - hematocritLevel;
    double bloodFlowPerHour = 60 * _bloodFlow;
    double dilutionFactor = (bloodFlowPerHour * plasmaFraction) /
        (bloodFlowPerHour * plasmaFraction + _preDilutionFlow);
    double numerator = (_preDilutionFlow +
            dialysateFlow +
            postDilutionFlow +
            fluidRemoval) *
        dilutionFactor;
    double denominator = weight;
    if (denominator == 0) return 0.0;
    return numerator / denominator;
  }

  // Computed property for filtrationFraction
  double get filtrationFraction {
    double qpl = _bloodFlow * 60 * (1 - hematocritLevel);
    double quf = _preDilutionFlow + postDilutionFlow + fluidRemoval;
    return quf / (qpl + _preDilutionFlow);
  }

}