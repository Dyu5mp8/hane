import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:hane/utils/validate_drug_save.dart' as val;

class EditNotesDialog extends StatefulWidget {
  final Drug drug;
  const EditNotesDialog({super.key, required this.drug});

  @override
  _EditNotesDialogState createState() => _EditNotesDialogState();
}

class _EditNotesDialogState extends State<EditNotesDialog> {
  final TextEditingController _notesController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the existing data
    _notesController.text = widget.drug.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redigera'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: null,
        actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Avbryt')
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Update the drug name with the new value
              widget.drug.notes = _notesController.text;

              Provider.of<DrugListProvider>(context, listen: false)
                  .addDrug(widget.drug);
              Navigator.pop(context);
            }
          },
          child: const Text('Spara'),
        ),
      ]) ,
      
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              
              children: [
                // Name input
                const Text('Namn'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Namn',
                    border: OutlineInputBorder(),
                  ),
                  validator: val.validateName,
                ),
                
              
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}