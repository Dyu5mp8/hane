import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/utils/unit_parser.dart';
import 'package:hane/utils/validate_concentration_save.dart' as val;
import 'package:hane/utils/unit_validator.dart';

class EditConcentrationsDialog extends StatefulWidget {
  final Drug drug;

  const EditConcentrationsDialog({super.key, required this.drug});

  @override
  State<EditConcentrationsDialog> createState() =>
      _EditConcentrationsDialogState();
}

class _EditConcentrationsDialogState extends State<EditConcentrationsDialog> {
  final TextEditingController concentrationAmountController =
      TextEditingController();
  final TextEditingController mixingInstructionsController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Concentration> concentrations = [];

  // List of units for the dropdown
  List<String> units = UnitValidator.validConcentrationDenominatorUnits().keys.toList();
  String? selectedUnit;
  int? editingIndex;

  @override
  void dispose() {
    concentrationAmountController.dispose();
    mixingInstructionsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.drug.concentrations != null) {
      concentrations = List.from(widget.drug.concentrations!);
    }
  }

  List<String> unitsToSymbols(List<String> units) {
    return units.map((unit) {
      return unit == 'mikrog' ? 'μg' : unit;
    }).toList();
  }

  void addOrUpdateConcentration() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        final newConcentration = Concentration.fromString(
          amount: UnitParser.normalizeDouble(concentrationAmountController.text),
          unit: '$selectedUnit/ml',
          mixingInstructions: mixingInstructionsController.text,
        );

        if (editingIndex != null) {
          // Update existing concentration
          concentrations[editingIndex!] = newConcentration;
        } else {
          // Add new concentration
          concentrations.add(newConcentration);
        }

        // Clear form fields
        concentrationAmountController.clear();
        mixingInstructionsController.clear();
        selectedUnit = null;
        editingIndex = null;
      });
    }
  }

  void removeConcentration(Concentration concentration) {
    setState(() {
      concentrations.remove(concentration);
      // Reset editing if the removed concentration was being edited
      if (editingIndex != null &&
          concentrations.length <= editingIndex!) {
        editingIndex = null;
        concentrationAmountController.clear();
        mixingInstructionsController.clear();
        selectedUnit = null;
      }
    });
  }

  void editConcentration(int index) {
    final concentration = concentrations[index];
    setState(() {
      concentrationAmountController.text =
          concentration.amount.toString();
      selectedUnit = concentration.normalizeFirstdUnit();
      mixingInstructionsController.text =
          concentration.mixingInstructions ?? '';
      editingIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Redigera koncentrationer'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Avbryt',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.drug.concentrations = concentrations;
              widget.drug.updateDrug();
              Navigator.pop(context);
            },
            tooltip: 'Spara',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lägg till eller redigera koncentration',
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context).colorScheme.surface,
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface, width: 0.4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // Concentration Amount and Unit Inputs
                     Row(
  children: [
    // Concentration Amount Input
    Expanded(
      flex: 3,
      child: TextFormField(
        controller: concentrationAmountController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          labelText: 'Värde',
          hintText: 't.ex. 10',
          hintStyle: TextStyle(fontSize: 14, color: Color.fromARGB(139, 158, 158, 158)),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          errorMaxLines: 2,
        ),
        validator: val.validateConcentrationAmount,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    ),
    const SizedBox(width: 12),
    // Concentration Unit Dropdown
    Expanded(
      flex: 2,
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Adjusted padding to fit content
          labelText: 'Enhet',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          errorMaxLines: 2,
          suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0), // Ensures /ml suffix fits better
          suffixText: '/ml',
          suffixStyle: TextStyle(color: Colors.black, fontSize: 14), // Adjusted font size for better fit
        ),
        value: selectedUnit,
        items: unitsToSymbols(units).map((String unit) {
          return DropdownMenuItem<String>(
            value: unit,
            child: Text(unit),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedUnit = newValue;
          });
        },
        validator: (value) {
          val.validateConcentrationUnit(value);
          
        },
      ),
    ),
  ],
),
const SizedBox(height: 12),
                      // Mixing Instructions Input
                      TextFormField(
                        controller: mixingInstructionsController,
                        decoration: InputDecoration(
                          labelText: 'Blandningsinstruktioner',
                          hintStyle: const TextStyle(fontSize: 14, color: Color.fromARGB(139, 158, 158, 158)),
                          hintText: '(valfritt) T.ex.  "Nipruss 60 mg + Glukos 50 mg/ml 60 ml i ljusskyddad spruta ger 1mg/ml."',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          errorMaxLines: 2,
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      // Add or Save Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          icon: Icon(
                            editingIndex != null ? Icons.save : Icons.add,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          label: Text(
                            editingIndex != null ? 'Spara ändringar' : 'Lägg till',
                          ),
                          onPressed: addOrUpdateConcentration,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Koncentrationer',
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 12),
            // Display Concentrations as ListTiles inside Cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: concentrations.length,
              itemBuilder: (context, index) {
                final concentration = concentrations[index];
                return Card(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 0.4),
                  ),
                  child: ListTile(
                    title: Text(
                      concentration.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: concentration.mixingInstructions != null &&
                            concentration.mixingInstructions!.isNotEmpty
                        ? Text(concentration.mixingInstructions!)
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeConcentration(concentration),
                    ),
                    onTap: () => editConcentration(index),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}