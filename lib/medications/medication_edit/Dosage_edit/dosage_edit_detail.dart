import "package:flutter/material.dart";
import "package:hane/medications/medication_edit/Dosage_edit/dosage_detail_form.dart";
import "package:hane/utils/validate_dosage_save.dart" as val;

class DosageEditDetail extends StatefulWidget {
  final DosageDetailForm dosageForm;
  DosageEditDetail({
    required this.dosageForm,
    super.key,
  });

  @override
  State<DosageEditDetail> createState() => _DosageEditDetailState();
}

class _DosageEditDetailState extends State<DosageEditDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double formTextSize = 16.0;
  double formErrorTextSize = 8.0;

  InputDecoration customInputDecoration(String labelText) {
    return InputDecoration(
      isDense: true,
      labelText: labelText,
      labelStyle: TextStyle(fontSize: formTextSize),
      errorStyle: TextStyle(fontSize: formErrorTextSize),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Redigera dosering"),
      content: Container(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Allmän information", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextFormField(
                  controller: widget.dosageForm.administrationRouteController,
                  decoration: customInputDecoration("Administrationsväg"),
                  validator: val.validateTextInput,
                  style: TextStyle(fontSize: formTextSize),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: widget.dosageForm.instructionController,
                  decoration: customInputDecoration("Instruktion"),
                  style: TextStyle(fontSize: formTextSize),
                ),
                SizedBox(height: 24),
                Text("Dosering", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.doseAmountController,
                        decoration: customInputDecoration("Doseringsmängd"),
                        validator: val.validateAmountInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.doseUnitController,
                        decoration: customInputDecoration("Doseringsenhet"),
                        validator: val.validateUnitInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.lowerLimitDoseAmountController,
                        decoration: customInputDecoration("Lägsta dosmängd"),
                        validator: val.validateAmountInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.lowerLimitDoseUnitController,
                        decoration: customInputDecoration("Lägsta dosenhet"),
                        validator: val.validateUnitInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.higherLimitDoseAmountController,
                        decoration: customInputDecoration("Högsta dosmängd"),
                        validator: val.validateAmountInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.higherLimitDoseUnitController,
                        decoration: customInputDecoration("Högsta dosenhet"),
                        validator: val.validateUnitInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text("Maximal dosering", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.maxDoseamountController,
                        decoration: customInputDecoration("Maxdosmängd"),
                        validator: val.validateAmountInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.maxDoseUnitController,
                        decoration: customInputDecoration("Maxdosenhet"),
                        validator: val.validateUnitInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Avbryt"),
        ),
        ElevatedButton(
          onPressed: _saveForm,
          child: const Text("Spara"),
        ),
      ],
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      widget.dosageForm.saveDosage();
      Navigator.pop(context);
    }
  }
}