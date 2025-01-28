import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/range_getter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class TotalEnergyScaleRadial extends StatelessWidget with RangeGetter {
  final double requirementValue = 2000; // e.g., fixed nutritional requirement

  final NutritionViewModel vm;

  TotalEnergyScaleRadial({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final needs = vm.calculateNeeds();

    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
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
            axisLineStyle: const AxisLineStyle(
              thickness: 0.05,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              MarkerPointer(
                value: needs,
                markerType: MarkerType.invertedTriangle,
                text: "${vm.totalKcalPerDay()} kcal",
                textStyle: const GaugeTextStyle(fontSize: 12),
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
                knobStyle: const KnobStyle(knobRadius: 0.08),
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
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "▼ Beräknat mål:\n ${needs.toStringAsFixed(0)} kcal",
                        style: const TextStyle(fontSize: 13),
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
