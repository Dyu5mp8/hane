import 'package:flutter/material.dart';

class ConversionSwitch extends StatefulWidget {
  final bool isActive;
  final Function(bool) onSwitched;
  final String? unit;
  final activeColor = const Color.fromARGB(255, 254, 112, 56);
  final inactiveColor = const Color.fromARGB(255, 195, 225, 240);

  const ConversionSwitch({
    super.key,
    required this.isActive,
    required this.onSwitched,
    this.unit,
  });

  @override
  State<ConversionSwitch> createState() => _ConversionSwitchState();
}

class _ConversionSwitchState extends State<ConversionSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.unit != null)
          Text(widget.unit!,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      !widget.isActive ? FontWeight.bold : FontWeight.normal)),
        Switch.adaptive(
          value: widget.isActive,
          onChanged: widget.onSwitched,
          activeColor: widget.activeColor,
          inactiveTrackColor: widget.inactiveColor,
        ),
        Text("ml",
            style: TextStyle(
                fontSize: 14,
                fontWeight:
                    widget.isActive ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
