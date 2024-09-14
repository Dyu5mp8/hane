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
      height: 240,
      child: Column(
        children: [
           Text("Ange vikt", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text("${_currentWeight.toString()} kg", style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
         
          Slider(
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
            child: Text("Bekräfta"),
          ),
        ],
      ),
    );
  }
}