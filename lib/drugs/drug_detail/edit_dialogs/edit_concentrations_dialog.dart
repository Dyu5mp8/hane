import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/drugs/ui_components/custom_chip.dart';
import 'package:hane/utils/unit_parser.dart';
import 'package:hane/utils/validate_concentration_save.dart' as val;
import 'package:provider/provider.dart';


class EditConcentrationsDialog extends StatefulWidget {
  final Drug drug;

  EditConcentrationsDialog({required this.drug});

  @override
  _EditConcentrationsDialogState createState() => _EditConcentrationsDialogState();
}

class _EditConcentrationsDialogState extends State<EditConcentrationsDialog> {
  final TextEditingController concentrationAmountController = TextEditingController();
  final TextEditingController concentrationUnitController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    concentrationAmountController.dispose();
    concentrationUnitController.dispose();
    super.dispose();
  }

  void addConcentration() {
    if (_formKey.currentState!.validate())
      setState(() {
        widget.drug.concentrations?.add(Concentration(
          amount: UnitParser.normalizeDouble(concentrationAmountController.text),
          unit: concentrationUnitController.text,
        ));
        concentrationAmountController.clear();
        concentrationUnitController.clear();
      });
   
  }

  void removeConcentration(Concentration concentration) {
    setState(() {
      widget.drug.concentrations?.remove(concentration);
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
            child: Text("Avbryt"),
          ),
          TextButton(
            onPressed: () {
              if (concentrationAmountController.text.isNotEmpty) {
                showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Ej tillagda ändringar'),
                          content: Text('Ej sparat fält: ${concentrationAmountController.text}. Spara utan att lägga till den inskrivna koncentrationen?'),
                          actions: [
                            TextButton(
                              onPressed: () {
  
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
                
              }
              else {
                Provider.of<DrugListProvider>(context, listen: false).addDrug(widget.drug);
                Navigator.pop(context);
              }
            },
            child: const Text('Spara'),
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
              child:
            Row(
              children: <Widget>[
                // Concentration Amount Input
                
                  
                  Expanded(
                   child: TextFormField(
                  controller:
                      concentrationAmountController,
                  decoration: InputDecoration(
                    labelText: 'Värde',
                    hintText: "ex. 10",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorMaxLines: 2,
                  ),
                  validator: val.validateConcentrationAmount,
                  keyboardType: TextInputType.numberWithOptions(decimal: true)
                ),
                  ),
                
                const SizedBox(width: 16),
                // Concentration Unit Input
                Expanded(
                  child: TextFormField(
                    controller:
                        concentrationUnitController,
                    decoration: InputDecoration(
                      labelText: 'Enhet',
                      hintText: "ex. mg/ml",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      errorMaxLines: 2,
                    ),
                    validator: val.validateConcentrationUnit),
                ),
         
    
                IconButton(
                  icon: Icon(Icons.add_circle_sharp, ),
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
              children: widget.drug.concentrations?.map((concentration) {
                return CustomChip(
                  label: concentration.toString(),
                  onDeleted: () => removeConcentration(concentration),
                );
              }).toList() ?? [],
            ),
          ],
        ),
      ),
    );
  }
}