import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dosage_dialog.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/ui_components/concentration_picker.dart';
import 'package:hane/drugs/drug_detail/dosage_view_handler.dart';
import 'package:hane/ui_components/conversion_button.dart';
import 'package:hane/ui_components/conversion_switch.dart';
import 'package:hane/ui_components/route_text.dart';
import 'package:hane/ui_components/time_picker.dart';
import 'package:hane/ui_components/weight_slider.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/models/units.dart';

class DosageSnippet extends StatefulWidget {
  final bool editMode;

  const DosageSnippet({super.key,  this.editMode = false});

  @override
  _DosageSnippetState createState() => _DosageSnippetState();
}

class _DosageSnippetState extends State<DosageSnippet> {
  final double _weightSliderValue = 70.0;

  void setConversionWeight(double weight) {
    setState(() {});
  }

  void _showWeightSlider(DosageViewHandler dvh) {
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return WeightSlider(
          initialWeight: _weightSliderValue,
          onWeightSet: (newWeight) {
            HapticFeedback.mediumImpact();
            dvh.conversionWeight = newWeight;
          },
        );
      },
    );
  }

  void _showConcentrationPicker(DosageViewHandler dvh) {
    final convertible = dvh.convertibleConcentrations;
    if (convertible == null) return;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ConcentrationPicker(
          concentrations: convertible,
          onConcentrationSet: (newConcentration) {
            HapticFeedback.mediumImpact();
            dvh.conversionConcentration = newConcentration;
          },
        );
      },
    );
  }

  void _showTimePicker(DosageViewHandler dvh) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext modalContext) {
        return TimePicker(
          initialTimeUnit: dvh.dose?.timeUnit,
          onTimeUnitSet: (TimeUnit unit) {
            HapticFeedback.mediumImpact();
            dvh.conversionTime = unit;
          },
        );
      },
    );
  }

  Color? activeColor() {
    return const Color.fromARGB(255, 254, 112, 56);
  }

  Color? inactiveColor() {
    return Theme.of(context).colorScheme.primary;
  }

  Text showDosage({
    Dose? dose,
    Dose? lowerLimitDose,
    Dose? higherLimitDose,
    Dose? maxDose,
    String? instruction,
    String? conversionInfo,
    Color? doseColor = Colors.black,
  }) {
    TextSpan buildDosageTextSpan({
      String? conversionInfo,
      String? instruction,
      Dose? dose,
      Dose? lowerLimitDose,
      Dose? higherLimitDose,
      Dose? maxDose,
    }) {
      final instructionSpan = TextSpan(
        text:
            (instruction != null && instruction.isNotEmpty)
                ? "${instruction.trimRight()}${RegExp(r'[.,:]$').hasMatch(instruction) ? '' : ':'} "
                : '',
      );

      final doseStyle = TextStyle(
        color: doseColor,
        fontWeight: FontWeight.bold,
      );
      final doseSpan = TextSpan(
        text: dose != null ? "$dose. " : '',
        style: doseStyle,
      );

      TextSpan doseRangeSpan() {
        if (lowerLimitDose != null && higherLimitDose != null) {
          return TextSpan(
            text:
                dose == null
                    ? '$lowerLimitDose - $higherLimitDose. '
                    : "($lowerLimitDose - $higherLimitDose). ",
            style: doseStyle,
          );
        }
        return const TextSpan(text: "");
      }

      final maxDoseSpan = TextSpan(
        text: maxDose != null ? "Maxdos: $maxDose." : '',
        style: doseStyle,
      );

      return TextSpan(
        children: [
          if (conversionInfo != null && conversionInfo.isNotEmpty)
            TextSpan(
              text: conversionInfo,
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          instructionSpan,
          doseSpan,
          doseRangeSpan(),
          maxDoseSpan,
        ],
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          buildDosageTextSpan(
            conversionInfo: conversionInfo,
            instruction: instruction,
            dose: dose,
            lowerLimitDose: lowerLimitDose,
            higherLimitDose: higherLimitDose,
            maxDose: maxDose,
          ),
        ],
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dvh = Provider.of<DosageViewHandler>(context, listen: true);

    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 0,
        bottom: 4,
      ),
      title: Column(
        spacing: 5,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (dvh.dosage.administrationRoute != null)
                RouteText(route: dvh.dosage.administrationRoute!),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: showDosage(
                  dose: dvh.startDose,
                  lowerLimitDose: dvh.startLowerLimitDose,
                  higherLimitDose: dvh.startHigherLimitDose,
                  maxDose: dvh.startMaxDose,
                  instruction: dvh.dosage.instruction,
                  doseColor: inactiveColor(),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Row(
                    children: [
                      if (!widget.editMode && dvh.canConvertWeight())
                        ConversionButton(
                          label: "kg",
                          isActive: dvh.conversionWeight != null,
                          onPressed: () {
                            if (dvh.conversionWeight == null) {
                              _showWeightSlider(dvh);
                            } else {
                              dvh.conversionWeight = null;
                              dvh.conversionConcentration = null;
                            }
                          },
                        ),
                      const SizedBox(width: 5),
                      if (!widget.editMode && dvh.canConvertTime())
                        ConversionButton(
                          label: "t",
                          isActive: dvh.conversionTime != null,
                          onPressed: () {
                            if (dvh.conversionTime == null) {
                              _showTimePicker(dvh);
                            } else {
                              dvh.conversionTime = null;
                            }
                          },
                        ),
                    ],
                  ),
                  if (!widget.editMode &&
                      dvh.canConvertConcentration() &&
                      (dvh.conversionWeight != null || !dvh.canConvertWeight()))
                    Transform.scale(
                      scale: 0.9,
                      child: ConversionSwitch(
                        isActive: dvh.conversionConcentration != null,
                        onSwitched: (value) {
                          HapticFeedback.mediumImpact();
                          if (value) {
                            _showConcentrationPicker(dvh);
                          } else {
                            dvh.conversionConcentration = null;
                          }
                        },
                        unit: dvh.dosage.getSubstanceUnit().toString(),
                      ),
                    ),
                ],
              ),
              if (widget.editMode)
                SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 255, 99, 8),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: const Text('Radera'),
                                content: const Text(
                                  'Är du säker på att du vill radera denna dosering?',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(dialogContext),
                                    child: const Text('Avbryt'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      dvh.deleteDosage();
                                      Navigator.pop(dialogContext);
                                    },
                                    child: const Text(
                                      'Radera',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return EditDosageDialog(
                                dosage: dvh.dosage,
                                onSave: (updatedDosage) {
                                  dvh.onDosageUpdated(updatedDosage);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      subtitle:
          dvh.conversionActive
              ? showDosage(
                dose: dvh.dose,
                lowerLimitDose: dvh.lowerLimitDose,
                higherLimitDose: dvh.higherLimitDose,
                maxDose: dvh.maxDose,
                conversionInfo: dvh.conversionInfo(),
                doseColor: activeColor(),
              )
              : null,
    );
  }
}

// //       if (dvh.dosage.administrationRoute != null)
//           Positioned(
//             top: 8,
//             left: 16,
//             child: RouteText(route: dvh.dosage.administrationRoute!),
//           ),
