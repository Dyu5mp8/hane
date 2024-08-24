import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  const MedicationEditDetail({super.key, required this.medicationForm});

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
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Section: Basic Information
                SizedBox(height: 8),
                TextFormField(
                  controller: widget.medicationForm.nameController,
                  decoration: InputDecoration(
                    labelText: 'Läkemedel',
                    hintText: 'Ange generiskt namn',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: val.validateName,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: widget.medicationForm.contraindicationController,
                  decoration: InputDecoration(
                    labelText: 'Kontraindikationer',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    hintText: 'Ange kontraindikationer och varningar',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    
                  ),
                  minLines: 1,
                    maxLines: 4,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: widget.medicationForm.notesController,
                  
                  decoration: InputDecoration(
                    labelText: 'Anteckningar',
                    hintText: 'Ange anteckningar',
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  minLines: 1,
                  maxLines: 4,
                ),
                SizedBox(height: 24),

                CategoryWidget(
                  categoryForm: CategoryForm(
                    categories: widget.medicationForm.categories,
                  ),
                ),
                SizedBox(height: 16),
                BrandNameWidget(
                  brandNameForm: BrandNameForm(
                    brandNames: widget.medicationForm.brandNames,
                  ),
                ),
                SizedBox(height: 24),

                // Section: Concentration
                Text(
                  "Koncentration",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                ConcentrationEditPart(
                  concentrationForm: ConcentrationForm(
                    concentrations: widget.medicationForm.concentrations,
                  ),
                ),
                SizedBox(height: 24),

                // Section: Indication
                Text(
                  "Indikation",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                IndicationEditWidget(
                  indicationForm: IndicationForm(
                    indications: widget.medicationForm.indications,
                  ),
                ),
                SizedBox(height: 40),

                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: () => _saveMedication(medicationListProvider),
                    child: const Text('Spara läkemedel'),
                  ),
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
              SizedBox(width: 8),
              Text("Ändringar sparade!"),
            ],
          ),
          action: SnackBarAction(
            label: 'Förhandsgranska resultat',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicationDetailView(
                    medication: widget.medicationForm.createMedication(),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    provider.refreshList();
    Navigator.pop(context);
  }

}