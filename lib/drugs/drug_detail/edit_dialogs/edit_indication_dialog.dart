import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/utils/validate_drug_save.dart' as val;
import 'package:provider/provider.dart';

class EditIndicationDialog extends StatefulWidget {
  final Drug drug;
  final Indication indication;

  const EditIndicationDialog(
      {super.key, required this.indication, required this.drug});

  @override
  _EditIndicationDialogState createState() => _EditIndicationDialogState();
}

class _EditIndicationDialogState extends State<EditIndicationDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the existing data
    _nameController.text = widget.indication.name;
    _notesController.text = widget.indication.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void saveIndication() {
    if (_formKey.currentState!.validate()) {
      // Update the drug name with the new value
      widget.indication.name = _nameController.text;
      widget.indication.notes = _notesController.text;
      widget.drug.updateDrug();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.indication.name),
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: null,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close)),
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveIndication();
                  }
                },
                child: const Icon(Icons.check)),
          ]),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name input

                const SizedBox(height: 8),
                TextFormField(
                    controller: _nameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Namn',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    minLines: 4,
                    maxLines: 10,
                    validator: val.validateName
                    ),
                    

                const SizedBox(height: 50),

                TextFormField(
                  controller: _notesController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Anteckningar',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                  minLines: 4,
                  maxLines: 10,
         
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
