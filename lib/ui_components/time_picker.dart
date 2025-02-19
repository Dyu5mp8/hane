import 'package:flutter/material.dart';
import 'package:hane/drugs/models/units.dart';

class TimePicker extends StatefulWidget {
  final Function(TimeUnit) onTimeUnitSet;
  final TimeUnit? initialTimeUnit;

  const TimePicker({
    super.key,
    required this.onTimeUnitSet,
    required this.initialTimeUnit,
  });

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeUnit? _currentTimeUnit;

  final List<TimeUnit> timeUnits = TimeUnit.values;

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
          SegmentedButton<TimeUnit>(
            showSelectedIcon: false,
            emptySelectionAllowed: true, // Allow no selection
            segments:
                timeUnits.map((TimeUnit unit) {
                  return ButtonSegment<TimeUnit>(
                    value: unit,
                    label: Text(unit.toString()),
                  );
                }).toList(),
            selected: _currentTimeUnit == null ? {} : {_currentTimeUnit!},
            onSelectionChanged: (newSelection) {
              if (newSelection.isNotEmpty) {
                widget.onTimeUnitSet(newSelection.first);
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(height: 20),

          // Save Button
        ],
      ),
    );
  }
}
