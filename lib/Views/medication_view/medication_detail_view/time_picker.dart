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
      child: Column(
        children: [
          Text("Välj tidsenhet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          DropdownButton<String>(
              value: _currentTimeUnit,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _currentTimeUnit = newValue;
                  });
                }
              },
              items: timeUnits.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList()),
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
