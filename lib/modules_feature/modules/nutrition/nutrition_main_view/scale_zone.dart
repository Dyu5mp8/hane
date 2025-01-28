enum ScaleZoneColor {
  red,
  yellow,
  green
}

class ScaleZone {
  final double minPerWeight;
  final double maxPerWeight;
  final ScaleZoneColor color;
  double weight;


  ScaleZone({required this.weight, required this.minPerWeight, required this.maxPerWeight, required this.color});


  double get min => minPerWeight * weight;
  double get max => maxPerWeight * weight;

}
