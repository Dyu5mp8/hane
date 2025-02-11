import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';

import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/models/units.dart';
import 'package:hane/utils/unit_parser.dart';
import 'package:hane/utils/unit_validator.dart';

class EditDosageDialog extends StatefulWidget {
  final Dosage dosage;
  final Function(Dosage) onSave; // Callback to notify parent

  const EditDosageDialog({
    Key? key,
    required this.dosage,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditDosageDialog> createState() => _EditDosageDialogState();
}

class _EditDosageDialogState extends State<EditDosageDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  late TextEditingController instructionController;
  late TextEditingController administrationRouteController;
  late TextEditingController doseAmountController;
  late TextEditingController lowerLimitDoseAmountController;
  late TextEditingController higherLimitDoseAmountController;
  late TextEditingController maxDoseAmountController;

  // Dropdown selections for units
  late String selectedNumeratorUnit;
  late String selectedDenomUnit1;
  late String selectedDenomUnit2;

  // Lists for dropdown options
  late List<String> numeratorUnits;
  late List<String> denominatorUnits1;
  late List<String> denominatorUnits2;

  // Map for displaying unit names (optional – can be used to customize labels)
  late Map<String, String> unitDisplayMap;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    // Initialize text controllers using values from the passed-in dosage
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
    maxDoseAmountController = TextEditingController(
        text: widget.dosage.maxDose?.amount.toString() ?? "");

    // Build numerator units from all available substance units.
    // We also include a placeholder '-' value.
    final numSet = <String>{'-'};
    numSet.addAll(SubstanceUnit.allUnits.map((unit) => unit.toString()));
    numeratorUnits = numSet.toList();

    // For denominator units we use the WeightUnit and TimeUnit enums.
    // (These lists can be easily updated if additional denominator unit types are needed.)
    denominatorUnits1 = {'-', ...WeightUnit.values.map((e) => e.toString())}.toList();
    denominatorUnits2 = {'-', ...TimeUnit.values.map((e) => e.toString())}.toList();

    // Optionally, build a unit display map if you need to customize labels.
    unitDisplayMap = {
      for (var unit in SubstanceUnit.allUnits) unit.toString(): unit.toString()
    };

    // Get the currently stored unit string from the dosage.
    String? unitString = widget.dosage.dose?.unitString ??
        widget.dosage.lowerLimitDose?.unitString ??
        widget.dosage.higherLimitDose?.unitString;
    final parts = unitString?.split('/') ?? [];

    // Set default selections from the parsed unit string, if available.
    selectedNumeratorUnit = parts.isNotEmpty ? parts[0] : numeratorUnits.first;
    selectedDenomUnit1 = parts.length > 1 && parts[1].isNotEmpty
        ? parts[1]
        : denominatorUnits1.first;
    selectedDenomUnit2 = parts.length > 2 && parts[2].isNotEmpty
        ? parts[2]
        : denominatorUnits2.first;

    // Ensure the currently selected units are in the dropdown lists.
    if (!numeratorUnits.contains(selectedNumeratorUnit)) {
      numeratorUnits.add(selectedNumeratorUnit);
    }
    if (!denominatorUnits1.contains(selectedDenomUnit1)) {
      denominatorUnits1.add(selectedDenomUnit1);
    }
    if (!denominatorUnits2.contains(selectedDenomUnit2)) {
      denominatorUnits2.add(selectedDenomUnit2);
    }
  }

