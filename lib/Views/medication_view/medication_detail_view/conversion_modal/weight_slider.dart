import "package:flutter/material.dart";



class WeightSlider extends StatefulWidget {
  final double initialWeight;
  final Function(double) onWeightSet;

  const WeightSlider({
    Key? key,
    required this.initialWeight,
    required this.onWeightSet,
  }) : super(key: key);

  @override
  _WeightSliderState createState() => _WeightSliderState();
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
      padding: EdgeInsets.all(20),
      height: 200,
      child: Column(
        children: [
          Text("Adjust Weight", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Slider(
            value: _currentWeight,
            min: 0,
            max: 200,            
            onChanged: (value) {
              setState(() {
                _currentWeight = value;
              });
            },
          ),
          Text("${_currentWeight.round().toString()} kg"),
          ElevatedButton(
            onPressed: () {
              widget.onWeightSet(_currentWeight);
              Navigator.pop(context);
            },
            child: Text("Set Weight"),
          ),
        ],
      ),
    );
  }
}