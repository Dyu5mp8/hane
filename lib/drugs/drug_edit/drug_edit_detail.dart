import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hane/drugs/drug_edit/Concentration_edit/concentration_edit_widget.dart';
import 'package:hane/drugs/drug_edit/Concentration_edit/concentration_form.dart';
import 'package:hane/drugs/drug_edit/brand_name_edit/brand_name_form.dart';
import 'package:hane/drugs/drug_edit/category_edit/category_form.dart';
import 'package:hane/drugs/drug_edit/indication_edit_widget.dart';
import 'package:hane/drugs/drug_edit/indication_widget_form.dart';
import 'package:hane/drugs/drug_edit/drug_detail_form.dart';
import 'package:hane/drugs/drug_detail/drug_detail_view.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/utils/validate_drug_save.dart' as val;
import 'package:provider/provider.dart';

class DrugEditDetail extends StatefulWidget {
  final DrugForm drugForm;

  const DrugEditDetail({super.key, required this.drugForm});

  @override
  _DrugEditDetailState createState() => _DrugEditDetailState();
}

class _DrugEditDetailState extends State<DrugEditDetail> {
  final _formKey = GlobalKey<FormState>(); // Key for Form

  @override
  Widget build(BuildContext context) {
    var drugListProvider = Provider.of<DrugListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Redigera läkemedel"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
         onPressed: () {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Spara?'),
        content: const Text('Vill du spara ändringarna?'),
        actions: [
          TextButton(
            onPressed: () {
              _saveDrug(drugListProvider);
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Ja'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Close the screen
            },
            child: const Text('Nej'),
          ),
        ],
      );
    },
  );
},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveDrug(drugListProvider),
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
                  controller: widget.drugForm.nameController,
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
                  controller: widget.drugForm.contraindicationController,
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
                  controller: widget.drugForm.notesController,
                  
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
                    categories: widget.drugForm.categories,
                  ),
                ),
                SizedBox(height: 16),
                BrandNameWidget(
                  brandNameForm: BrandNameForm(
                    brandNames: widget.drugForm.brandNames,
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
                    concentrations: widget.drugForm.concentrations,
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
                    indications: widget.drugForm.indications,
                  ),
                ),
                SizedBox(height: 40),

                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: () => _saveDrug(drugListProvider),
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

  void _onBackPressed() {
    Navigator.pop(context);
  }

  void _saveDrug(DrugListProvider provider) {
    if (_formKey.currentState!.validate()) {
      widget.drugForm.saveDrug(context);

    Navigator.pop(context);
  }

  }
}