import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TotalEnergyScale extends StatelessWidget {
  final double requirementValue = 2000; // e.g., fixed nutritional requirement

  final NutritionViewModel vm;

  TotalEnergyScale({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.all(20),
      child: SfLinearGauge(
        minimum: 0,
        maximum: 3000,
        orientation: LinearGaugeOrientation.horizontal,
        majorTickStyle: LinearTickStyle(length: 10),
        minorTickStyle: LinearTickStyle(length: 5),
        axisLabelStyle: TextStyle(fontSize: 10),
        interval: 500,

        // Custom widget pointer as a box with a downward pointer
        markerPointers: [
          LinearWidgetPointer(
            value: vm.totalProteinPerDay(),
            child: Transform.translate(
              offset: Offset(0, -20), // adjust offset to position above gauge
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The box containing the text
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "${vm.totalProteinPerDay()} kcal",
                      style: TextStyle(color: Colors.white, fontSize: 12),
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
      ),
    );
  }
}