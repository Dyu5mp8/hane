// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hane/medications/medication_edit/Concentration_edit/concentration_edit_widget.dart';
import 'package:hane/medications/medication_edit/Concentration_edit/concentration_form.dart';
import 'package:hane/medications/medication_edit/brand_name_edit/brand_name_form.dart';
import 'package:hane/medications/medication_edit/category_edit/category_form.dart';
import 'package:hane/medications/medication_edit/indication_edit_widget.dart';
import 'package:hane/medications/medication_edit/indication_widget_form.dart';
import 'package:hane/medications/medication_edit/medication_detail_form.dart';
import 'package:hane/medications/medication_detail/medication_detail_view.dart';
import 'package:hane/medications/services/medication_list_provider.dart';
import 'package:hane/utils/validate_medication_save.dart' as val;
import 'package:provider/provider.dart';



class MedicationEditDetail extends StatefulWidget {
   final MedicationForm medicationForm;


  const MedicationEditDetail(
      {super.key, required this.medicationForm});

  @override
  _MedicationEditDetailState createState() => _MedicationEditDetailState();
}

class _MedicationEditDetailState extends State<MedicationEditDetail> {
  final _formKey = GlobalKey<FormState>(); // Key for Form
 


  @override
  Widget build(BuildContext context) {
    var medicationListProvider = Provider.of<MedicationListProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Redigera läkemedel"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveMedication(medicationListProvider),
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
                  decoration: const InputDecoration(
                    labelText: 'Läkemedel',
                    hintText: 'Ange generiskt namn',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: val.validateName,
                ),
                TextFormField(
                  controller: widget.medicationForm.contraindicationController,
                  decoration: const InputDecoration(
                    labelText: 'Kontraindikationer',
                    hintText: 'Ange kontraindikationer',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                TextFormField(
                  controller: widget.medicationForm.notesController,
                  decoration: const InputDecoration(
                    labelText: 'Anteckningar',
                    hintText: 'Ange anteckningar',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),

                const SizedBox(height: 40),

                 Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: CategoryWidget(
                    categoryForm: CategoryForm(categories: widget.medicationForm.categories),
                  )
                 ),
                Container(
                  padding: const EdgeInsets.only(left:10),
                
                  child: BrandNameWidget(
                    brandNameForm: BrandNameForm(brandNames: widget.medicationForm.brandNames),
                  ),

        
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: ConcentrationEditPart(
                      concentrationForm: ConcentrationForm(
                          concentrations: widget.medicationForm.concentrations)),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),  
                  child: IndicationEditWidget(
                    
                    indicationForm: IndicationForm(
                        indications: widget.medicationForm.indications),

                  )

                        

                
                ),
                ElevatedButton(
                  onPressed: () => _saveMedication(medicationListProvider),
                  child: const Text('Save Medication'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveMedication(MedicationListProvider provider) {
    if (_formKey.currentState!.validate()) {
      widget.medicationForm.saveMedication(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          closeIconColor: Colors.green,
          content: const Row(
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
    provider.refreshList();
    
  }
}
