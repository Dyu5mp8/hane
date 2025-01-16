import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_preset.dart';
import 'package:hane/modules_feature/modules/dialysis/models/presets/standard_dialysis_preset_civa.dart';
import 'package:hane/modules_feature/modules/dialysis/parameter_slider.dart';
import 'package:hane/ui_components/blinking_icon.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:hane/ui_components/scroll_indicator.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_view_model.dart';
import 'package:hane/modules_feature/modules/dialysis/models/presets/standard_dialysis_preset.dart';

class DialysisView extends StatefulWidget {
  @override
  State<DialysisView> createState() => _DialysisViewState();
}

class _DialysisViewState extends State<DialysisView> {
  final ScrollController _scrollController = ScrollController();

  final List<DialysisPreset> presets = [
    StandardDialysisPreset(weight: 70, label: "Standard (Baxter)"),
    CivaStandardDialysisPreset(weight: 70, label: "Standard (Civa)")
  ];

  Future<void> _showWeightDialog(
    BuildContext context,
    double currentWeight,
  ) async {
    final controller =
        TextEditingController(text: currentWeight.toStringAsFixed(1));

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

  Future<void> _showHematocritDialog(
    BuildContext context,
    double currentHct,
  ) async {
    final controller = TextEditingController(
      text: (currentHct * 100).toStringAsFixed(1),
    );

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
                  context.read<DialysisViewModel>().hematocritLevel =
                      parsed / 100.0;
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

  DialysisPreset? selectedPreset;
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<DialysisPreset>(
                    hint: const Text('Välj preset'),
                    value: selectedPreset,
                    isExpanded: true,
                    items: presets.map((preset) {
                      return DropdownMenuItem<DialysisPreset>(
                        value: preset,
                        child: Text(preset.label),
                      );
                    }).toList(),
                    onChanged: (preset) {
                      if (preset != null) {
                        setState(() {
                          selectedPreset = preset;
                        });

                        // Load selected preset using the current weight
                        model.loadDialysispreset(preset);
                      }
                    },
                  ),
                ),
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
                              // Weight & Hematocrit Section
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Vikt (kg)', style: textStyle),
                                        Row(
                                          children: [
                                            Text(
                                              "${model.weight.toStringAsFixed(0)} kg",
                                              style: textStyle,
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.lightBlue),
                                              onPressed: () =>
                                                  _showWeightDialog(
                                                context,
                                                model.weight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 50),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Hematokritnivå (%)',
                                            style: textStyle),
                                        Row(
                                          children: [
                                            Text(
                                              "${(model.hematocritLevel * 100).toStringAsFixed(1)} %",
                                              style: textStyle,
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.lightBlue),
                                              onPressed: () =>
                                                  _showHematocritDialog(
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

                              // Sliders using ParameterSlider
                              ParameterSlider(
                                label: 'Citratnivå',
                                parameterSelector: (vm) => vm.citrateParam,
                                onChanged: (vm, newVal) =>
                                    vm.setCitrate(newVal),
                                interval: 0.5,
                                stepSize: 0.5,
                                showTicks: true,
                                trailing: const CitrateSwitch(),
                              ),
                              const SizedBox(height: 5),

                              ParameterSlider(
                                label: 'Blodflöde (ml/min)',
                                parameterSelector: (vm) => vm.bloodFlowParam,
                                onChanged: (vm, newVal) =>
                                    vm.setBloodFlow(newVal),
                                interval: 25,
                                stepSize: 5,
                                showTicks: true,
                                thumbColor: model.isCitrateLocked
                                    ? Colors.orange
                                    : null,
                              ),
                              const SizedBox(height: 5),

                              ParameterSlider(
                                label: 'Predilutionsflöde (ml/h)',
                                parameterSelector: (vm) =>
                                    vm.preDilutionFlowParam,
                                onChanged: (vm, newVal) =>
                                    vm.setPreDilutionFlow(newVal),
                                interval: 500,
                                stepSize: 50,
                                showTicks: true,
                                thumbColor: model.isCitrateLocked
                                    ? Colors.orange
                                    : null,
                              ),
                              const SizedBox(height: 5),

                              ParameterSlider(
                                label: 'Vätskeborttag (ml/h)',
                                parameterSelector: (vm) => vm.fluidRemovalParam,
                                onChanged: (vm, newVal) =>
                                    vm.setFluidRemoval(newVal),
                                interval: 100,
                                stepSize: 25,
                                showTicks: true,
                              ),
                              const SizedBox(height: 5),

                              ParameterSlider(
                                label: 'Dialysatflöde (ml/h)',
                                parameterSelector: (vm) =>
                                    vm.dialysateFlowParam,
                                onChanged: (vm, newVal) =>
                                    vm.setDialysateFlow(newVal),
                                interval: 250,
                                stepSize: 50,
                                showTicks: true,
                              ),
                              const SizedBox(height: 8),

                              ParameterSlider(
                                label: 'Postdilutionsflöde (ml/h)',
                                parameterSelector: (vm) =>
                                    vm.postDilutionFlowParam,
                                onChanged: (vm, newVal) =>
                                    vm.setPostDilutionFlow(newVal),
                                interval: 500,
                                stepSize: 100,
                                showTicks: true,
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: ScrollIndicator(
                            scrollController: _scrollController),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Consumer<DialysisViewModel>(
                    builder: (context, model, _) => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Dialysdos (ml/kg/h): ${model.dose.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Visibility(
                              visible: model.doseWarning != null,
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 24, // desired width
                                    height: 24, // desired height
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Varning'),
                                              content:
                                                  Text(model.doseWarning ?? ''),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      Navigator.of(context).pop,
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: BlinkingIcon(
                                          child: const Icon(
                                        FontAwesome.circle_exclamation_solid,
                                        size: 20,
                                        color: Colors.deepOrange,
                                      )), // Smaller icon size
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Filtrationsfraktion: ${(model.filtrationFraction * 100).toStringAsFixed(2)}%',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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
