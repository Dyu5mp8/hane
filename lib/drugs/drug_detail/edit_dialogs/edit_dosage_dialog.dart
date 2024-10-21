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

  late String selectedNumeratorUnit;
  late String selectedDenominatorUnit1;
  late String selectedDenominatorUnit2;

  List<String> numeratorUnits = [];
  List<String> denominatorUnits1 = [];
  List<String> denominatorUnits2 = [];

  Map<String, String> unitDisplayMap = {};

  String? errorMessage; // Variable to hold error message

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

    // Populate units lists using UnitValidator
    Set<String> numeratorUnitsSet = {'-'};
    numeratorUnitsSet.addAll(UnitValidator.validSubstanceUnits().keys);
    numeratorUnits = numeratorUnitsSet.toList();

    Set<String> denominatorUnits1Set = {'-', "kg"};
    denominatorUnits1 = denominatorUnits1Set.toList();

    Set<String> denominatorUnits2Set = {'-'};
    denominatorUnits2Set.addAll(UnitValidator.validTimeUnits().keys);
    denominatorUnits2 = denominatorUnits2Set.toList();

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
      numeratorUnits.add(selectedNumeratorUnit);
    }
    if (!denominatorUnits1.contains(selectedDenominatorUnit1)) {
      denominatorUnits1.add(selectedDenominatorUnit1);
    }
    if (!denominatorUnits2.contains(selectedDenominatorUnit2)) {
      denominatorUnits2.add(selectedDenominatorUnit2);
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
  }void _saveForm() {
  setState(() {
    errorMessage = null; // Reset error message
  });

  // Check if fields are filled
  bool isDoseAmountFilled = doseAmountController.text.isNotEmpty;
  bool isFromAndToFilled = lowerLimitDoseAmountController.text.isNotEmpty &&
      higherLimitDoseAmountController.text.isNotEmpty;
  bool isFromAndToNotBothFilled =
      lowerLimitDoseAmountController.text.isNotEmpty && higherLimitDoseAmountController.text.isEmpty || lowerLimitDoseAmountController.text.isEmpty && higherLimitDoseAmountController.text.isNotEmpty;
  bool isInstructionFilled = instructionController.text.isNotEmpty;
  bool isUnitFilled = selectedNumeratorUnit != '-' && selectedNumeratorUnit.isNotEmpty;

  // Rule 1: You must have either a valid dose or a valid instruction.
  if (!isDoseAmountFilled && !isFromAndToFilled && !isInstructionFilled) {
    setState(() {
      errorMessage =
          'Du måste fylla i antingen dos eller både från och till doser. Alternativt skriv endast i instruktionsfältet.';
    });
    return;
  }

  // Rule 2: If a dose is filled, it must be valid.
  if (isDoseAmountFilled) {
    double? doseAmount = double.tryParse(doseAmountController.text.replaceAll(",", "."));
    if (doseAmount == null) {
      setState(() {
        errorMessage = 'Dosmängden måste vara ett giltigt nummer.';
      });
      return;
    }
  }

  // Rule 3: If from/to dose is filled, both must be valid.
  if (isFromAndToNotBothFilled) {
    setState(() {
      errorMessage = 'Du måste fylla i både från och till doser.';
    });
    return;
  }

  if (isFromAndToFilled) {
    double? lowerLimit = double.tryParse(lowerLimitDoseAmountController.text.replaceAll(",", "."));
    double? higherLimit = double.tryParse(higherLimitDoseAmountController.text.replaceAll(",", "."));
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

  // Rule 4: If an instruction is filled and no dose is provided, units should not be filled
  if (isInstructionFilled && !isDoseAmountFilled && !isFromAndToFilled && isUnitFilled) {
    setState(() {
      errorMessage = 'Du kan inte välja en enhet utan att fylla i dosen.';
      
    });
    return;
  }

  // Rule 5: Ensure a valid unit is selected if any dose value is provided
  if ((isDoseAmountFilled || isFromAndToFilled) &&
      (selectedNumeratorUnit == '-' || selectedNumeratorUnit.isEmpty)) {
    setState(() {
      errorMessage = 'Du måste välja en primär enhet för doseringen om dos anges.';
      
    });
    return;
  }

  // If all validations pass, proceed to create the dosage object
  var updatedDosage = Dosage(
    instruction: instructionController.text,
    administrationRoute: administrationRouteController.text,
    dose: _createDose(doseAmountController.text),
    lowerLimitDose: _createDose(lowerLimitDoseAmountController.text),
    higherLimitDose: _createDose(higherLimitDoseAmountController.text),
  );

  // Pass updated dosage back to the parent via the onSave callback
  widget.onSave(updatedDosage);

  // Close the dialog
  Navigator.pop(context);
}

  Dose? _createDose(String amount) {
    String unit = getUnitString();
    if (amount.isEmpty || unit.isEmpty) return null;
    double? normalizedAmount = UnitParser.normalizeDouble(amount);
    if (normalizedAmount == null) {
      setState(() {
        errorMessage = 'Ange en giltig dosmängd.';
      });
      return null;
    }

    return Dose.fromString(
        amount: normalizedAmount,
        unit: unit);
  }

  String getUnitString() {
    List<String> units = [];
    if (selectedNumeratorUnit != '-') {
      units.add(selectedNumeratorUnit);
    }
    if (selectedDenominatorUnit1 != '-') {
      units.add(selectedDenominatorUnit1);
    }
    if (selectedDenominatorUnit2 != '-') {
      units.add(selectedDenominatorUnit2);
    }
    return units.join('/');
  }

  String getUnitDisplayName(String unit) {
    return unitDisplayMap[unit] ?? unit;
  }

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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: items.map((String unit) {
            return DropdownMenuItem<String>(
              value: unit,
              child: Text(
                getUnitDisplayName(unit),
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          menuMaxHeight: 300,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle labelTextStyle = TextStyle(fontSize: 15);
    const TextStyle errorTextStyle = TextStyle(color: Color.fromARGB(255, 127, 11, 0));

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
                      value: selectedDenominatorUnit1,
                      items: denominatorUnits1,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDenominatorUnit1 = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text("/"),
                    const SizedBox(width: 8),
                    buildDropdownButtonFormField(
                      value: selectedDenominatorUnit2,
                      items: denominatorUnits2,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDenominatorUnit2 = newValue!;
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
                      flex: 1,
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
                      flex: 1,
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
                      flex: 1,
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
                if (errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    errorMessage!,
                    style: errorTextStyle,
                  ),
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