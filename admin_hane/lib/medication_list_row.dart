import 'package:flutter/material.dart';
import 'package:hane/medications/medication_edit/medication_edit_detail.dart';
import 'package:hane/medications/medication_edit/medication_detail_form.dart';
import 'package:hane/medications/models/medication.dart';

class MedicationListRow extends StatefulWidget {
  final Medication _medication;

  const MedicationListRow(this._medication, {super.key});

  @override
  State<MedicationListRow> createState() => _MedicationListRowState();
}

class _MedicationListRowState extends State<MedicationListRow> {
  concentrationString() {
    if (widget._medication.concentrations == null) {
      return " ";
    }
    return widget._medication.concentrations!
        .map((c) => "${c.amount} ${c.unit}")
        .join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(children: [
              Flexible(child: SizedBox(width: 120, child: Text(widget._medication.name!))),
              Flexible(
                child: SizedBox(
                    width: 120, child: Text(widget._medication.category ?? " ")),
              ),
              Flexible(
                child: SizedBox(
                  width: 150,
                  child:
                      Text(concentrationString(), style: const TextStyle(fontSize: 12)),
                ),
              ),
              const Flexible(
                child: SizedBox(
                    width: 200,
        
                  
                ),
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 100),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MedicationEditDetail(
                                      medicationForm: MedicationForm(
                                          medication: widget._medication))),
                            );
                          },
                          child: const Text("Edit")),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
