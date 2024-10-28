import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/ui_components/custom_chip.dart';
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
  final _formKey = GlobalKey<FormState>();
  List<Concentration> concentrations = [];

  // List of units for the dropdown
  List<String> units = UnitValidator.validSubstanceUnits().keys.toList();
  String? selectedUnit;

  @override
  void dispose() {
    concentrationAmountController.dispose();
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



  void addConcentration() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        concentrations.add(Concentration.fromString(
          amount:
              UnitParser.normalizeDouble(concentrationAmountController.text),
          unit: '$selectedUnit/ml',
        
        ));
    
        concentrationAmountController.clear();
        selectedUnit = null;
      });
    }
  }

  void removeConcentration(Concentration concentration) {
    setState(() {
      concentrations.remove(concentration);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redigera koncentrationer'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close),
          ),
          TextButton(
            onPressed: () {
              if (concentrationAmountController.text.isNotEmpty ||
                  selectedUnit != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Ej tillagda ändringar'),
                      content: Text(
                          'Ej sparat fält: ${concentrationAmountController.text} ${selectedUnit ?? ''}. Spara utan att lägga till den inskrivna koncentrationen?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            widget.drug.concentrations = concentrations;
                            widget.drug.updateDrug();

                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('Ja'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Nej'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                widget.drug.concentrations = concentrations;
                widget.drug.updateDrug();

                Navigator.pop(context);
              }
            },
            child: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lägg till koncentration'),
            Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  // Concentration Amount Input
                  Expanded(
                    child: TextFormField(
                        controller: concentrationAmountController,
                        decoration: const InputDecoration(
                          labelText: 'Värde',
                          hintText: "ex. 10",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          errorMaxLines: 2,
                        ),
                        validator: val.validateConcentrationAmount,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true)),
                  ),
                  const SizedBox(width: 16),
                  // Concentration Unit Dropdown
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Enhet',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        errorMaxLines: 2,
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
                       return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_sharp,
                    ),
                    onPressed: addConcentration,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Display Concentrations as Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: concentrations.map((concentration) {
                return CustomChip(
                  label: concentration.toString(),
                  onDeleted: () => removeConcentration(concentration),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}