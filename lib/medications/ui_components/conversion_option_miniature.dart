import "package:flutter/material.dart";
import "package:hane/medications/controllers/dosageViewHandler.dart";
import "package:hane/medications/models/conversionColors.dart";


class ConversionOptionMinature extends StatelessWidget {
  final DosageViewHandler dosageViewHandler;
  final double iconSize;

  const ConversionOptionMinature({
    required this.dosageViewHandler,
    this.iconSize = 17.0, // Default value set here.
  });

 @override
Widget build(BuildContext context) {
  // Determine if conversions are active
  bool isConvertingWeight = dosageViewHandler.conversionWeight != null;
  bool isConvertingTime = dosageViewHandler.conversionTime != null;
  bool isConvertingConcentration = dosageViewHandler.conversionConcentration != null;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      if (dosageViewHandler.ableToConvert.concentration)
        Icon(
          Icons.vaccines,
          size: iconSize,
          color: ConversionColor.getColor(ConversionType.concentration, isActive: isConvertingConcentration),
        ),
      if (dosageViewHandler.ableToConvert.time)
        Icon(
          Icons.timer_rounded,
          size: iconSize,
          color: ConversionColor.getColor(ConversionType.time, isActive: isConvertingTime),
        ),
      if (dosageViewHandler.ableToConvert.weight)
        Icon(
          Icons.scale,
          size: iconSize,
          color: ConversionColor.getColor(ConversionType.weight, isActive: isConvertingWeight),
        ),
    ],
  );
}
}


