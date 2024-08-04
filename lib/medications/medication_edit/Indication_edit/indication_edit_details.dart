import 'package:flutter/material.dart';
import 'package:hane/medications/medication_edit/Dosage_edit/dosage_detail_form.dart';
import 'package:hane/medications/medication_edit/Dosage_edit/dosage_edit_detail.dart';
import 'package:hane/medications/medication_edit/Indication_edit/indication_detail_form.dart';
import 'package:hane/medications/models/medication.dart';


class IndicationDetail extends StatefulWidget {
  final IndicationDetailForm indicationDetailForm;

  IndicationDetail({required this.indicationDetailForm});

  @override
  _IndicationDetailFormState createState() => _IndicationDetailFormState();
}

class _IndicationDetailFormState extends State<IndicationDetail> {
  final _formKey = GlobalKey<FormState>();

  Widget customListTile(Dosage dosage, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dosage.instruction != null)
              Text(dosage.instruction!,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            if (dosage.dose != null) Text("dos: ${dosage.dose!.toString()}"),
            if (dosage.lowerLimitDose != null)
              Text("från: ${dosage.lowerLimitDose!.toString()}"),
            if (dosage.higherLimitDose != null)
              Text("till: ${dosage.higherLimitDose!.toString()}"),
            if (dosage.maxDose != null)
              Text("max: ${dosage.maxDose!.toString()}"),
            // Other texts displaying dosage details
          ],
        ),
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) => DosageEditDetail(
                        dosageForm: DosageDetailForm(
                          dosage: dosage,
                          onSave: (Dosage updatedDosage) {
                            setState(() {
                              widget.indicationDetailForm.indication
                                  .dosages?[index] = updatedDosage;
                            });
                          },
                        ),
                      ));
            })
      ]),
    );
  }

  List<Widget> dosagesToList(List<Dosage>? dosages) {
    List<Widget> ls = [];
    if (dosages == null) {
      return ls;
    }
    for (int i = 0; i < dosages.length; i++) {
      ls.add(customListTile(dosages[i], i));
      ls.add(Divider());
    }
    return ls;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      widget.indicationDetailForm.saveIndication();
      Navigator.pop(context, widget.indicationDetailForm.indication);
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.indicationDetailForm.indication.name == "" ? "Ny indikation" : widget.indicationDetailForm.indication.name}"),
          actions: [
            TextButton(
              child: Text("Spara"),
              onPressed: () => _saveForm(),
            ),
          ],
        ),
        body: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                      controller: widget.indicationDetailForm.nameController,
                      decoration: InputDecoration(
                        labelText: 'Indikation',
                        hintText: 'Ange indikation',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ange indikation';
                        }
                      }),
                  TextFormField(
                    controller: widget.indicationDetailForm.notesController,
                    decoration: InputDecoration(
                      labelText: 'Anteckningar',
                      hintText: 'Ange anteckningar',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  Column(
                      children: dosagesToList(
                          widget.indicationDetailForm.indication.dosages)),

                  TextButton(
                    child: Text("Lägg till dosering"),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => DosageEditDetail(
                          dosageForm: DosageDetailForm(
                            dosage: Dosage(
                                instruction: "",
                                dose: null,
                                lowerLimitDose: null,
                                higherLimitDose: null,
                                maxDose: null),
                            onSave: (Dosage newDosage) {
                              setState(() {
                                widget.indicationDetailForm.addDosage(newDosage);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
