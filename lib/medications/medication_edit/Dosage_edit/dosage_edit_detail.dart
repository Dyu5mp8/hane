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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double formTextSize = 16.0;
  double formErrorTextSize = 8.0;
  double helperTextSize = 10;

  customInputDecoration(String labelText) {
    return InputDecoration(
      isDense: true,
      labelText: labelText,
      labelStyle: TextStyle(fontSize: formTextSize),
      errorStyle: TextStyle(fontSize: formErrorTextSize),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      helper: Text(" ", style: TextStyle(fontSize: formErrorTextSize)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Redigera dosering"),
      content: Container(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: widget.dosageForm.administrationRouteController,
                decoration: customInputDecoration("Administrationsväg"),
                validator: val.validateTextInput,
                style: TextStyle(fontSize: formTextSize),
              ),
              TextFormField(
                controller: widget.dosageForm.instructionController,
                decoration: customInputDecoration("Instruktion"),
                style: TextStyle(fontSize: formTextSize),
              ),
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller:
                          widget.dosageForm.lowerLimitDoseAmountController,
                      decoration: customInputDecoration("Lägsta dosmängd"),
                      validator: val.validateAmountInput,
                      style: TextStyle(fontSize: formTextSize),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller:
                          widget.dosageForm.lowerLimitDoseUnitController,
                      decoration: customInputDecoration("Lägsta dosmängd"),
                      validator: val.validateUnitInput,
                      style: TextStyle(fontSize: formTextSize),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller:
                          widget.dosageForm.higherLimitDoseAmountController,
                      decoration: customInputDecoration("Högsta dosmängd"),
                      validator: val.validateAmountInput,
                      style: TextStyle(fontSize: formTextSize),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller:
                          widget.dosageForm.higherLimitDoseUnitController,
                      decoration: customInputDecoration("Högsta dosmängd"),
                      validator: val.validateUnitInput,
                      style: TextStyle(fontSize: formTextSize),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: widget.dosageForm.maxDoseamountController,
                decoration: customInputDecoration("Maxdosmängd"),
                validator: val.validateAmountInput,
                style: TextStyle(fontSize: formTextSize),
              ),
              TextFormField(
                controller: widget.dosageForm.maxDoseUnitController,
                decoration: customInputDecoration("Maxdosmängd"),
                validator: val.validateUnitInput,
                style: TextStyle(fontSize: formTextSize),
              ),
            ]),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Avbryt"),
        ),
        ElevatedButton(
          onPressed: _saveForm,
          child: Text("Spara"),
        ),
      ],
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      widget.dosageForm.saveDosage();
      Navigator.pop(context);
      ;
    }
  }
}
