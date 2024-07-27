import "package:flutter/material.dart";
import "package:hane/Views/medication_view/medication_detail_view/dosageViewHandler.dart";


class ConversionOptionMinature extends StatelessWidget {
  final DosageViewHandler dosageViewHandler;
  final double iconSize;

  const ConversionOptionMinature({
    required this.dosageViewHandler,
    this.iconSize = 15.0, // Default value set here.
  });

  @override
  Widget build(BuildContext context) {

    bool _isConvertingWeight =
        dosageViewHandler.conversionWeight == null ? false : true;
    bool _isConvertingTime =
        dosageViewHandler.conversionTime == null ? false : true;
    bool _isConvertingConcentration =
        dosageViewHandler.conversionConcentration == null ? false : true;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (dosageViewHandler.ableToConvert().concentration ||
            dosageViewHandler.ableToConvert().time ||
            dosageViewHandler.ableToConvert().weight)
          Icon(Icons.swipe_left, size: iconSize, color: Colors.black),
        if (dosageViewHandler.ableToConvert().concentration)
          Icon(Icons.medication_liquid,
              size: iconSize,
              color: _isConvertingConcentration ? Colors.green : Colors.grey),
        if (dosageViewHandler.ableToConvert().time)
          Icon(Icons.timer_rounded,
              size: iconSize,
              color: _isConvertingTime ? Colors.green : Colors.grey),
        if (dosageViewHandler.ableToConvert().weight)
          Icon(Icons.scale,
              size: iconSize,
              color: _isConvertingWeight ? Colors.green : Colors.grey),
      ],
    );
  }
}


