import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/scale_zone.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TotalEnergyScaleRadial extends StatelessWidget {
  final double requirementValue = 2000; // e.g., fixed nutritional requirement

  final NutritionViewModel vm;

  TotalEnergyScaleRadial({required this.vm});

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

  @override
  Widget build(BuildContext context) {
    final needs = vm.calculateNeeds();

    return Container(
      height: 300,
      padding: EdgeInsets.all(20),
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 3000,
            startAngle: 150,
            canScaleToFit: true,
            endAngle: 30,
            radiusFactor: 0.8,
            showLabels: true,
            ranges: getGaugeRanges(vm.getCalorieScaleZones()),
            showTicks: true,
            axisLineStyle: AxisLineStyle(
              thickness: 0.05,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              MarkerPointer(
                value: needs,
                markerType: MarkerType.invertedTriangle,
                text: "${vm.totalKcalPerDay()} kcal",
                textStyle: GaugeTextStyle(fontSize: 12),
                markerOffset: -10,
                color: Colors.blueAccent,
                markerWidth: 14,
                markerHeight: 14,
              ),

              // MarkerPointer(
              //   value: needs,
              //   markerType: MarkerType.text,
              //   text: "Beräknat kaloribehov\n${vm.totalKcalPerDay().toStringAsFixed(0)} kcal",
              //   textStyle: GaugeTextStyle(fontSize: 12),
              //   markerOffset: -40,
              //   color: Colors.blueAccent,
              //   markerWidth: 14,
              //   markerHeight: 14,
              // ),

              NeedlePointer(
                enableDragging: true,
                value: vm.totalKcalPerDay(),
                needleLength: 0.8,
                lengthUnit: GaugeSizeUnit.factor,
                needleColor: Colors.redAccent,
                needleStartWidth: 1,
                needleEndWidth: 2,
                knobStyle: KnobStyle(knobRadius: 0.08),
                animationType: AnimationType.ease, // Smooth animation type
                animationDuration: 2000, // Duration f
              )

              // Primary marker pointer at the exact value
            ],
            annotations: [
             
              GaugeAnnotation(
                widget: Container(
                  child: Column(
                    children: [
                      Text(
                        "${vm.totalKcalPerDay().toStringAsFixed(0)} kcal (${(vm.totalKcalPerDay() / needs * 100).toStringAsFixed(0)}%)",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "▼ Beräknat mål:\n ${needs.toStringAsFixed(0)} kcal",
                        style: TextStyle(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                angle: 90,
                positionFactor: 1.2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
