import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/dialysis/dialysis_info_view.dart';
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
  DialysisPreset? selectedPreset;


  _showDialysisInfoView(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DialysisInfoView()));
  }

  Future<void> _showPresetSelectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return ChangeNotifierProvider.value(
          value: Provider.of<DialysisViewModel>(context, listen: false),
          child: Dialog(
            child: Container(
              width: double.infinity,
              height: 300,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Välj startförslag',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: presets.length,
                      itemBuilder: (ctx, index) {
                        final preset = presets[index];
                        return ListTile(
                          title: Text(preset.label),
                          onTap: () {
                            context.read<DialysisViewModel>().loadDialysispreset(preset);
                            setState(() {
                              selectedPreset = preset;
                            });
                            Navigator.of(dialogContext).pop();
                          },
                        );
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Avbryt'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Future<void> _showInputDialog(BuildContext context, String title, String hintText, double currentValue, Function(double) onSubmit) async {
    final controller = TextEditingController(text: currentValue.toStringAsFixed(1));
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(hintText: hintText, border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Avbryt')),
            TextButton(
              onPressed: () {
                final parsed = double.tryParse(controller.text);
                if (parsed != null && parsed >= 0 && parsed <= 300) {
                  onSubmit(parsed);
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
        appBar: AppBar(title: const Text('Dialysberäkning'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showDialysisInfoView(context),
          ),
        ],
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
                              _buildWeightHematocritSection(context, model, textStyle),
                              ElevatedButton(
                                onPressed: () => _showPresetSelectionDialog(context),
                                child: Text('Välj startförslag'),
                              ),
                              _buildParameterSliders(model),
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
                _buildFooter(context, model),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWeightHematocritSection(BuildContext context, DialysisViewModel model, TextStyle? textStyle) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableText(context, 'Vikt (kg)', '${model.weight.toStringAsFixed(0)} kg', () => _showInputDialog(context, 'Vikt', 'Ange patientvikt', model.weight, (value) => model.weight = value), textStyle),
          const SizedBox(width: 50),
          _buildEditableText(context, 'Hematokritnivå (%)', '${(model.hematocritLevel * 100).toStringAsFixed(1)} %', () => _showInputDialog(context, 'Ange hematokrit (%)', 'Ange hematokrit % (0–100)', model.hematocritLevel * 100, (value) => model.hematocritLevel = value / 100), textStyle),
          Expanded(child: SizedBox()), // Align trailing to the right
        ],
      ),
    );
  }

  Widget _buildEditableText(BuildContext context, String label, String value, VoidCallback onEdit, TextStyle? textStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textStyle),
        Row(
          children: [
            Text(value, style: textStyle),
            const SizedBox(width: 8),
            IconButton(icon: const Icon(Icons.edit, color: Colors.lightBlue), onPressed: onEdit),
          ],
        ),
      ],
    );
  }

  Widget _buildParameterSliders(DialysisViewModel model) {
    return Column(
      children: [
        ParameterSlider(
          label: 'Citratnivå',
          parameterSelector: (vm) => vm.citrateParam,
          onChanged: (vm, newVal) => vm.setCitrate(newVal),
          interval: 0.5,
          stepSize: 0.5,
          showTicks: true,
          trailing: const CitrateSwitch(),
        ),
        const SizedBox(height: 5),
        ParameterSlider(
          label: 'Blodflöde (ml/min)',
          parameterSelector: (vm) => vm.bloodFlowParam,
          onChanged: (vm, newVal) => vm.setBloodFlow(newVal),
          interval: 25,
          stepSize: 5,
          showTicks: true,
          thumbColor: model.isCitrateLocked ? Colors.orange : null,
        ),
        const SizedBox(height: 5),
        ParameterSlider(
          label: 'Predilutionsflöde (ml/h)',
          parameterSelector: (vm) => vm.preDilutionFlowParam,
          onChanged: (vm, newVal) => vm.setPreDilutionFlow(newVal),
          interval: 500,
          stepSize: 50,
          showTicks: true,
          thumbColor: model.isCitrateLocked ? Colors.orange : null,
        ),
        const SizedBox(height: 5),
        ParameterSlider(
          label: 'Vätskeborttag (ml/h)',
          parameterSelector: (vm) => vm.fluidRemovalParam,
          onChanged: (vm, newVal) => vm.setFluidRemoval(newVal),
          interval: 100,
          stepSize: 25,
          showTicks: true,
        ),
        const SizedBox(height: 5),
        ParameterSlider(
          label: 'Dialysatflöde (ml/h)',
          parameterSelector: (vm) => vm.dialysateFlowParam,
          onChanged: (vm, newVal) => vm.setDialysateFlow(newVal),
          interval: 250,
          stepSize: 50,
          showTicks: true,
        ),
        const SizedBox(height: 8),
        ParameterSlider(
          label: 'Postdilutionsflöde (ml/h)',
          parameterSelector: (vm) => vm.postDilutionFlowParam,
          onChanged: (vm, newVal) => vm.setPostDilutionFlow(newVal),
          interval: 500,
          stepSize: 100,
          showTicks: true,
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, DialysisViewModel model) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top:10 ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Dialysdos (ml/kg/h): ${model.dose.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Visibility(
                visible: model.doseWarning != null,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Varning'),
                                content: Text(model.doseWarning ?? ''),
                                actions: [
                                  TextButton(
                                    onPressed: Navigator.of(context).pop,
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
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Filtrationsfraktion: ${(model.filtrationFraction * 100).toStringAsFixed(2)}%',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
