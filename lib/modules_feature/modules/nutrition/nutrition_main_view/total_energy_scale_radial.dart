import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TotalEnergyScaleRadial extends StatelessWidget {
  final double requirementValue = 2000; // e.g., fixed nutritional requirement

  final NutritionViewModel vm;

  TotalEnergyScaleRadial({required this.vm});

  @override
  Widget build(BuildContext context) {
    // Calculate the angle for the annotation based on value.
    // Assuming a full 360° sweep for simplicity.
    double gaugeValue = requirementValue; 
    double angle = (gaugeValue / 3000) * 360; 

    return Container(
      height: 300,
      
      padding: EdgeInsets.all(20),
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 3000,
            startAngle: 150,
            canScaleToFit:true,
            endAngle: 30,
            radiusFactor: 0.8,
            showLabels: true,
            
            showTicks: true,
            axisLineStyle: AxisLineStyle(
              thickness: 0.05,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[

              MarkerPointer(
                value: vm.totalKcalPerDay(),
                markerType: MarkerType.invertedTriangle,
                text: "${vm.totalKcalPerDay()} kcal",
                textStyle: GaugeTextStyle(fontSize: 12),
                markerOffset: -10,
                color: Colors.blueAccent,
                markerWidth: 14,
                markerHeight: 14,
              ),

              MarkerPointer(
                value: vm.totalKcalPerDay(),
                markerType: MarkerType.text,
                text: "Beräknat kaloribehov\n${vm.totalKcalPerDay().toStringAsFixed(0)} kcal",
                textStyle: GaugeTextStyle(fontSize: 12),
                markerOffset: -40,
                color: Colors.blueAccent,
                markerWidth: 14,
                markerHeight: 14,
              ),

              NeedlePointer(
                value: vm.totalKcalPerDay(),
                needleLength: 0.8,
                lengthUnit: GaugeSizeUnit.factor,
                needleColor: Colors.redAccent,
                needleStartWidth: 1,
                needleEndWidth: 2,
                knobStyle: KnobStyle(knobRadius: 0.08),
              )
        

              // Primary marker pointer at the exact value
              

            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                // Place the custom widget near the pointer
                widget: Transform.translate(
                  offset: Offset(0, -20), // offset the widget vertically if needed
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Box with text
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "$requirementValue kcal",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      // Downward pointer (icon)
                      Icon(
                        Icons.arrow_drop_down,
                        size: 16,
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
                angle: angle,
                positionFactor: 1.2, 
                // positionFactor > 1 places the annotation outside the axis line
              ),
            ],
          ),
        ],
      ),
    );
  }
}