import 'package:flutter/material.dart';
import 'package:hane/drugs/models/administration_route.dart';
import 'package:hane/ui_components/route_icons.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';

import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/models/units.dart';

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
  late TextEditingController doseAmountController;
  late TextEditingController lowerLimitDoseAmountController;
  late TextEditingController higherLimitDoseAmountController;
  late TextEditingController maxDoseAmountController;

  // These variables store the current selected dose unit options.
  SubstanceUnit? substance;
  WeightUnit? weight;
  TimeUnit? time;

  AdministrationRoute? administrationRoute;

  // Lists for dropdown options
  List<SubstanceUnit> substanceUnits = SubstanceUnit.allUnits;
  List<WeightUnit> weightUnits = WeightUnit.values;
  List<TimeUnit> timeUnits = TimeUnit.values;

  String? errorMessage;

  @override
  void initState() {
    final dosage = widget.dosage;
    super.initState();

    // Initialize text controllers using values from the passed-in dosage.
    instructionController =
        TextEditingController(text: widget.dosage.instruction ?? "");
    doseAmountController =
        TextEditingController(text: dosage.dose?.amount.toString() ?? "");
    lowerLimitDoseAmountController = TextEditingController(
        text: dosage.lowerLimitDose?.amount.toString() ?? "");
    higherLimitDoseAmountController = TextEditingController(
        text: dosage.higherLimitDose?.amount.toString() ?? "");
    maxDoseAmountController =
        TextEditingController(text: dosage.maxDose?.amount.toString() ?? "");

    substance = dosage.getSubstanceUnit();
    weight = dosage.getWeightUnit();
    time = dosage.getTimeUnit();
  }

  @override
  void dispose() {
    instructionController.dispose();
    doseAmountController.dispose();
    lowerLimitDoseAmountController.dispose();
    higherLimitDoseAmountController.dispose();
    maxDoseAmountController.dispose();
    super.dispose();
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

  ChoiceChip _labelChip(AdministrationRoute route) {
    return ChoiceChip(
      avatar: Icon(route.icon, size: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
        side: BorderSide(color: Theme.of(context).primaryColorLight),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      label: Text(route.toString()),
      selectedColor: const Color.fromARGB(255, 234, 166, 94),
      selected: administrationRoute == route,
      onSelected: (bool selected) {
        setState(() {
          administrationRoute = route;
        });
      },
    );
  }
/// Builds a dropdown for unit selection with a "-" option for null,
/// but only if T is not SubstanceUnit.
Widget buildDropdownButtonFormField<T extends Unit?>({
  required T? value,
  required List<T> items,
  required ValueChanged<T?> onChanged,
  bool allowNull = true,
}) {
  final List<DropdownMenuItem<T?>> menuItems = [];

  if (allowNull) {
    menuItems.add(
      DropdownMenuItem<T?>(
        value: null,
        child: const Text(
          '-',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  menuItems.addAll(
    items.map(
      (unit) => DropdownMenuItem<T?>(
        value: unit,
        child: Text(
          unit.toString(),
          style: const TextStyle(fontSize: 12),
        ),
      ),
    ),
  );

  return Expanded(
    child: DropdownButtonHideUnderline(
      child: DropdownButtonFormField<T?>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: menuItems,
        onChanged: onChanged,
        menuMaxHeight: 300,
      ),
    ),
  );

}

  /// Creates a Dose from the provided [amountText] and the currently selected unit options.
  Dose? _createDose(String amountText) {
    double? parsedAmount = double.tryParse(amountText.replaceAll(",", "."));
    if (parsedAmount == null) return null;
    // Here we assume that if a dose is provided, a substance unit must have been selected.
    return Dose(
      amount: parsedAmount,
      substanceUnit: substance!, // Should be non-null when a dose is provided.
      weightUnit: weight,
      timeUnit: time,
    );
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
    bool isUnitFilled = substance != null;

    if (substance == null) {
      setState(() {
        errorMessage = 'Du måste välja en primär enhet.';
      });
      return;
    }

    if (!isDoseFilled && !isFromAndToFilled && !isInstructionFilled) {
      setState(() {
        errorMessage =
            'Du måste fylla i antingen dos eller både från och till doser. Alternativt skriv endast i instruktionsfältet.';
      });
      return;
    }

    if (isDoseFilled) {
      if (double.tryParse(doseAmountController.text.replaceAll(",", ".")) ==
          null) {
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
      final lowerLimit = double.tryParse(
          lowerLimitDoseAmountController.text.replaceAll(",", "."));
      final higherLimit = double.tryParse(
          higherLimitDoseAmountController.text.replaceAll(",", "."));
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

    // Create the doses using our helper.
    Dose? mainDose = isDoseFilled ? _createDose(doseAmountController.text) : null;
    Dose? lowerDose = lowerLimitDoseAmountController.text.isNotEmpty
        ? _createDose(lowerLimitDoseAmountController.text)
        : null;
    Dose? higherDose = higherLimitDoseAmountController.text.isNotEmpty
        ? _createDose(higherLimitDoseAmountController.text)
        : null;
    Dose? maxDose = isMaxDoseFilled ? _createDose(maxDoseAmountController.text) : null;

    // Create the updated Dosage.
    final updatedDosage = Dosage(
      instruction: instructionController.text,
      administrationRoute: administrationRoute,
      dose: mainDose,
      lowerLimitDose: lowerDose,
      higherLimitDose: higherDose,
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
                const Text("Allmänt",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("Administrationsväg"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5.0,
                  runSpacing: 5,
                  children: AdministrationRoute.values
                      .map((route) =>
                          _labelChip(route))
                      .toList(),
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
                          text: ' *', style: TextStyle(color: Colors.red))
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    buildDropdownButtonFormField<SubstanceUnit?>(
                      value: substance,
                      items: substanceUnits,
                      allowNull: false,
                      onChanged: (SubstanceUnit? newValue) {
                        setState(() {
                          substance = newValue;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text("/"),
                    const SizedBox(width: 8),
                    buildDropdownButtonFormField<WeightUnit?>(
                      value: weight,
                      items: weightUnits,
                      onChanged: (WeightUnit? newValue) {
                        setState(() {
                          weight = newValue;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text("/"),
                    const SizedBox(width: 8),
                    buildDropdownButtonFormField<TimeUnit?>(
                      value: time,
                      items: timeUnits,
                      onChanged: (TimeUnit? newValue) {
                        setState(() {
                          time = newValue;
                        });
                      },
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
                      child: AutoSizeTextField(
                        controller: doseAmountController,
                        decoration: customInputDecoration(),
                        style: const TextStyle(fontSize: 16),
                        minFontSize: 12,
                        maxLines: 1,
                        maxLength: 5,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        buildCounter: (context,
                                {required int currentLength,
                                required bool isFocused,
                                required int? maxLength}) =>
                            null,
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
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        buildCounter: (context,
                                {required int currentLength,
                                required bool isFocused,
                                required int? maxLength}) =>
                            null,
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
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        buildCounter: (context,
                                {required int currentLength,
                                required bool isFocused,
                                required int? maxLength}) =>
                            null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(") ${substance != null ? '$substance' : ''}${weight != null ? '/$weight' : ''}${time != null ? '/$time' : ''}", style: labelTextStyle),
                    
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
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        buildCounter: (context,
                                {required int currentLength,
                                required bool isFocused,
                                required int? maxLength}) =>
                            null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text("${substance != null ? '$substance' : ''}${time != null ? '/$time' : ''}", style: labelTextStyle),
                    
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
