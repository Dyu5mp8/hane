import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/range_getter.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/scale_zone.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TotalProteinScale extends StatelessWidget with RangeGetter {
  final double requirementValue = 2000; // e.g., fixed nutritional requirement

  final NutritionViewModel vm;

  TotalProteinScale({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.all(20),
      child: SfLinearGauge(
        minimum: 0,
        maximum: 200,
        orientation: LinearGaugeOrientation.horizontal,
        majorTickStyle: LinearTickStyle(length: 10),
        axisLabelStyle: TextStyle(fontSize: 10),
        interval: 50,

        // Custom widget pointer as a box with a downward pointer
        markerPointers: [
          LinearWidgetPointer(
            value: vm.totalProteinPerDay(),
            child: Transform.translate(
              offset: Offset(0, -30), // adjust offset to position above gauge
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The box containing the text
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),

                    child: Text(
                      "Proteininnehåll ${vm.totalProteinPerDay().toStringAsFixed(0)} g",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // A small triangle pointing downwards
                  Icon(
                    Icons.arrow_drop_down,
                    size: 16,
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
        ranges: getLinearGaugeRanges(vm.getProteinScaleZones()),
      ),
    );
  }
}
