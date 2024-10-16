import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final Function(String) onTimeUnitSet;

  const TimePicker({Key? key, required this.onTimeUnitSet}) : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  String? _currentTimeUnit;

  final List<String> timeUnits = ["min", "h", "d"];

  @override
  void initState() {
    super.initState();
    _currentTimeUnit = null; // No initial selection by default
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.sizeOf(context).width,
      height: 200,
      child: Column(
        children: [
          const Text(
            "Välj tidsenhet",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Time Unit Segmented Button
          SegmentedButton<String>(
            showSelectedIcon: false,
            emptySelectionAllowed: true, // Allow no selection
            segments: timeUnits.map((String value) {
              return ButtonSegment<String>(
                value: value,
                label: Text(value),
              );
            }).toList(),
            selected: _currentTimeUnit == null ? {} : {_currentTimeUnit!},
            onSelectionChanged: (newSelection) {
              setState(() {
                widget.onTimeUnitSet(newSelection.first);
                Navigator.pop(context);
              });
            },
          ),
          const SizedBox(height: 20),

          // Save Button
      
        ],
      ),
    );
  }
}