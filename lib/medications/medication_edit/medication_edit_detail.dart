import 'package:flutter/material.dart';
import 'package:hane/medications/medication_edit/Concentration_edit/concentration_edit_widget.dart';
import 'package:hane/medications/medication_edit/Concentration_edit/concentration_form.dart';
import 'package:hane/medications/medication_edit/indication_edit_widget.dart';
import 'package:hane/medications/medication_edit/indication_widget_form.dart';
import 'package:hane/medications/medication_edit/medication_detail_form.dart';
import 'package:hane/medications/views/medication_detail_view/medication_detail_view.dart';
import 'package:hane/utils/validate_medication_save.dart' as val;

class MedicationEditDetail extends StatefulWidget {
   MedicationForm medicationForm;

  MedicationEditDetail(
      {Key? key, required this.medicationForm})
      : super(key: key);

  @override
  _MedicationEditDetailState createState() => _MedicationEditDetailState();
}

class _MedicationEditDetailState extends State<MedicationEditDetail> {
  final _formKey = GlobalKey<FormState>(); // Key for Form


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Redigera läkemedel"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveMedication(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: widget.medicationForm.nameController,
                  decoration: InputDecoration(
                    labelText: 'Läkemedel',
                    hintText: 'Ange generiskt namn',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: val.validateName,
                ),
                TextFormField(
                  controller: widget.medicationForm.contraindicationController,
                  decoration: InputDecoration(
                    labelText: 'Kontraindikationer',
                    hintText: 'Ange kontraindikationer',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                TextFormField(
                  controller: widget.medicationForm.notesController,
                  decoration: InputDecoration(
                    labelText: 'Anteckningar',
                    hintText: 'Ange anteckningar',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: ConcentrationEditPart(
                      concentrationForm: ConcentrationForm(
                          concentrations: widget.medicationForm.concentrations)),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20),  
                  child: IndicationEditWidget(
                    
                    indicationForm: IndicationForm(
                        indications: widget.medicationForm.indications),

                  )

                        

                
                ),
                ElevatedButton(
                  onPressed: () => _saveMedication(),
                  child: Text('Save Medication'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveMedication() {
    if (_formKey.currentState!.validate()) {
      widget.medicationForm.saveMedication();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          closeIconColor: Colors.green,
          content: Row(
            children: [
              Icon(Icons.check_box, color: Colors.green),
              Text("Ändringar sparade!"),
            ],
          ),
          action: SnackBarAction(
            label: 'Förhandsgranska resultat',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MedicationDetailView(medication: widget.medicationForm.createMedication(),
                        ),
                  ));

              // Code to execute.
            },
          ),
        ),
      );
    }
  }
}
