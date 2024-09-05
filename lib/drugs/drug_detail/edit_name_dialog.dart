import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:provider/provider.dart';

class EditNameDialog extends StatefulWidget {
  final Drug drug;
  const EditNameDialog({super.key, required this.drug});

  @override
  _EditNameDialogState createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  final TextEditingController _nameController = TextEditingController();
  

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      // Prepopulate the text field with the current drug name
      _nameController.text = widget.drug.name ?? '';

      return AlertDialog(
        title: const Text('Redigera namn'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Namn'),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Namn',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Avbryt'),
          ),
          TextButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                // Update the drug name with the new value
                widget.drug.name = _nameController.text;
                Provider.of<DrugListProvider>(context, listen: false).addDrug(widget.drug);
                Navigator.pop(context);
              }
            },
            child: const Text('Spara'),
          ),
        ],
      );
    }
  }
