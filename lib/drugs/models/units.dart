abstract class SubstanceUnit<T extends SubstanceUnit<T>> {
  int conversionFactor(T unit);
  int get factor;
}

enum MolarUnit implements SubstanceUnit<MolarUnit> {
  mmol(factor: 1000),
  mol(factor: 1);

  @override
  final int factor;

  const MolarUnit({required this.factor});

  @override
  int conversionFactor(MolarUnit unit) {
    return (unit.factor / factor).round();
  }

  @override
  String toString() {
    return name;
  }
}

enum MassUnit implements SubstanceUnit<MassUnit> {
  mg(factor: 1000),
  g(factor: 1),
  ng(factor: 1000000000),
  microg(factor: 1000000);

  @override
  final int factor;

  const MassUnit({required this.factor});

  @override
  int conversionFactor(MassUnit unit) {
    return (unit.factor / factor).round();
  }

  @override
  String toString() {
    return this == microg ? "μg" : name;
  }
}

enum VolumeUnit implements SubstanceUnit<VolumeUnit> {
  ml(factor: 1),
  l(factor: 1000);

  @override
  final int factor;

  const VolumeUnit({required this.factor});

  @override
  int conversionFactor(VolumeUnit unit) {
    return (unit.factor / factor).round();
  }

  @override
  String toString() {
    return name;
  }
}
enum DiluentUnit{
  ml,
  l
}

enum TimeUnit {
  h (factor: 24),
  min (factor: 1440),
  d (factor: 1);


  final int factor;

  @override
  String toString() {
      return name;
  }

  const TimeUnit({required this.factor});
}


