import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hane/Views/medication_view/medication_detail_view/conversion_modal/concentration_picker.dart';
import 'package:hane/Views/medication_view/medication_detail_view/indication_box/conversion_option_miniature.dart';
import 'package:hane/Views/medication_view/medication_detail_view/indication_box/dosageViewHandler.dart';
import 'package:hane/Views/medication_view/medication_detail_view/conversion_modal/time_picker.dart';
import 'package:hane/Views/medication_view/medication_detail_view/conversion_modal/weight_slider.dart';
import 'package:hane/models/medication/bolus_dosage.dart';

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
      String setText, String resetText, dynamic? conversionAdress) {
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
            child: Text("OK"),
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
            if (widget.dosageViewHandler.ableToConvert().weight)
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
                backgroundColor: const Color(0xFF7BC043),
                foregroundColor: Colors.white,
                icon: Icons.scale,
                label: _conversionButtonText("Set Weight", "Reset",
                    widget.dosageViewHandler.conversionWeight),
              ),
            if (widget.dosageViewHandler.ableToConvert().concentration)
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
                backgroundColor: const Color(0xFF7BC043),
                foregroundColor: Colors.white,
                icon: Icons.medication_liquid,
                label: _conversionButtonText("Set Concentration", "Reset",
                    widget.dosageViewHandler.conversionConcentration),
              ),
            if (widget.dosageViewHandler.ableToConvert().time)
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
                backgroundColor: const Color(0xFF7BC043),
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
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Color.fromARGB(255, 117, 117, 117), width: 0.2),
          ),
          minTileHeight: 80,
          trailing: SizedBox(
            width: 80,
            child: Container(
              alignment: Alignment.topRight,
              child: ConversionOptionMinature(
                  dosageViewHandler: widget.dosageViewHandler),
            ),
          ),
          dense: true,
          title: Text(
            widget.dosageViewHandler.showDosage(),
          ),
        ),
      );
    }
  }
}
