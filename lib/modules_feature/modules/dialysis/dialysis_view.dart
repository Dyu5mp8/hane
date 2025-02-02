import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/dialysis/dialysis_info_view.dart';
import 'package:hane/modules_feature/modules/dialysis/dialysis_patient_data_widget.dart';
import 'package:hane/modules_feature/modules/dialysis/dialysis_result.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_preset.dart';
import 'package:hane/modules_feature/modules/dialysis/models/presets/standard_dialysis_preset_civa.dart';
import 'package:hane/modules_feature/modules/dialysis/parameter_slider.dart';
import 'package:provider/provider.dart';
import 'package:hane/ui_components/scroll_indicator.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_view_model.dart';
import 'package:hane/modules_feature/modules/dialysis/models/presets/standard_dialysis_preset.dart';

class DialysisView extends StatefulWidget {
  const DialysisView({super.key});

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
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const DialysisInfoView()));
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
                            context
                                .read<DialysisViewModel>()
                                .loadDialysispreset(preset);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialysberäkning'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showDialysisInfoView(context),
          ),
        ],
      ),
      body: Consumer<DialysisViewModel>(
        builder: (context, model, child) {
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
                            DialysisPatientDataWidget(),
                            ElevatedButton(
                              onPressed: () =>
                                  _showPresetSelectionDialog(context),
                              child: const Text('Välj startförslag'),
                            ),
                            _buildParameterSliders(model),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      right: 15,
                      child:
                          ScrollIndicator(scrollController: _scrollController),
                    ),
                  ],
                ),
              ),
              const DialysisResult(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildParameterSliders(DialysisViewModel model) {
    return Consumer<DialysisViewModel>(
      builder: (context, model, child) {
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
      },
    );
  }
}
