// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:hane/medications/models/concentration.dart';

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
  late Concentration? _currentConcentration;

  @override
  void initState() {
    super.initState();
    _currentConcentration =
        null; // Assuming at least one concentration is available
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Column(
        children: [
          const Text("Välj koncentration",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SegmentedButton<Concentration>(
              showSelectedIcon: false,
              emptySelectionAllowed: true,

              segments: widget.concentrations.map((Concentration conc) {
                return ButtonSegment<Concentration>(
                  value: conc,
                  label: Text(conc.toString()),
                );
              }).toList(),
              selected: _currentConcentration == null
                  ? {}
                  : {_currentConcentration!},
              
              onSelectionChanged: (newSelection) {
                setState(() {
                  _currentConcentration = newSelection.first;
                });
              }),
          ElevatedButton(
            onPressed: () {
              if (_currentConcentration != null) {
                widget.onConcentrationSet(_currentConcentration!);
              }

              Navigator.pop(context);
            },
            child:
                _currentConcentration == null ? const Text("Återgå") : Text("Konvertera"),

          
          ),
        ],
      ),
    );
  }
}
