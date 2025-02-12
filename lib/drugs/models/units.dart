
// --- SubstanceUnit Interface ---
abstract class SubstanceUnit with CandidateFinderMixin {
  double conversionFactor(SubstanceUnit unit);
  double get factor;

  String get unitType;

  static SubstanceUnit fromString(String unit) {
    switch (unit) {
      case 'mmol': return MolarUnit.mmol;
      case 'mol':  return MolarUnit.mol;
      case 'ml':   return VolumeUnit.ml;
      case 'l':    return VolumeUnit.l;
      case 'mg':   return MassUnit.mg;
      case 'g':    return MassUnit.g;
      case 'μg':
      case 'microg':
      case 'mikrog': return MassUnit.microg;
      case 'E':    return UnitUnit.E;
      case 'FE':   return UnitUnit.E;
      case 'mE':   return UnitUnit.mE;
      default: throw Exception('Felaktig enhet: $unit');
    }
  }

    static List<SubstanceUnit> get allUnits => [
        ...MassUnit.values,
        ...MolarUnit.values,
        ...VolumeUnit.values,
      ];

@override 
  String toString();
}

// --- CandidateFinderMixin with Sorting Helper ---
mixin CandidateFinderMixin {
  List<SubstanceUnit> get candidates;

  List<SubstanceUnit> get sortedByFactor => _sortUnits(candidates);

  List<SubstanceUnit> _sortUnits(List<SubstanceUnit> units) {
    final sorted = List<SubstanceUnit>.from(units);
    sorted.sort((a, b) => a.factor.compareTo(b.factor));
    return sorted;
  }

  double conversionFactor(SubstanceUnit unit);

  SubstanceUnit? findCandidateByIdealFactor(double amount, double threshold) {
    if (amount < threshold) {
      for (final candidate in sortedByFactor) {
        final conv = conversionFactor(candidate);
        if (amount * conv >= threshold) return candidate;
      }
      return sortedByFactor.last;
    } else if (amount > threshold) {
      SubstanceUnit? candidateBeforeUnder;
      for (final candidate in sortedByFactor.reversed) {
        final conv = conversionFactor(candidate);
        final newAmount = amount * conv;
        if (newAmount < threshold) {
          return candidateBeforeUnder ?? candidate;
        }
        candidateBeforeUnder = candidate;
      }
      return candidateBeforeUnder;
    }
    return null;
  }
}

// --- MolarUnit Example ---
enum MolarUnit with CandidateFinderMixin implements SubstanceUnit {
  mmol(1000),
  mol(1);

  @override
  final double factor;
  const MolarUnit(this.factor);

  @override
  double conversionFactor(SubstanceUnit unit) {
    if (unit is MolarUnit) {
      return unit.factor / factor;
    }
    throw Exception("Incompatible unit type for MolarUnit conversion");
  }

  @override
  List<SubstanceUnit> get candidates => MolarUnit.values;


  @override
  String get unitType => 'molar';

  @override
  String toString() => name;
}
enum WeightUnit
{
 kg;

  @override
  String toString() => name;

  static WeightUnit fromString(String unit) {
    switch (unit) {
      case 'kg':
        return WeightUnit.kg;
      default:
        throw Exception('Felaktig enhet: $unit');
    }
  }
}


enum VolumeUnit with CandidateFinderMixin implements SubstanceUnit {
  ml(1000),
  l(1);

  @override
  final double factor;

  const VolumeUnit(this.factor);

  @override
  double conversionFactor(SubstanceUnit unit) {
    if (unit is VolumeUnit) {
      return unit.factor / factor;
    }
    throw Exception("Incompatible unit type for VolumeUnit conversion");
  }

  @override
  String get unitType => 'volume';


 @override
 List<SubstanceUnit> get candidates => VolumeUnit.values;

  @override
  String toString() => name;
}

enum UnitUnit with CandidateFinderMixin implements SubstanceUnit {
  E(1),
  mE(1000),;


  @override
  double conversionFactor(SubstanceUnit unit) {
    if (unit is UnitUnit) {
      return unit.factor / factor;
    }
    throw Exception("Incompatible unit type for UnitUnit conversion");
  }

  @override
  final double factor;

  const UnitUnit(this.factor);

  @override
  List<SubstanceUnit> get candidates =>  UnitUnit.values;

  @override
  String get unitType => 'unit';

  @override
  String toString() => name;

  static UnitUnit fromString(String unit) {
    switch (unit) {
      case 'E':
        return UnitUnit.E;
      case 'FE':
        return UnitUnit.E;
      default:
        throw Exception('Felaktig enhet: $unit');
    }
  }
}


enum MassUnit with CandidateFinderMixin implements SubstanceUnit {
  mg(1000),
  g(1),
  microg(1000000);

  @override
  final double factor;

  const MassUnit(this.factor);

  @override
  double conversionFactor(SubstanceUnit unit) {
    if (unit is MassUnit) {
      return unit.factor / factor;
    }
    throw Exception("Incompatible unit type for MassUnit conversion");
  }

  @override
  List<SubstanceUnit> get candidates => MassUnit.values;

  @override
  String get unitType => 'mass';
  
  @override
  String toString() {
    return this == MassUnit.microg ? "μg" : name;
  }
}

enum DiluentUnit {
  ml(factor: 1000, volumeUnit: VolumeUnit.ml),
  l(factor: 1, volumeUnit: VolumeUnit.l);

  final double factor;
  final VolumeUnit volumeUnit;

  const DiluentUnit({required this.factor, required this.volumeUnit});

  double conversionFactor(DiluentUnit unit) {
    return unit.factor / factor;
  }

  @override
  String toString() => name;

  static DiluentUnit fromString(String unit) {
    switch (unit) {
      case 'ml':
        return DiluentUnit.ml;
      case 'l':
        return DiluentUnit.l;
      default:
        throw Exception('Felaktig enhet: $unit');
    }
  }

  VolumeUnit volumeFromDiluent() => volumeUnit;
}

enum TimeUnit {


  h(factor: 24),
  min(factor: 1440),
  d(factor: 1);

  final int factor;


  const TimeUnit({required this.factor});

  @override
  String toString() => name;

  static TimeUnit fromString(String unit) {
    switch (unit) {
      case 'h':
        return TimeUnit.h;
      case 'min':
        return TimeUnit.min;
      case 'd':
        return TimeUnit.d;
      default:
        throw Exception('Felaktig enhet: $unit');
    }
  }
}
