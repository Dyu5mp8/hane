import 'package:flutter/material.dart';
import 'package:hane/models/medication/concentration.dart';

import 'package:flutter/material.dart';

class ConcentrationPicker extends StatefulWidget {
  final List<Concentration> concentrations;
  final Function(Concentration) onConcentrationSet;

  const ConcentrationPicker({
    Key? key,
    required this.concentrations,
    required this.onConcentrationSet,
  }) : super(key: key);

  @override
  _ConcentrationPickerState createState() => _ConcentrationPickerState();
}

class _ConcentrationPickerState extends State<ConcentrationPicker> {
  late Concentration _currentConcentration;

  @override
  void initState() {
    super.initState();
    _currentConcentration = widget.concentrations[0]; // Assuming at least one concentration is available
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 200,
      child: Column(
        children: [
          Text("Adjust Concentration", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          DropdownButton<Concentration>(
            value: _currentConcentration,
            onChanged: (Concentration? newValue) {
              if (newValue != null) {
                setState(() {
                  _currentConcentration = newValue;
                });
              }
            },
            items: widget.concentrations.map<DropdownMenuItem<Concentration>>((Concentration concentration) {
              return DropdownMenuItem<Concentration>(
                value: concentration,
                child: Text("${concentration.amount} ${concentration.unit}"),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onConcentrationSet(_currentConcentration);
              Navigator.pop(context);
            },
            child: Text("Set Concentration"),
          ),
        ],
      ),
    );
  }
}
