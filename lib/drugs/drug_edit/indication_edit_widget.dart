import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_edit/Indication_edit/indication_detail_form.dart';
import 'package:hane/drugs/drug_edit/Indication_edit/indication_edit_details.dart';
import 'package:hane/drugs/drug_edit/indication_widget_form.dart';
import 'package:hane/drugs/models/drug.dart';

class IndicationEditWidget extends StatefulWidget {
  final IndicationForm indicationForm;
  const IndicationEditWidget({super.key, required this.indicationForm});

  @override
  State<IndicationEditWidget> createState() => _IndicationEditWidgetState();
}

class _IndicationEditWidgetState extends State<IndicationEditWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IndicationDetail(
                              indicationDetailForm: IndicationDetailForm(
                            onSave: (Indication newIndication) {
                              setState(() {
                                widget.indicationForm
                                    .updateIndication(newIndication);
                              });
                            },
                          ))));
            },
            child: const Text('Lägg till indikation')),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: indicationsToListTileList()),
      ],
    );
  }

  Widget buildIndicationSubtitle(Indication indication) {
    List<Widget> children = [];

    if (indication.notes != null) {
      children.add(Text(indication.notes!));
    }

    if (indication.isPediatric) {
      children.add(const Text("Pediatrisk"));
    }

    if (indication.dosages != null && indication.dosages!.isNotEmpty) {
      children.add(
          const Text("Doseringar:", style: TextStyle(fontWeight: FontWeight.bold)));
      children.addAll(indication.dosages!.expand((dosage) => [
            Text(dosage.instruction ?? ""),
            if (dosage.dose != null) Text("Dos: ${dosage.dose.toString()}"),
            if (dosage.lowerLimitDose != null)
              Text("Från: ${dosage.lowerLimitDose.toString()}"),
            if (dosage.higherLimitDose != null)
              Text("Till: ${dosage.higherLimitDose.toString()}"),
            if (dosage.maxDose != null)
              Text("Max: ${dosage.maxDose?.toString()}"),
            const Divider()
          ]));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  List<Widget> indicationsToListTileList() {
    return widget.indicationForm.indications.map((indication) {
      return ListTile(
        title: Text(indication.name),
        subtitle: buildIndicationSubtitle(indication),
        trailing: Wrap(
          children: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  widget.indicationForm.removeIndication(indication);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndicationDetail(
                        indicationDetailForm: IndicationDetailForm(
                          indication: indication,
                          onSave: (Indication updatedIndication) {
                            setState(() {
                              widget.indicationForm
                                  .updateIndication(updatedIndication);
                            });
                          },
                        ),
                      ),
                    ));
              },
            ),
          ],
        ),
      );
    }).toList(); // Ensure to convert the iterable to a list
  }
}
