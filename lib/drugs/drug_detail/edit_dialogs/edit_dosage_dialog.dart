import 'package:flutter/material.dart';

import 'package:hane/drugs/models/drug.dart';
import 'package:hane/utils/unit_parser.dart';
import 'package:hane/utils/unit_validator.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';

class EditDosageDialog extends StatefulWidget {
  final Dosage dosage;
  final Function(Dosage) onSave; // Callback to notify parent

  EditDosageDialog({super.key, required this.dosage, required this.onSave});

  @override
  State<EditDosageDialog> createState() => _EditDosageDialogState();
}

class _EditDosageDialogState extends State<EditDosageDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController instructionController;
  late TextEditingController administrationRouteController;
  late TextEditingController doseAmountController;
  late TextEditingController lowerLimitDoseAmountController;
  late TextEditingController higherLimitDoseAmountController;
  // Removed maxDoseamountController since we're not focusing on it now

  String? selectedNumeratorUnit;
  String? selectedDenominatorUnit1;
  String? selectedDenominatorUnit2;

  List<String> numeratorUnits = [];
  List<String> denominatorUnits1 = [];
  List<String> denominatorUnits2 = [];

  Map<String, String> unitDisplayMap = {};

  @override
  void initState() {
    super.initState();
    instructionController =
        TextEditingController(text: widget.dosage.instruction ?? "");
    administrationRouteController =
        TextEditingController(text: widget.dosage.administrationRoute ?? "");
    doseAmountController = TextEditingController(
        text: widget.dosage.dose?.amount.toString() ?? "");
    lowerLimitDoseAmountController = TextEditingController(
        text: widget.dosage.lowerLimitDose?.amount.toString() ?? "");
    higherLimitDoseAmountController = TextEditingController(
        text: widget.dosage.higherLimitDose?.amount.toString() ?? "");
    // Removed maxDoseamountController initialization

    // Populate units lists using UnitValidator
    numeratorUnits = ['-']; // Placeholder and default selection
    numeratorUnits.addAll(UnitValidator.validSubstanceUnits().keys);

    denominatorUnits1 = ['-', 'kg']; // Placeholder and default selection

    denominatorUnits2 = ['-']; // Placeholder and default selection
    denominatorUnits2.addAll(UnitValidator.validTimeUnits().keys);

    // Create unit display map
    unitDisplayMap = {
      'mikrog': 'μg',
      // Add other mappings if needed
    };

    // Parse the unit string from the dosage
    String? unitString = widget.dosage.dose?.unitString() ??
        widget.dosage.lowerLimitDose?.unitString() ??
        widget.dosage.higherLimitDose?.unitString();

    List<String> unitParts = unitString?.split('/') ?? [];

    // Set default units if not present
    selectedNumeratorUnit =
        unitParts.isNotEmpty ? unitParts[0] : numeratorUnits.first;
    selectedDenominatorUnit1 = (unitParts.length > 1 && unitParts[1].isNotEmpty)
        ? unitParts[1]
        : denominatorUnits1.first;
    selectedDenominatorUnit2 = (unitParts.length > 2 && unitParts[2].isNotEmpty)
        ? unitParts[2]
        : denominatorUnits2.first;

    // Ensure units are valid
    if (!numeratorUnits.contains(selectedNumeratorUnit)) {
      numeratorUnits.add(selectedNumeratorUnit!);
    }
    if (!denominatorUnits1.contains(selectedDenominatorUnit1)) {
      denominatorUnits1.add(selectedDenominatorUnit1!);
    }
    if (!denominatorUnits2.contains(selectedDenominatorUnit2)) {
      denominatorUnits2.add(selectedDenominatorUnit2!);
    }
  }

  InputDecoration customInputDecoration(
      {String? labelText, String? suffixText, String? prefixText}) {
    return InputDecoration(
      isDense: true,
      labelText: labelText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixText: suffixText,
      prefixText: prefixText,
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
      selectedColor: const Color.fromARGB(255, 234, 166, 94),
      selected: administrationRouteController.text == label,
      onSelected: (bool selected) {
        setState(() {
          administrationRouteController.text = label;
        });
      },
    );
  }

  void _saveForm() {
    // Validation logic
    bool isDoseAmountFilled = doseAmountController.text.isNotEmpty;
    bool isFromAndToFilled = lowerLimitDoseAmountController.text.isNotEmpty &&
        higherLimitDoseAmountController.text.isNotEmpty;
    if (!isDoseAmountFilled && !isFromAndToFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Du måste fylla i antingen dos eller från och till doser.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    var updatedDosage = Dosage(
      instruction: instructionController.text,
      administrationRoute: administrationRouteController.text,
      dose: _createDose(doseAmountController.text),
      lowerLimitDose: _createDose(lowerLimitDoseAmountController.text),
      higherLimitDose: _createDose(higherLimitDoseAmountController.text),
      // maxDose: _createDose(maxDoseamountController.text), // Ignored as per instruction
    );

    // Pass updated dosage back to the parent via the onSave callback
    widget.onSave(updatedDosage);

    // Close the dialog
    Navigator.pop(context);
  }

  Dose? _createDose(String amount) {
    String unit = getUnitString();
    if (amount.isEmpty || unit.isEmpty) return null;
    return Dose(
        amount: UnitParser.normalizeDouble(amount),
        units: Dose.getDoseUnitsAsMap(unit));
  }

  String getUnitString() {
    List<String> units = [];
    if (selectedNumeratorUnit != null && selectedNumeratorUnit != '-') {
      units.add(selectedNumeratorUnit!);
    }
    if (selectedDenominatorUnit1 != null &&
        selectedDenominatorUnit1 != '-') {
      units.add(selectedDenominatorUnit1!);
    }
    if (selectedDenominatorUnit2 != null &&
        selectedDenominatorUnit2 != '-') {
      units.add(selectedDenominatorUnit2!);
    }
    return units.join('/');
  }

  String getUnitDisplayName(String unit) {
    return unitDisplayMap[unit] ?? unit;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle dropdownTextStyle = TextStyle(fontSize: 12); // Smaller text

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
                const Text("Allmänt",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("Administrationsväg"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5.0,
                  runSpacing: -5,
                  children: [
                    _labelChip("PO",
                        icon: const Icon(FontAwesome.pills_solid, size: 11)),
                    _labelChip("IV",
                        icon:
                            const Icon(FontAwesome.syringe_solid, size: 11)),
                    _labelChip("IM",
                        icon:
                            const Icon(FontAwesome.syringe_solid, size: 11)),
                    _labelChip("SC",
                        icon:
                            const Icon(FontAwesome.syringe_solid, size: 11)),
                    _labelChip("Inh",
                        icon: const Icon(FontAwesome.lungs_solid, size: 11)),
                    _labelChip("Annat"),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: instructionController,
                  decoration:
                      customInputDecoration(labelText: "Instruktion"),
                  minLines: 1,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                const Text.rich(
                  TextSpan(
                    text: "Enhet",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          value: selectedNumeratorUnit,
                          isExpanded: true,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          items: numeratorUnits.map((String unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(
                                getUnitDisplayName(unit),
                                style: dropdownTextStyle,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedNumeratorUnit = newValue;
                            });
                          },
                          // Remove animation
                          dropdownColor: Theme.of(context).cardColor,
                          menuMaxHeight: 300,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("/"),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          value: selectedDenominatorUnit1,
                          isExpanded: true,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          items: denominatorUnits1.map((String unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(
                                getUnitDisplayName(unit),
                                style: dropdownTextStyle,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDenominatorUnit1 = newValue;
                            });
                          },
                          // Remove animation
                      
                          menuMaxHeight: 300,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("/"),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          value: selectedDenominatorUnit2,
                          isExpanded: true,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          items: denominatorUnits2.map((String unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(
                                getUnitDisplayName(unit),
                                style: dropdownTextStyle,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDenominatorUnit2 = newValue;
                            });
                          },
                          // Remove animation
                        
                          menuMaxHeight: 300,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text("Dosering och intervall",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: AutoSizeTextField(
                        controller: doseAmountController,
                        decoration: customInputDecoration(),
                        style: TextStyle(fontSize: 16),
                        minFontSize: 12,
                        maxLines: 1,
                        maxLength: 5,
                        buildCounter: (context,
                                {required int currentLength,
                                required bool isFocused,
                                required int? maxLength}) =>
                            null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text("(", style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: AutoSizeTextField(
                        controller: lowerLimitDoseAmountController,
                        decoration: customInputDecoration(),
                        style: TextStyle(fontSize: 16),
                        minFontSize: 12,
                        maxLines: 1,
                        maxLength: 5,
                        buildCounter: (context,
                                {required int currentLength,
                                required bool isFocused,
                                required int? maxLength}) =>
                            null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text("-", style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: AutoSizeTextField(
                        controller: higherLimitDoseAmountController,
                        decoration: customInputDecoration(),
                        style: TextStyle(fontSize: 16),
                        minFontSize: 12,
                        maxLines: 1,
                        maxLength: 5,
                        buildCounter: (context,
                                {required int currentLength,
                                required bool isFocused,
                                required int? maxLength}) =>
                            null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(") ${getUnitString()}",
                        style: TextStyle(fontSize: 18)),
                  ],
                ),
                // Removed Max Dose section as per instruction
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