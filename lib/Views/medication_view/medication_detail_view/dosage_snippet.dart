import 'dart:ffi';

import 'package:flutter/widgets.dart';
import 'package:hane/Views/medication_view/medication_detail_view/dosageViewHandler.dart';
import 'package:hane/models/medication/bolus_dosage.dart';

class DosageSnippet extends StatefulWidget {
  final Dosage dosage;
  final double? conversionWeight;
  final String? conversionTime;
  final ({double amount, String unit})? conversionConcentration;

  DosageSnippet({
    Key? key,
    required this.dosage,
    this.conversionWeight,
    this.conversionTime,
    this.conversionConcentration,
  }) : super(key: key);

  @override
  _DosageSnippetState createState() => _DosageSnippetState();
}

class _DosageSnippetState extends State<DosageSnippet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        DosageViewHandler(
          widget.key,
          dosage: widget.dosage,
          conversionWeight: widget.conversionWeight,
          conversionTime: widget.conversionTime,
          conversionConcentration: widget.conversionConcentration,
        ).showDosage(),
      ),
    );
  }
}