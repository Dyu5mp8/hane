import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final Function(String) onTimeUnitSet;

  const TimePicker({Key? key, required this.onTimeUnitSet}) : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  String _currentTimeUnit = "min";

  final List<String> timeUnits = ["min", "h", "d"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Text("Välj tidsenhet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: timeUnits.map((String value) {
              return ButtonSegment<String>(
                value: value,
                label: Text(value),
              );
            }).toList(),
            selected: {_currentTimeUnit},
            onSelectionChanged: (newSelection) {
              setState(() {
                _currentTimeUnit = newSelection.first;
              });
            },
          ),

          ElevatedButton(
              onPressed: () {
                widget.onTimeUnitSet(_currentTimeUnit);
                Navigator.pop(context);
              },
              child: Text("Spara")),
        ],
      ),
    );
  }
}
