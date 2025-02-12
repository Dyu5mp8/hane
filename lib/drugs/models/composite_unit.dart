import 'package:hane/drugs/models/units.dart';

class CompositeUnit {

  SubstanceUnit unit;
  int? weight;
  DiluentUnit? diluentUnit;

  CompositeUnit({required this.unit, this.weight, this.diluentUnit});

  CompositeUnit weightConverted(int weight) {
    return CompositeUnit(unit: unit, weight: null, diluentUnit: diluentUnit);
  }

  CompositeUnit diluentUnitConverted(DiluentUnit diluentUnit) {
    return CompositeUnit(unit: unit, weight: weight, diluentUnit: null);
  }


}