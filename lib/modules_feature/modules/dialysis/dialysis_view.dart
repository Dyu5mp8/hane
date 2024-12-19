import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/ui_components/scroll_indicator.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_view_model.dart';
import 'package:provider/provider.dart';

class DialysisView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController(); // Added scroll controller

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DialysisViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dialysberäkning', style: TextStyle(fontSize: 18)),
        ),
        body: Consumer<DialysisViewModel>(
          builder: (context, model, child) {
            final textStyle = TextStyle(fontSize: 14);

            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0), // Reduced padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Weight Input
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
                              Text('Vikt (kg): ${model.weight.toStringAsFixed(1)}', style: textStyle),
                              Slider(
                                min: 40.0,
                                max: 150.0,
                                value: model.weight.clamp(40.0, 150.0),
                                onChanged: (value) {
                                  model.weight = value;
                                },
                              ),
                              SizedBox(height: 2),

                              // Hematokrit Level Input
                              Text('Hematokritnivå: ${(model.hematocritLevel * 100).toStringAsFixed(1)}%', style: textStyle),
                              Slider(
                                min: 0.20,
                                max: 0.60,
                                value: model.hematocritLevel.clamp(0.20, 0.60),
                                onChanged: (value) {
                                  model.hematocritLevel = value;
                                },
                              ),
                              SizedBox(height: 2),

                              // Citrate Level Input
                              Text('Citratnivå: ${model.citrateLevel.toStringAsFixed(1)}', style: textStyle),
                              Slider(
                                min: 1.0,
                                max: 4.0,
                                divisions: 6,
                                value: model.citrateLevel.clamp(1.0, 4.0),
                                onChanged: (value) {
                                  model.citrateLevel = value;
                                },
                              ),
                              SizedBox(height: 2),

                              // Blood Flow Input
                              Text('Blodflöde (ml/min): ${model.bloodFlow.toStringAsFixed(1)}', style: textStyle),
                              Slider(
                                min: 50.0,
                                max: 300.0,
                                value: model.bloodFlow.clamp(50.0, 300.0),
                                onChanged: (value) {
                                  model.bloodFlow = value;
                                },
                                thumbColor: model.isCitrateLocked ? Colors.orange : null,
                              ),
                              SizedBox(height: 2),

                              // Pre-Dilution Flow Input
                              Text('Predilutionsflöde (ml/h): ${model.preDilutionFlow.toStringAsFixed(1)}', style: textStyle),
                              Slider(
                                min: 500.0,
                                max: 3000.0,
                                value: model.preDilutionFlow.clamp(500.0, 3000.0),
                                onChanged: (value) {
                                  model.preDilutionFlow = value;
                                },
                                thumbColor: model.isCitrateLocked ? Colors.orange : null,
                              ),
                              SizedBox(height: 2),

                              // Fluid Removal Input
                              Text('Vätskeborttag (ml/h): ${model.fluidRemoval.toStringAsFixed(1)}', style: textStyle),
                              Slider(
                                min: 0.0,
                                max: 500.0,
                                value: model.fluidRemoval.clamp(0.0, 500.0),
                                onChanged: (value) {
                                  model.fluidRemoval = value;
                                },
                              ),
                              SizedBox(height: 2),

                              // Dialysate Flow Input
                              Text('Dialysatflöde (ml/h): ${model.dialysateFlow.toStringAsFixed(1)}', style: textStyle),
                              Slider(
                                min: 500.0,
                                max: 3000.0,
                                value: model.dialysateFlow.clamp(500.0, 3000.0),
                                onChanged: (value) {
                                  model.dialysateFlow = value;
                                  model.notifyListeners();
                                },
                              ),
                              SizedBox(height: 2),

                              // Post-Dilution Flow Input
                              Text('Postdilutionsflöde (ml/h): ${model.postDilutionFlow.toStringAsFixed(1)}', style: textStyle),
                              Slider(
                                min: 500.0,
                                max: 5000.0,
                                value: model.postDilutionFlow.clamp(500.0, 5000.0),
                                onChanged: (value) {
                                  model.postDilutionFlow = value;
                                  model.notifyListeners();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: ScrollIndicator(scrollController: _scrollController),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Reduced vertical padding
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