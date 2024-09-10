import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/ui_components/custom_chip.dart';
import 'package:hane/utils/unit_parser.dart';
import 'package:hane/utils/validate_concentration_save.dart' as val;

class EditConcentrationsDialog extends StatefulWidget {
  final Drug drug;

  const EditConcentrationsDialog({super.key, required this.drug});

  @override
  _EditConcentrationsDialogState createState() =>
      _EditConcentrationsDialogState();
}

class _EditConcentrationsDialogState extends State<EditConcentrationsDialog> {
  final TextEditingController concentrationAmountController =
      TextEditingController();
  final TextEditingController concentrationUnitController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Concentration> concentrations = [];

  @override
  void dispose() {
    concentrationAmountController.dispose();
    concentrationUnitController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.drug.concentrations != null) {
      concentrations = List.from(widget.drug.concentrations!);
    }
  }

  void addConcentration() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        concentrations.add(Concentration(
          amount:
              UnitParser.normalizeDouble(concentrationAmountController.text),
          unit: concentrationUnitController.text,
        ));
        concentrationAmountController.clear();
        concentrationUnitController.clear();
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
              if (concentrationAmountController.text.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Ej tillagda ändringar'),
                      content: Text(
                          'Ej sparat fält: ${concentrationAmountController.text}. Spara utan att lägga till den inskrivna koncentrationen?'),
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
                  // Concentration Unit Input
                  Expanded(
                    child: TextFormField(
                        controller: concentrationUnitController,
                        decoration: const InputDecoration(
                          labelText: 'Enhet',
                          hintText: "ex. mg/ml",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          errorMaxLines: 2,
                        ),
                        validator: val.validateConcentrationUnit),
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
