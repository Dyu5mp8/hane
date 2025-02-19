import "package:flutter/material.dart";
import "package:syncfusion_flutter_sliders/sliders.dart";

class WeightSlider extends StatefulWidget {
  final double initialWeight;
  final Function(double) onWeightSet;

  // ignore: use_super_parameters
  const WeightSlider({
    Key? key,
    required this.initialWeight,
    required this.onWeightSet,
  }) : super(key: key);

  @override
  State<WeightSlider> createState() => _WeightSliderState();
}

class _WeightSliderState extends State<WeightSlider> {
  late double _currentWeight;

  @override
  void initState() {
    super.initState();
    _currentWeight = widget.initialWeight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 240,
      child: Column(
        children: [
          const Text(
            "Ange vikt",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            "${_currentWeight.toStringAsFixed(0)} kg",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),

          SfSlider(
            value: _currentWeight,

            min: 40,
            max: 150,
            onChanged: (value) {
              setState(() {
                _currentWeight = value.round().toDouble();
              });
            },
          ),

          ElevatedButton(
            onPressed: () {
              widget.onWeightSet(_currentWeight);
              Navigator.pop(context);
            },
            child: const Text("Bekräfta"),
          ),
        ],
      ),
    );
  }
}
