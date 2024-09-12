import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dosage_dialog.dart';
import 'package:hane/drugs/drug_detail/ui_components/concentration_picker.dart';
import 'package:hane/drugs/drug_detail/dosageViewHandler.dart';
import 'package:hane/drugs/drug_detail/ui_components/conversion_button.dart';
import 'package:hane/drugs/drug_detail/ui_components/route_text.dart';
import 'package:hane/drugs/drug_detail/ui_components/time_picker.dart';
import 'package:hane/drugs/drug_detail/ui_components/weight_slider.dart';
import 'package:hane/drugs/models/drug.dart';

class DosageSnippet extends StatefulWidget {
  Dosage dosage;
  final bool editMode;
  final Function(Dosage) onDosageUpdated;
  final DosageViewHandler dosageViewHandler;
  final Function()? onDosageDeleted;
  final List<Concentration>? availableConcentrations;

  DosageSnippet({
    super.key,
    required this.dosage,
    this.editMode = false,
    required this.onDosageUpdated,
    this.onDosageDeleted,
    this.availableConcentrations,
  }) : dosageViewHandler = DosageViewHandler(
            availableConcentrations: availableConcentrations,
            key,
            dosage: dosage);

  @override
  DosageSnippetState createState() => DosageSnippetState();
}

class DosageSnippetState extends State<DosageSnippet> {
  final double _weightSliderValue = 70;

  bool get _isConversionActive {
    return widget.dosageViewHandler.conversionWeight != null ||
        widget.dosageViewHandler.conversionConcentration != null ||
        widget.dosageViewHandler.conversionTime != null;
  }

  void setConversionWeight(double weight) {
    setState(() {
      widget.dosageViewHandler.conversionWeight = weight;
    });
  }

  void _showWeightSlider(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return WeightSlider(
          initialWeight: _weightSliderValue,
          onWeightSet: (newWeight) {
            setConversionWeight(newWeight);
          },
        );
      },
    );
  }

  void _showConcentrationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ConcentrationPicker(
          concentrations: widget.dosageViewHandler.availableConcentrations!,
          onConcentrationSet: (newConcentration) {
            setState(() {
              widget.dosageViewHandler.conversionConcentration =
                  newConcentration;
            });
          },
        );
      },
    );
  }

  void _showTimePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return TimePicker(
            onTimeUnitSet: (newTime) {
              setState(() {
                widget.dosageViewHandler.conversionTime = newTime;
              });
            },
          );
        });
  }

  String _conversionButtonText(
      String setText, String resetText, dynamic conversionAddress) {
    return conversionAddress == null ? setText : resetText;
  }


  void _resetWeightConversion() {
    setState(() {
      widget.dosageViewHandler.conversionWeight = null;
    });
  }

  void _resetConcentrationConversion() {
    setState(() {
      widget.dosageViewHandler.conversionConcentration = null;
    });
  }

  void _resetTimeConversion() {
    setState(() {
      widget.dosageViewHandler.conversionTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListTile(
          key: ValueKey(_isConversionActive),
          contentPadding:
              const EdgeInsets.only(left: 10, right: 4, top: 8, bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(
              color: Color.fromARGB(255, 220, 220, 220),
              width: 0.5,
            ),
          ),
          tileColor: Colors.white,
          minVerticalPadding: 20,
          title: Row(
            children: [
              Expanded(
                child:
                    widget.dosageViewHandler.showDosage(isOriginalText: true),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 90,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: -3,
                  spacing: 4,
                  children: [
                    if (!widget.editMode &&
                        widget.dosageViewHandler.ableToConvert.weight)
                      ConversionButton(
                        label: "kg",
                        isActive: widget.dosageViewHandler.conversionWeight != null,
                        onPressed: () {
                          if (widget.dosageViewHandler.conversionWeight == null) {
                            _showWeightSlider(context);
                          } else {
                            _resetWeightConversion();
                          }
                        },
                      ),
                                      
                    
                                      
                    // Concentration Conversion Button
                    if (!widget.editMode &&
                        widget.dosageViewHandler.ableToConvert.concentration)
                      ConversionButton(
                        label: "ml",
                        isActive:
                            widget.dosageViewHandler.conversionConcentration !=
                                null,
                        onPressed: () {
                          if (widget.dosageViewHandler.conversionConcentration ==
                              null) {
                            _showConcentrationPicker(context);
                          } else {
                            _resetConcentrationConversion();
                          }
                        },
                      ),
                
                
                          
                      if (!widget.editMode &&
                          widget.dosageViewHandler.ableToConvert.time)
                        ConversionButton(
                          label: "h",
                          isActive:
                              widget.dosageViewHandler.conversionTime !=
                                  null,
                          onPressed: () {
                            if (widget.dosageViewHandler.conversionTime ==
                                null) {
                              _showTimePicker(context);
                            } else {
                              _resetTimeConversion();
                            }
                          },
                        )
                  ],
                ),
              ),




              if (widget.editMode)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
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
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
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
              if (widget.editMode)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return EditDosageDialog(
                          dosage: widget.dosage,
                          onSave: (updatedDosage) {
                            _updateDosage(updatedDosage);
                          },
                        );
                      },
                    );
                  },
                ),
            ],
          ),
          subtitle: widget.dosageViewHandler.conversionWeight != null ||
                  widget.dosageViewHandler.conversionConcentration != null ||
                  widget.dosageViewHandler.conversionTime != null
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

  void _updateDosage(Dosage updatedDosage) {
    setState(() {
      widget.dosage = updatedDosage;
    });
    widget.onDosageUpdated(updatedDosage);
  }

  void _deleteDosage() {
    widget.onDosageDeleted?.call();
  }
}
