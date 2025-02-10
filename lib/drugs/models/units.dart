abstract class SubstanceUnit<T extends SubstanceUnit<T>> with CandidateFinderMixin<T> {
  double conversionFactor(T unit);
  double get factor;
  
  static SubstanceUnit fromString(String unit) {
    switch (unit) {
      case 'mmol':
        return MolarUnit.mmol;
      case 'mol':
        return MolarUnit.mol;
      case 'ml':
        return VolumeUnit.ml;
      case 'l':
        return VolumeUnit.l;
      case 'mg':
        return MassUnit.mg;
      case 'g':
        return MassUnit.g;
      case 'ng':
        return MassUnit.ng;
      // You cannot use ('μg' || 'microg' || 'mikrog') in a case;
      // so you may want to use multiple cases:
      case 'μg':
      case 'microg':
      case 'mikrog':
        return MassUnit.microg;
      default:
        throw Exception('Felaktig enhet: $unit');
    }
  }
}
mixin CandidateFinderMixin<T extends SubstanceUnit<T>> {
  /// The mixing class must provide a sorted list of candidates.
  List<T> get sortedByFactor;
  
  /// The mixing class must implement a conversion method.
  double conversionFactor(T unit);
  
  T? findCandidateByIdealFactor(double amount, double threshold) {
    if (amount < threshold) {
      // Scaling up: iterate in ascending order.
      for (final candidate in sortedByFactor) {
        final conv = conversionFactor(candidate);
        if (amount * conv >= threshold) {
          print("Scaling up: returning $candidate");
          return candidate;
        }
      }
      print("Scaling up fallback: returning ${sortedByFactor.last}");
      return sortedByFactor.last;
    } else if (amount > threshold) {
      T? candidateBeforeUnder;
      // Scaling down: iterate in descending order.
      for (final candidate in sortedByFactor.reversed) {
        final conv = conversionFactor(candidate);
        final newAmount = amount * conv;
        print("Checking candidate $candidate: newAmount = $newAmount (threshold: $threshold)");
        if (newAmount < threshold) {
          if (candidateBeforeUnder != null) {
            print("Scaling down: returning previous candidate $candidateBeforeUnder");
            return candidateBeforeUnder;
          } else {
            print("Scaling down: first candidate already under threshold, returning $candidate");
            return candidate;
          }
        }
        candidateBeforeUnder = candidate;
      }
      print("Scaling down fallback: returning $candidateBeforeUnder");
      return candidateBeforeUnder;
    }
    return null;
  }
}

enum MolarUnit
    with CandidateFinderMixin<MolarUnit>
    implements SubstanceUnit<MolarUnit> {
  mmol(factor: 1000),
  mol(factor: 1);

  @override
  final double factor;

  const MolarUnit({required this.factor});

  @override
  double conversionFactor(MolarUnit unit) {
    return (unit.factor / factor);
  }

  @override
  String toString() {
    return name;
  }


  @override
  List<MolarUnit> get sortedByFactor =>
      List.of(MolarUnit.values)..sort((a, b) => a.factor.compareTo(b.factor));
}

enum VolumeUnit
    with CandidateFinderMixin<VolumeUnit>
    implements SubstanceUnit<VolumeUnit> {
  ml(factor: 1000),
  l(factor: 1);

  @override
  final double factor;

  const VolumeUnit({required this.factor});

  @override
  double conversionFactor(VolumeUnit unit) {
    return (unit.factor / factor);
  }


  @override
  String toString() {
    return name;
  }

  @override
  List<VolumeUnit> get sortedByFactor =>
      List.of(VolumeUnit.values)..sort((a, b) => a.factor.compareTo(b.factor));
}

enum WeightUnit { kg }

enum MassUnit
    with CandidateFinderMixin<MassUnit>
    implements SubstanceUnit<MassUnit> {
  mg(factor: 1000),
  g(factor: 1),
  ng(factor: 1000000000),
  microg(factor: 1000000);

  @override
  final double factor;

  const MassUnit({required this.factor});

  @override
  double conversionFactor(MassUnit unit) {
    (unit.factor / factor);
    return (unit.factor / factor);
  }

  @override
  String toString() {
    return this == microg ? "μg" : name;
  }

  @override
  List<MassUnit> get sortedByFactor =>
      List.of(MassUnit.values)..sort((a, b) => a.factor.compareTo(b.factor));
}

enum DiluentUnit {
  ml(factor: 1000, volumeUnit: VolumeUnit.ml),
  l(factor: 1, volumeUnit: VolumeUnit.l);

  final double factor;
  final VolumeUnit volumeUnit;

  const DiluentUnit({required this.factor, required this.volumeUnit});

  double conversionFactor(DiluentUnit unit) {
    return (unit.factor / factor);
  }

  @override
  String toString() {
    return name;
  }

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

  VolumeUnit volumeFromDiluent() {
    return volumeUnit;
  }
}

enum TimeUnit {
  h(factor: 24),
  min(factor: 1440),
  d(factor: 1);

  final int factor;

  @override
  String toString() {
    return name;
  }

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

  const TimeUnit({required this.factor});
}
