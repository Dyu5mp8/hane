import 'package:hane/medications/medication_edit/Concentration_edit/concentration_form.dart';
import 'package:flutter/material.dart';
import 'package:hane/utils/validate_concentration_save.dart' as val;

class ConcentrationEditPart extends StatefulWidget {
  final ConcentrationForm concentrationForm;

  ConcentrationEditPart({required this.concentrationForm});

  @override
  State<ConcentrationEditPart> createState() => _ConcentrationEditPartState();
}

class _ConcentrationEditPartState extends State<ConcentrationEditPart> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Lägg till koncentration'),
          Row(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width/4,
                child: TextFormField(
                  controller:
                      widget.concentrationForm.concentrationAmountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter amount',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: val.validateConcentrationAmount,
                ),
              ),
              SizedBox(height: 20, width: MediaQuery.of(context).size.width/16),
              SizedBox(
                width: MediaQuery.of(context).size.width/4, 
                child: TextFormField(
                    controller:
                        widget.concentrationForm.concentrationUnitController,
                    decoration: InputDecoration(
                      labelText: 'Unit',
                      hintText: 'Enter unit',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: val.validateConcentrationUnit),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    saveConcentration();
                  });
                },
              ),
 
            ],
          ),
                       Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        width: MediaQuery.of(context).size.width/2,
                         child: Wrap(
                           runSpacing: 8,
                           spacing: 8,
                           alignment: WrapAlignment.start,
                           children: getConcentrationChips(widget.concentrationForm),
                         ),
                       )
        ],
      ),
    );
  }

  void saveConcentration() {
    if (_formKey.currentState!.validate()) {
      widget.concentrationForm.addConcentration();
    }
  }

  List<InputChip> getConcentrationChips(ConcentrationForm concentrationForm) {
    return concentrationForm.concentrations
        .map((concentration) => InputChip(
          
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              backgroundColor: Colors.blue,
              label: Text('${concentration.amount} ${concentration.unit}'),
              onDeleted: () {
                setState(() {
                  concentrationForm.removeConcentration(concentration);
                });
              },
            ))
        .toList();
  }
}
