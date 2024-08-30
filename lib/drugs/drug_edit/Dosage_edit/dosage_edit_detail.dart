import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_edit/Dosage_edit/dosage_detail_form.dart';
import 'package:hane/utils/validate_dosage_save.dart' as val;
import 'package:icons_plus/icons_plus.dart';

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
  double chipTextSize = 12.0;

  InputDecoration customInputDecoration(String labelText) {
    return InputDecoration(
      isDense: true,
      labelText: labelText,
      labelStyle: TextStyle(fontSize: formTextSize),
      errorStyle: TextStyle(fontSize: formErrorTextSize),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      errorMaxLines: 2,
    );
  }


  ChoiceChip _labelChip (String label, {Icon? icon}) {
    return ChoiceChip(
      avatar: icon,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
        side: BorderSide(color: Theme.of(context).primaryColorLight),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      label: Text(label, style: TextStyle(fontSize: chipTextSize)),
      selected: widget.dosageForm.administrationRouteController.text == label,
      labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      onSelected: (bool selected) {
        setState(() {
          widget.dosageForm.administrationRouteController.text = label;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Redigera dosering"),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Allmänt", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                
                // Wrap for Segmented Buttons
                const Text("Administrationsväg"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5.0, // Horizontal spacing between chips
                  runSpacing: -5, // Vertical spacing between rows of chips
                  children: [
                    _labelChip("PO", icon: const Icon(FontAwesome.pills_solid, size: 11,)),
                    _labelChip("IV", icon: const Icon(FontAwesome.syringe_solid, size: 11)),
                    _labelChip("IM", icon: const Icon(FontAwesome.syringe_solid, size: 11)),
                    _labelChip("SC", icon: const Icon(FontAwesome.syringe_solid, size: 11)),
                    _labelChip("Inh", icon: const Icon(FontAwesome.lungs_solid, size: 11)),
                    _labelChip("Annat"),
                  ],
                ),
                
                const SizedBox(height: 16),
                TextFormField(
                  controller: widget.dosageForm.instructionController,
                  decoration: customInputDecoration("Instruktion"),
                  style: TextStyle(fontSize: formTextSize),
                  minLines: 1,
                  maxLines: 3
                ),
                const SizedBox(height: 24),
                const Text("Dosering", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.doseAmountController,
                        decoration: customInputDecoration("Mängd"),
                        validator: val.validateAmountInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.doseUnitController,
                        decoration: customInputDecoration("Enhet"),
                        validator: val.validateUnitInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text("Dosintervall", style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.lowerLimitDoseAmountController,
                        decoration: customInputDecoration("Från"),
                        validator: val.validateAmountInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.lowerLimitDoseUnitController,
                        decoration: customInputDecoration("Enhet"),
                        validator: val.validateUnitInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.higherLimitDoseAmountController,
                        decoration: customInputDecoration("Till"),
                        validator: val.validateAmountInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.higherLimitDoseUnitController,
                        decoration: customInputDecoration("Enhet"),
                        validator: val.validateUnitInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text("Maximal dosering (tak)", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.maxDoseamountController,
                        decoration: customInputDecoration("Max"),
                        validator: val.validateAmountInput,
                        style: TextStyle(fontSize: formTextSize),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: widget.dosageForm.maxDoseUnitController,
                        decoration: customInputDecoration("Enhet"),
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