  InputDecoration customInputDecoration({
    String? labelText,
    String? suffixText,
    String? prefixText,
  }) {
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

  /// Builds a dropdown for unit selection.
  Widget buildDropdownButtonFormField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Expanded(
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: items
              .map((unit) => DropdownMenuItem<String>(
                    value: unit,
                    child: Text(
                      unitDisplayMap[unit] ?? unit,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          menuMaxHeight: 300,
        ),
      ),
    );
  }

  /// Builds the complete unit string from the selected dropdown values.
  String getUnitString() {
    final units = <String>[];
    if (selectedNumeratorUnit != '-') units.add(selectedNumeratorUnit);
    if (selectedDenomUnit1 != '-') units.add(selectedDenomUnit1);
    if (selectedDenomUnit2 != '-') units.add(selectedDenomUnit2);
    return units.join('/');
  }

  /// Creates a Dose from the provided amount text and currently selected unit string.
  Dose? _createDose(String amountText) {
    if (amountText.isEmpty || getUnitString().isEmpty) return null;
    final normalizedAmount = UnitParser.normalizeDouble(amountText);
    return Dose.fromString(normalizedAmount, getUnitString());
  }

  void _saveForm() {
    setState(() {
      errorMessage = null; // Reset error message.
    });

    // Perform validations.
    bool isDoseFilled = doseAmountController.text.isNotEmpty;
    bool isFromAndToFilled = lowerLimitDoseAmountController.text.isNotEmpty &&
        higherLimitDoseAmountController.text.isNotEmpty;
    bool isInstructionFilled = instructionController.text.isNotEmpty;
    bool isMaxDoseFilled = maxDoseAmountController.text.isNotEmpty;
    bool isUnitFilled = selectedNumeratorUnit != '-' && selectedNumeratorUnit.isNotEmpty;

    if (!isDoseFilled && !isFromAndToFilled && !isInstructionFilled) {
      setState(() {
        errorMessage =
            'Du måste fylla i antingen dos eller både från och till doser. Alternativt skriv endast i instruktionsfältet.';
      });
      return;
    }

    if (isDoseFilled) {
      if (double.tryParse(doseAmountController.text.replaceAll(",", ".")) == null) {
        setState(() {
          errorMessage = 'Dosmängden måste vara ett giltigt nummer.';
        });
        return;
      }
    }

    if ((lowerLimitDoseAmountController.text.isNotEmpty) ^
        (higherLimitDoseAmountController.text.isNotEmpty)) {
      setState(() {
        errorMessage = 'Du måste fylla i både från och till doser.';
      });
      return;
    }

    if (lowerLimitDoseAmountController.text.isNotEmpty &&
        higherLimitDoseAmountController.text.isNotEmpty) {
      final lowerLimit = double.tryParse(lowerLimitDoseAmountController.text.replaceAll(",", "."));
      final higherLimit = double.tryParse(higherLimitDoseAmountController.text.replaceAll(",", "."));
      if (lowerLimit == null || higherLimit == null) {
        setState(() {
          errorMessage = 'Från och till doserna måste vara giltiga nummer.';
        });
        return;
      }
      if (lowerLimit > higherLimit) {
        setState(() {
          errorMessage = 'Från dosen kan inte vara större än till dosen.';
        });
        return;
      }
    }

    if (isInstructionFilled && !isDoseFilled && !isFromAndToFilled && isUnitFilled) {
      setState(() {
        errorMessage = 'Du kan inte välja en enhet utan att fylla i dosen.';
      });
      return;
    }

    Dose? maxDose;
    if (isMaxDoseFilled) {
      final tempDose = _createDose(maxDoseAmountController.text);
      if (tempDose != null) {
        // Here you might remove weight-specific keys if needed.
        maxDose = tempDose;
      }
    }

    // Create the updated Dosage using our improved models.
    final updatedDosage = Dosage(
      instruction: instructionController.text,
      administrationRoute: administrationRouteController.text,
      dose: _createDose(doseAmountController.text),
      lowerLimitDose: _createDose(lowerLimitDoseAmountController.text),
      higherLimitDose: _createDose(higherLimitDoseAmountController.text),
      maxDose: maxDose,
    );

    // Pass the updated dosage back to the parent.
    widget.onSave(updatedDosage);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const labelTextStyle = TextStyle(fontSize: 15);
    const errorTextStyle = TextStyle(color: Color.fromARGB(255, 127, 11, 0));

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
                  textCapitalization: TextCapitalization.sentences,
                  controller: instructionController,
                  decoration: customInputDecoration(labelText: "Instruktion"),
                  minLines: 1,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                const Text.rich(
                  TextSpan(
                    text: "Enhet",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [TextSpan(text: ' *', style: TextStyle(color: Colors.red))],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    buildDropdownButtonFormField(
                      value: selectedNumeratorUnit,
                      items: numeratorUnits,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedNumeratorUnit = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text("/"),
                    const SizedBox(width: 8),
                    buildDropdownButtonFormField(
                      value: selectedDenomUnit1,
                      items: denominatorUnits1,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDenomUnit1 = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text("/"),
                    const SizedBox(width: 8),
                    buildDropdownButtonFormField(
                      value: selectedDenomUnit2,
                      items: denominatorUnits2,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDenomUnit2 = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text("Dosering och intervall", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AutoSizeTextField(
                        controller: doseAmountController,
                        decoration: customInputDecoration(),
                        style: const TextStyle(fontSize: 16),
                        minFontSize: 12,
                        maxLines: 1,
                        maxLength: 5,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        buildCounter: (context, {required int currentLength, required bool isFocused, required int? maxLength}) => null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text("(", style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AutoSizeTextField(
                        controller: lowerLimitDoseAmountController,
                        decoration: customInputDecoration(),
                        style: const TextStyle(fontSize: 16),
                        minFontSize: 12,
                        maxLines: 1,
                        maxLength: 5,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        buildCounter: (context, {required int currentLength, required bool isFocused, required int? maxLength}) => null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("-", style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AutoSizeTextField(
                        controller: higherLimitDoseAmountController,
                        decoration: customInputDecoration(),
                        style: const TextStyle(fontSize: 16),
                        minFontSize: 12,
                        maxLines: 1,
                        maxLength: 5,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        buildCounter: (context, {required int currentLength, required bool isFocused, required int? maxLength}) => null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(") ${getUnitString()}", style: labelTextStyle),
                  ],
                ),
                const SizedBox(height: 16),
                const Text("Maxdos"),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: AutoSizeTextField(
                        controller: maxDoseAmountController,
                        decoration: customInputDecoration(),
                        style: const TextStyle(fontSize: 16),
                        minFontSize: 12,
                        maxLines: 1,
                        maxLength: 5,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        buildCounter: (context, {required int currentLength, required bool isFocused, required int? maxLength}) => null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(getUnitString().replaceAll("/kg", ""), style: labelTextStyle),
                  ],
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(errorMessage!, style: errorTextStyle),
                ],
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