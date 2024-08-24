import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hane/drugs/models/conversionColors.dart';
import 'package:hane/drugs/ui_components/concentration_picker.dart';
import 'package:hane/drugs/ui_components/conversion_option_miniature.dart';
import 'package:hane/drugs/controllers/dosageViewHandler.dart';
import 'package:hane/drugs/ui_components/time_picker.dart';
import 'package:hane/drugs/ui_components/weight_slider.dart';
import 'package:hane/drugs/models/dosage.dart';

class DosageSnippet extends StatefulWidget {
  final Dosage dosage;
  final DosageViewHandler dosageViewHandler;


  DosageSnippet(
      {Key? key, required this.dosage, required this.dosageViewHandler})
      : super(key: key);

  @override
  DosageSnippetState createState() => DosageSnippetState();
}

class DosageSnippetState extends State<DosageSnippet>
    with SingleTickerProviderStateMixin {
  late final controller = SlidableController(this);

  bool shouldShowWeightSlider = false;

  //setting pt weight to 70 or the static variable
  double _weightSliderValue = 70;

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

  _conversionButtonText(
      String setText, String resetText, dynamic conversionAdress) {
    if (conversionAdress == null) {
      return setText;
    } else {
      return resetText;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (shouldShowWeightSlider) {
      return Row(
        children: [
          Expanded(
              child: Slider(
            value: _weightSliderValue,
            min: 0,
            max: 200,
            onChanged: (value) {
              setState(() {
                _weightSliderValue = value;
              });
            },
          )),
          SizedBox(
              width: 50,
              child: Text("${_weightSliderValue.round().toString()} kg")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                setConversionWeight(_weightSliderValue);
                shouldShowWeightSlider = false;
              });
            },
            child: const Text("OK"),
          ),
        ],
      );
    } else {
      return Slidable(
        // Specify a key if the Slidable is dismissible.
        key: const ValueKey(0),

        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            if (widget.dosageViewHandler.ableToConvert.weight)
              SlidableAction(
                flex: 1,
                onPressed: (_) {
                  if (widget.dosageViewHandler.conversionWeight == null) {
                    _showWeightSlider(context);
                  } else {
                    setState(() {
                      widget.dosageViewHandler.conversionWeight = null;
                    });
                  }
                },
                backgroundColor:
                    ConversionColor.getColor(ConversionType.weight),
                foregroundColor: Colors.white,
                icon: Icons.scale,
                label: _conversionButtonText("Set Weight", "Reset",
                    widget.dosageViewHandler.conversionWeight),
              ),
            if (widget.dosageViewHandler.ableToConvert.concentration)
              SlidableAction(
                flex: 1,
                onPressed: (_) {
                  if (widget.dosageViewHandler.conversionConcentration ==
                      null) {
                    _showConcentrationPicker(context);
                  } else {
                    setState(() {
                      widget.dosageViewHandler.conversionConcentration = null;
                    });
                  }
                },
                backgroundColor:
                    ConversionColor.getColor(ConversionType.concentration),
                foregroundColor: Colors.white,
                icon: Icons.medication_liquid,
                label: _conversionButtonText("Set Concentration", "Reset",
                    widget.dosageViewHandler.conversionConcentration),
              ),
            if (widget.dosageViewHandler.ableToConvert.time)
              SlidableAction(
                flex: 1,
                onPressed: (_) {
                  if (widget.dosageViewHandler.conversionTime == null) {
                    _showTimePicker(context);
                  } else {
                    setState(() {
                      widget.dosageViewHandler.conversionTime = null;
                    });
                  }
                },
                backgroundColor: ConversionColor.getColor(ConversionType.time),
                foregroundColor: Colors.white,
                icon: Icons.timer,
                label: _conversionButtonText("Convert to minutes", "Reset",
                    widget.dosageViewHandler.conversionTime),
              ),
            // Include other actions as necessary
          ],
        ),

        // The child of the Slidable is what the user sees when the
        // component is not dragged.

        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(
              color: Color.fromARGB(255, 200, 200, 200), // Softer border color
              width: 0.5,
            ),
          ),
          tileColor: Colors.white, // Consistent background color
          minVerticalPadding: 20,
          trailing: SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConversionOptionMinature(
                    dosageViewHandler: widget.dosageViewHandler),
              ],
            ),
          ),
          title: widget.dosageViewHandler.showDosage(),

          dense: false, // Ensure the tile isn't too compressed
        ),
      );
    }
  }
}
