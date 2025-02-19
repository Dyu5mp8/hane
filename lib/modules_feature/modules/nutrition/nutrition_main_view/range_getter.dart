import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/scale_zone.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

mixin RangeGetter {
  Color getRangeColor(ScaleZoneColor color) {
    switch (color) {
      case ScaleZoneColor.red:
        return const Color.fromARGB(255, 228, 107, 13);
      case ScaleZoneColor.yellow:
        return Colors.yellow;
      case ScaleZoneColor.green:
        return Colors.green;
    }
  }

  List<LinearGaugeRange> getLinearGaugeRanges(List<ScaleZone?> zones) {
    return zones.whereType<ScaleZone>().map((zone) {
      Color color = getRangeColor(zone.color);

      return LinearGaugeRange(
        startValue: zone.min,
        endValue: zone.max,
        color: color,
        startWidth: 10,
        endWidth: 10,
      );
    }).toList();
  }

  List<GaugeRange> getGaugeRanges(List<ScaleZone?> zones) {
    return zones.whereType<ScaleZone>().map((zone) {
      Color color = getRangeColor(zone.color);

      return GaugeRange(
        startValue: zone.min,
        endValue: zone.max,
        color: color,
        startWidth: 10,
        endWidth: 10,
      );
    }).toList();
  }
}
