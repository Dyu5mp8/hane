import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hane/ui_components/scroll_indicator.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_view_model.dart';
import 'package:provider/provider.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
// Import Syncfusion sliders
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DialysisView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DialysisViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dialysberäkning'),
        ),
        body: Consumer<DialysisViewModel>(
          builder: (context, model, child) {
            final textStyle = TextStyle(fontSize: 14);

            // Create controllers with current values from the model
            final _weightController =
                TextEditingController(text: model.weight.toStringAsFixed(1));
            final _hematocritController = TextEditingController(
              text: (model.hematocritLevel * 100).toStringAsFixed(1),
            );

            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Weight Input (TextField)
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Vikt (kg)', style: textStyle),
                                        SizedBox(height: 4),
                                        Container(
                                          width: 100,
                                          height: 40,
                                          child: TextField(
                                            controller: _weightController,
                                            keyboardType:
                                                TextInputType.numberWithOptions(decimal: true),
                                            inputFormatters: [
                                              // Only allow digits and decimal point
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d{0,3}(\.\d{0,2})?$'),
                                              ),
                                            ],
                                            onSubmitted: (value) {
                                              final parsed = double.tryParse(value);
                                              // Validate parsed value (e.g., 0–300 kg)
                                              if (parsed != null && parsed >= 0 && parsed <= 300) {
                                                model.weight = parsed;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(
                                                vertical: 1,
                                                horizontal: 4,
                                              ),
                                              suffix: Text('kg'),
                                              border: OutlineInputBorder(),
                                            ),
                                            style: textStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 50),
                                    // Hematokrit Level Input (TextField)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Hematokritnivå (%)', style: textStyle),
                                        SizedBox(height: 4),
                                        Container(
                                          width: 100,
                                          height: 40,
                                          child: TextField(
                                            controller: _hematocritController,
                                            keyboardType:
                                                TextInputType.numberWithOptions(decimal: true),
                                            inputFormatters: [
                                              // Only allow digits and decimal point
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d{0,3}(\.\d{0,2})?$'),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              final parsed = double.tryParse(value);
                                              // If parsed is within 0–100, store it as 0.0–1.0
                                              if (parsed != null && parsed >= 0 && parsed <= 100) {
                                                model.hematocritLevel = parsed / 100.0;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(
                                                vertical: 1,
                                                horizontal: 4,
                                              ),
                                              suffix: Text('%'),
                                              border: OutlineInputBorder(),
                                            ),
                                            style: textStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 8),
                                  ],
                                ),
                              ),

                              // Citrate Level Input (SfSlider)
                              Row(
                                children: [
                                  Text(
                                    'Citratnivå: ${model.citrateLevel.toStringAsFixed(1)}',
                                    style: textStyle,
                                  ),
                                  Expanded(child: SizedBox()),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Behåll citrat konstant', style: textStyle),
                                      Transform.scale(
                                        scale: 0.7, // Slightly smaller switch
                                        child: Switch(
                                          value: model.isCitrateLocked,
                                          onChanged: (value) {
                                            model.isCitrateLocked = value;
                                          },
                                          activeTrackColor: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SfSlider(
                                min: 1.0,
                                max: 4.0,
                                value: model.citrateLevel.clamp(1.0, 4.0),
                                interval: 0.5,
                                showTicks: true,
                                showLabels: true,
                                stepSize: 0.5,
                                onChanged: (dynamic value) {
                                  model.citrateLevel = value;
                                },
                              ),
                              SizedBox(height: 5),

                              // Blood Flow Input (SfSlider)
                              Text(
                                'Blodflöde (ml/min): ${model.bloodFlow.toStringAsFixed(1)}',
                                style: textStyle,
                              ),
                              SfSlider(
                                min: 50.0,
                                max: 300.0,
                                value: model.bloodFlow.clamp(50.0, 300.0),
                                interval: 25,
                                showTicks: true,
                                showLabels: true,
                                stepSize: 5,
                                onChanged: (dynamic value) {
                                  model.bloodFlow = value;
                                },
                              ),
                              SizedBox(height: 5),

                              // Pre-Dilution Flow Input (SfSlider)
                              Text(
                                'Predilutionsflöde (ml/h): ${model.preDilutionFlow.toStringAsFixed(1)}',
                                style: textStyle,
                              ),
                              SfSlider(
                                min: 500.0,
                                max: 3000.0,
                                value: model.preDilutionFlow.clamp(500.0, 3000.0),
                                interval: 250,
                                showTicks: true,
                                showLabels: true,
                                stepSize: 50,
                                onChanged: (dynamic value) {
                                  model.preDilutionFlow = value;
                                },
                              ),
                              SizedBox(height: 5),

                              // Fluid Removal Input (SfSlider)
                              Text(
                                'Vätskeborttag (ml/h): ${model.fluidRemoval.toStringAsFixed(1)}',
                                style: textStyle,
                              ),
                              SfSlider(
                                min: 0.0,
                                max: 500.0,
                                value: model.fluidRemoval.clamp(0.0, 500.0),
                                interval: 25,
                                showTicks: true,
                                showLabels: true,
                                stepSize: 25,
                                onChanged: (dynamic value) {
                                  model.fluidRemoval = value;
                                },
                              ),
                              SizedBox(height: 5),

                              // Dialysate Flow Input (SfSlider)
                              Text(
                                'Dialysatflöde (ml/h): ${model.dialysateFlow.toStringAsFixed(1)}',
                                style: textStyle,
                              ),
                              SfSlider(
                                min: 500.0,
                                max: 3000.0,
                                value: model.dialysateFlow.clamp(500.0, 3000.0),
                                interval: 250,
                                showTicks: true,
                                showLabels: true,
                                stepSize: 50,
                                onChanged: (dynamic value) {
                                  model.dialysateFlow = value;
                                },
                              ),
                              SizedBox(height: 8),

                              // Post-Dilution Flow Input (SfSlider)
                              Text(
                                'Postdilutionsflöde (ml/h): ${model.postDilutionFlow.toStringAsFixed(1)}',
                                style: textStyle,
                              ),
                              SfSlider(
                                min: 500.0,
                                max: 5000.0,
                                value: model.postDilutionFlow.clamp(500.0, 5000.0),
                                interval: 500,
                                showTicks: true,
                                showLabels: true,
                                stepSize: 100,
                                onChanged: (dynamic value) {
                                  model.postDilutionFlow = value;
                                  model.notifyListeners();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Scroll Indicator
                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: ScrollIndicator(scrollController: _scrollController),
                      ),
                    ],
                  ),
                ),

                // Bottom section with computed fields
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Text(
                        'Dialysdos (ml/kg/h): ${model.dose.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Filtrationsfraktion: ${(model.filtrationFraction * 100).toStringAsFixed(2)}%',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}