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

class DosageSnippet extends StatefulWidget {
  final bool editMode;
  final Function(Dosage) onDosageUpdated;
  final Function()? onDosageDeleted;
  final List<Concentration>? availableConcentrations;

  DosageSnippet({
    Key? key,
    this.editMode = false,
    required this.onDosageUpdated,
    this.onDosageDeleted,
    this.availableConcentrations,
  })


  @override
  _DosageSnippetState createState() => _DosageSnippetState();
}

class _DosageSnippetState extends State<DosageSnippet> {
  final double _weightSliderValue = 70.0;

  void setConversionWeight(double weight) {
    setState(() {

    });
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
      builder: (BuildContext context) {
        return TimePicker(
          onTimeUnitSet: (newTime) {
            HapticFeedback.mediumImpact();
            dvh.conversionTime = newTime;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final dvh = Provider.of<DosageViewHandler>(context);
    
    return Stack(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          minVerticalPadding: 12,
          title: Row(
            children: [
              Expanded(
                child: dvh.showDosage(isOriginalText: true),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Row(
                    children: [
                      if (!widget.editMode &&
                          dvh.canConvertWeight())
                        ConversionButton(
                          label: "kg",
                          isActive:
                              dvh.conversionWeight != null,
                          onPressed: () {
                            if (dvh.conversionWeight == null) {
                              _showWeightSlider(dvh);
                            } else {
                              dvh.conversionWeight = null;
                            }
                          },
                        ),
                      const SizedBox(width: 5),
                      if (!widget.editMode &&
                          dvh.canConvertTime())
                        ConversionButton(
                          label: "t",
                          isActive:
                              dvh.conversionTime != null,
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
                  if (!widget.editMode && dvh.canConvertConcentration())
                    Transform.scale(
                      scale: 0.9,
                      child: ConversionSwitch(
                        isActive:
                            dvh.conversionConcentration != null,
                        onSwitched: (value) {
                          HapticFeedback.mediumImpact();
                          if (value) {
                            _showConcentrationPicker(dvh);
                          } else {
                            dvh.conversionConcentration = null;
                          }
                        },
                        unit: dvh.getCommonUnitSymbol()
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
                        icon: const Icon(Icons.delete,
                            color: Color.fromARGB(255, 255, 99, 8)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: const Text('Radera'),
                                content: const Text(
                                    'Är du säker på att du vill radera denna dosering?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    child: const Text('Avbryt'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteDosage();
                                      Navigator.pop(dialogContext);
                                    },
                                    child: const Text('Radera',
                                        style: TextStyle(color: Colors.red)),
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
          subtitle: _isConversionActive
              ? widget.dosageViewHandler.showDosage(isOriginalText: false)
              : null,
        ),
        if (widget.dosageViewHandler.getAdministrationRoute() != null)
          Positioned(
            top: 8,
            left: 16,
            child: RouteText(
                route: widget.dosageViewHandler.getAdministrationRoute()!),
          ),
      ],
    );
  }
}