import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/ui_components/concentration_picker.dart';
import 'package:hane/drugs/drug_detail/dosageViewHandler.dart';
import 'package:hane/drugs/drug_detail/ui_components/route_text.dart';
import 'package:hane/drugs/drug_detail/ui_components/time_picker.dart';
import 'package:hane/drugs/drug_detail/ui_components/weight_slider.dart';
import 'package:hane/drugs/models/dosage.dart';

class DosageSnippet extends StatefulWidget {
  final Dosage dosage;
  final DosageViewHandler dosageViewHandler;

  const DosageSnippet(
      {super.key, required this.dosage, required this.dosageViewHandler});

  @override
  DosageSnippetState createState() => DosageSnippetState();
}

class DosageSnippetState extends State<DosageSnippet> {
  bool shouldShowWeightSlider = false;

  // Setting patient weight to 70 or the static variable
  final double _weightSliderValue = 70;

  setConversionWeight(double weight) {
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
              setState(() {
                setConversionWeight(newWeight);
              });
            },
          );
        });
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
        });
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

  bool get _isConversionActive {
    return widget.dosageViewHandler.conversionWeight != null ||
        widget.dosageViewHandler.conversionConcentration != null ||
        widget.dosageViewHandler.conversionTime != null;
  }

  void _resetAllConversions() {
    setState(() {
      widget.dosageViewHandler.conversionWeight = null;
      widget.dosageViewHandler.conversionConcentration = null;
      widget.dosageViewHandler.conversionTime = null;
    });
  }

  PopupMenuButton<int> _buildPopUpMenuButton() {
    return PopupMenuButton<int>(
      popUpAnimationStyle: AnimationStyle.noAnimation,

              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
               style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 195, 225, 240)),
              padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(4)), // Compact padding
              elevation: WidgetStateProperty.all<double>(4.0), // Slight elevation for depth
            ),
            iconSize: 20,
              color: const Color.fromARGB(255, 225, 225, 225), // Background color of the popup menu
              elevation: 8, // Elevation of the popup menu
              offset: const Offset(0, 40),
              onSelected: (int result) {
                if (result == 1) {
                  if (widget.dosageViewHandler.conversionWeight == null) {
                    _showWeightSlider(context);
                  } else {
                    setState(() {
                      widget.dosageViewHandler.conversionWeight = null;
                    });
                  }
                } else if (result == 2) {
                  if (widget.dosageViewHandler.conversionConcentration == null) {
                    _showConcentrationPicker(context);
                  } else {
                    setState(() {
                      widget.dosageViewHandler.conversionConcentration = null;
                    });
                  }
                } else if (result == 3) {
                  if (widget.dosageViewHandler.conversionTime == null) {
                    _showTimePicker(context);
                  } else {
                    setState(() {
                      widget.dosageViewHandler.conversionTime = null;
                    });
                  }
                } else if (result == 4) {
                  _resetAllConversions();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                if (widget.dosageViewHandler.ableToConvert.weight)
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Color.fromARGB(255, 54, 107, 200)),
                        const SizedBox(width: 4),
                        Text(_conversionButtonText(
                            "Konvertera med vikt",
                            "Återställ viktkonvertering",
                            widget.dosageViewHandler.conversionWeight)),
                      ],
                    ),
                  ),
                if (widget.dosageViewHandler.ableToConvert.concentration)
                  PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: [
                        const Icon(Icons.science, color: Color.fromARGB(255, 26, 106, 34)),
                        const SizedBox(width: 8),
                        Text(_conversionButtonText(
                            "Konvertera till ml",
                            "Återställ konvertering till ml",
                            widget.dosageViewHandler.conversionConcentration)),
                      ],
                    ),
                  ),
                if (widget.dosageViewHandler.ableToConvert.time)
                  PopupMenuItem<int>(
                    value: 3,
                    child: Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.orangeAccent),
                        const SizedBox(width: 8),
                        Text(_conversionButtonText(
                            "Konvertera tidsenhet",
                            "Återställ tidskonvertering",
                            widget.dosageViewHandler.conversionTime)),
                      ],
                    ),
                  ),
                if (_isConversionActive)
                  const PopupMenuItem<int>(
                    value: 4,
                    child: Row(
                      children: [
                        Icon(Icons.refresh, color: Colors.blueGrey),
                        SizedBox(width: 8),
                        Text("Återställ alla"),
                      ],
                    ),
                  ),
              ],
              icon: const Icon(Icons.swap_horiz_outlined,
                color: Color.fromARGB(255, 0, 0, 0), size: 24),
            );
  }
@override
Widget build(BuildContext context) {
  // Calculate the number of active conversions
  int activeConversions = 0;
  if (widget.dosageViewHandler.conversionWeight != null) activeConversions++;
  if (widget.dosageViewHandler.conversionConcentration != null) activeConversions++;
  if (widget.dosageViewHandler.conversionTime != null) activeConversions++;
  

  return Stack(
    children: [
      ListTile(
        key: ValueKey(_isConversionActive),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(
            color: Color.fromARGB(255, 220, 220, 220), // Softer border color
            width: 0.5,
          ),
        ),
        tileColor: Colors.white, // Consistent background color
        minVerticalPadding: 20,
        title: Row(
          children: [
            Expanded(
              child: widget.dosageViewHandler.showDosage(isOriginalText: true),
            ),
            const SizedBox(width: 8),
            if (_isConversionActive)
              IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 195, 225, 240)),
                  padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(4)), // Compact padding
                  elevation: WidgetStateProperty.all<double>(4.0), // Slight elevation for depth
                ),
                iconSize: 20,
                icon: const Icon(Icons.refresh, color: Color.fromARGB(255, 20, 12, 2)),
                onPressed: _resetAllConversions,
              ),
            SizedBox(width: 4),
            if (widget.dosageViewHandler.ableToConvert.weight ||
                widget.dosageViewHandler.ableToConvert.concentration ||
                widget.dosageViewHandler.ableToConvert.time)
                
            if (activeConversions > 0)
              Badge.count(
                offset: const Offset(0, 2),
                count: activeConversions,
                child: _buildPopUpMenuButton(),
              )
            else
              _buildPopUpMenuButton(),
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
        child: 
        
       
        RouteText(route: widget.dosageViewHandler.getAdministrationRoute()!),
      ),
    ],
  );
}
}