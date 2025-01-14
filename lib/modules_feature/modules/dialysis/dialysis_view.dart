import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:hane/ui_components/scroll_indicator.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_view_model.dart';


class DialysisView extends StatefulWidget {
  @override
  State<DialysisView> createState() => _DialysisViewState();
}

class _DialysisViewState extends State<DialysisView> {
  final ScrollController _scrollController = ScrollController();

  /// Utility method to show a dialog for editing weight
  Future<void> _showWeightDialog(BuildContext context, double currentWeight) async {
    final controller = TextEditingController(text: currentWeight.toStringAsFixed(1));

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Vikt'),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Ange patientvikt',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Avbryt'),
            ),
            TextButton(
              onPressed: () {
                final parsed = double.tryParse(controller.text);
                if (parsed != null && parsed >= 0 && parsed <= 300) {
                  context.read<DialysisViewModel>().weight = parsed;
                  Navigator.of(ctx).pop(); // Close dialog
                }
              },
              child: const Text('Ställ in'),
            ),
          ],
        );
      },
    );
  }

  /// Utility method to show a dialog for editing hematocrit
  Future<void> _showHematocritDialog(BuildContext context, double currentHct) async {
    // Convert [0.0–1.0] to [0–100] for user input
    final controller = TextEditingController(text: (currentHct * 100).toStringAsFixed(1));

    await showDialog(

      context: context,

      builder: (ctx) {
        return AlertDialog(

          title: const Text('Ange hematokrit (%)'),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Ange hematokrit % (0–100)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Avbryt'),
            ),
            TextButton(
              onPressed: () {
                final parsed = double.tryParse(controller.text);
                if (parsed != null && parsed >= 0 && parsed <= 100) {
                  // Convert [0–100] back to [0.0–1.0] range
                  context.read<DialysisViewModel>().hematocritLevel = parsed / 100.0;
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Ställ in'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DialysisViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dialysberäkning'),
        ),
        body: Consumer<DialysisViewModel>(
          builder: (context, model, child) {
            final textStyle = Theme.of(context).textTheme.bodyLarge;

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
                              // Weight Display & Edit Button
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    // Display the current weight
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Vikt (kg)', style: textStyle),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              "${model.weight.toStringAsFixed(0)} kg",
                                              style: textStyle,
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () => _showWeightDialog(
                                                context,
                                                model.weight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 50),
                                    // Hematocrit Display & Edit Button
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Hematokritnivå (%)', style: textStyle),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                            "${ (model.hematocritLevel * 100)
                                                  .toStringAsFixed(1)} %",
                                              style: textStyle,
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () => _showHematocritDialog(
                                                context,
                                                model.hematocritLevel,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
                                  const Expanded(child: SizedBox()),
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
                                stepSize: 0.5,
                                onChanged: (dynamic value) {
                                  model.citrateLevel = value;
                                },
                              ),
                              const SizedBox(height: 5),

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
                                thumbIcon: Container(
                                  decoration: BoxDecoration(
                                    color: model.isCitrateLocked
                                        ? Colors.orange
                                        : null, // set your desired color
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                stepSize: 5,
                                showTicks: true,
                                onChanged: (dynamic value) {
                                  model.bloodFlow = value;
                                },
                              ),
                              const SizedBox(height: 5),

                              // Pre-Dilution Flow Input (SfSlider)
                              Text(
                                'Predilutionsflöde (ml/h): ${model.preDilutionFlow.toStringAsFixed(1)}',
                                style: textStyle,
                              ),
                              SfSlider(
                                min: 500.0,
                                max: 3000.0,
                                value: model.preDilutionFlow.clamp(500.0, 3000.0),
                                interval: 500,
                                showTicks: true,
                                thumbIcon: Container(
                                  decoration: BoxDecoration(
                                    color: model.isCitrateLocked
                                        ? Colors.orange
                                        : null, // set your desired color
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                stepSize: 50,
                                onChanged: (dynamic value) {
                                  model.preDilutionFlow = value;
                                },
                              ),
                              const SizedBox(height: 5),

                              // Fluid Removal Input (SfSlider)
                              Text(
                                'Vätskeborttag (ml/h): ${model.fluidRemoval.toStringAsFixed(1)}',
                                style: textStyle,
                              ),
                              SfSlider(
                                min: 0.0,
                                max: 500.0,
                                value: model.fluidRemoval.clamp(0.0, 500.0),
                                interval: 100,
                                showTicks: true,
                                stepSize: 25,
                                onChanged: (dynamic value) {
                                  model.fluidRemoval = value;
                                },
                              ),
                              const SizedBox(height: 5),

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
                                stepSize: 50,
                                onChanged: (dynamic value) {
                                  model.dialysateFlow = value;
                                },
                              ),
                              const SizedBox(height: 8),

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
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Filtrationsfraktion: ${(model.filtrationFraction * 100).toStringAsFixed(2)}%',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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