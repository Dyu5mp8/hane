import 'package:flutter/material.dart';

class ConversionSwitch extends StatefulWidget {
  final bool isActive;
  final Function(bool) onSwitched;
  final String? unit;

  const ConversionSwitch({
    Key? key,
    required this.isActive,
    required this.onSwitched,
    this.unit,
  }) : super(key: key);

  @override
  _ConversionSwitchState createState() => _ConversionSwitchState();
}

class _ConversionSwitchState extends State<ConversionSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.unit != null)
        Text(widget.unit!, style: TextStyle(fontSize: 14, fontWeight: !widget.isActive ? FontWeight.bold : FontWeight.normal)),
  

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Switch.adaptive(
            value: widget.isActive,
            onChanged: widget.onSwitched,
            activeColor: Theme.of(context).primaryColor,
          ),
        ),
        Text("ml", style: TextStyle(fontSize: 14, fontWeight: widget.isActive ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
