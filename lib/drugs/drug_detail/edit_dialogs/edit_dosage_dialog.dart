import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/models/dosage.dart';
import 'package:hane/drugs/models/dose.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/utils/unit_parser.dart';
import 'package:hane/utils/validate_dosage_save.dart' as val;
import 'package:provider/provider.dart';
import 'package:icons_plus/icons_plus.dart';


class EditDosageDialog extends StatefulWidget {
  Dosage dosage;

   final Function(Dosage) onSave; // Callback to notify parent


  EditDosageDialog({required this.dosage, required this.onSave});

  @override
  State<EditDosageDialog> createState() => _EditDosageDialogState();
}

class _EditDosageDialogState extends State<EditDosageDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController instructionController;
  late TextEditingController administrationRouteController;
  late TextEditingController doseAmountController;
  late TextEditingController doseUnitController;
  late TextEditingController lowerLimitDoseAmountController;
  late TextEditingController lowerLimitDoseUnitController;
  late TextEditingController higherLimitDoseAmountController;
  late TextEditingController higherLimitDoseUnitController;
  late TextEditingController maxDoseamountController;
  late TextEditingController maxDoseUnitController;

  @override
  void initState() {
    super.initState();
    instructionController = TextEditingController(text: widget.dosage.instruction ?? "");
    administrationRouteController = TextEditingController(text: widget.dosage.administrationRoute ?? "");
    doseAmountController = TextEditingController(text: widget.dosage.dose?.amount.toString() ?? "");
    doseUnitController = TextEditingController(text: widget.dosage.dose?.unitString() ?? "");
    lowerLimitDoseAmountController = TextEditingController(text: widget.dosage.lowerLimitDose?.amount.toString() ?? "");
    lowerLimitDoseUnitController = TextEditingController(text: widget.dosage.lowerLimitDose?.unitString() ?? "");
    higherLimitDoseAmountController = TextEditingController(text: widget.dosage.higherLimitDose?.amount.toString() ?? "");
    higherLimitDoseUnitController = TextEditingController(text: widget.dosage.higherLimitDose?.unitString() ?? "");
    maxDoseamountController = TextEditingController(text: widget.dosage.maxDose?.amount.toString() ?? "");
    maxDoseUnitController = TextEditingController(text: widget.dosage.maxDose?.unitString() ?? "");
  }

  InputDecoration customInputDecoration(String labelText) {
    return InputDecoration(
      isDense: true,
      labelText: labelText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  ChoiceChip _labelChip(String label, {Icon? icon}) {
    return ChoiceChip(
      avatar: icon,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
        side: BorderSide(color: Theme.of(context).primaryColorLight),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      label: Text(label),
      selected: administrationRouteController.text == label,
      onSelected: (bool selected) {
        setState(() {
          administrationRouteController.text = label;
        });
      },
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      var updatedDosage = Dosage(
        instruction: instructionController.text,
        administrationRoute: administrationRouteController.text,
        dose: _createDose(doseAmountController.text, doseUnitController.text),
        lowerLimitDose: _createDose(lowerLimitDoseAmountController.text, lowerLimitDoseUnitController.text),
        higherLimitDose: _createDose(higherLimitDoseAmountController.text, higherLimitDoseUnitController.text),
        maxDose: _createDose(maxDoseamountController.text, maxDoseUnitController.text),
      );

      // Pass updated dosage back to the parent via the onSave callback
      widget.onSave(updatedDosage);

      // Close the dialog
      Navigator.pop(context);
    }
  }

  Dose? _createDose(String amount, String unit) {
    if (amount.isEmpty || unit.isEmpty) return null;
    return Dose(
        amount: UnitParser.normalizeDouble(amount),
        units: Dose.getDoseUnitsAsMap(unit));
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
                const Text("Administrationsväg"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5.0,
                  runSpacing: -5,
                  children: [
                    _labelChip("PO", icon: const Icon(FontAwesome.pills_solid, size: 11)),
                    _labelChip("IV", icon: const Icon(FontAwesome.syringe_solid, size: 11)),
                    _labelChip("IM", icon: const Icon(FontAwesome.syringe_solid, size: 11)),
                    _labelChip("SC", icon: const Icon(FontAwesome.syringe_solid, size: 11)),
                    _labelChip("Inh", icon: const Icon(FontAwesome.lungs_solid, size: 11)),
                    _labelChip("Annat"),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: instructionController,
                  decoration: customInputDecoration("Instruktion"),
                  minLines: 1,
                  maxLines: 3,
                   // Only enabled when in edit mode
                ),
                const SizedBox(height: 24),
                const Text("Dosering", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: doseAmountController,
                        decoration: customInputDecoration("Mängd"),
                        validator: val.validateAmountInput,
                        
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: doseUnitController,
                        decoration: customInputDecoration("Enhet"),
                        validator: val.validateUnitInput,
                        
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
                        controller: lowerLimitDoseAmountController,
                        decoration: customInputDecoration("Från"),
                        validator: val.validateAmountInput,
                        
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: lowerLimitDoseUnitController,
                        decoration: customInputDecoration("Enhet"),
                        validator: val.validateUnitInput,
                        
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: higherLimitDoseAmountController,
                        decoration: customInputDecoration("Till"),
                        validator: val.validateAmountInput,
                        
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: higherLimitDoseUnitController,
                        decoration: customInputDecoration("Enhet"),
                        validator: val.validateUnitInput,
                        
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
                        controller: maxDoseamountController,
                        decoration: customInputDecoration("Max"),
                        validator: val.validateAmountInput,
                        
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: maxDoseUnitController,
                        decoration: customInputDecoration("Enhet"),
                        validator: val.validateUnitInput,
                        
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
}