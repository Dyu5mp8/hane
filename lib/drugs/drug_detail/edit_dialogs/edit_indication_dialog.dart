import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/dosageViewHandler.dart';
import 'package:hane/drugs/drug_detail/ui_components/dosage_snippet.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/utils/validate_drug_save.dart' as val;



class EditIndicationDialog extends StatefulWidget {
  final Drug drug;
  final Indication indication;
  final bool withDosages;

  const EditIndicationDialog(
      {super.key, required this.indication, required this.drug, this.withDosages = false});

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

    void _handleDosageUpdate(Dosage updatedDosage) {
    // Update the relevant indication in the Drug object
    setState(() {
      widget.drug.indications?.forEach((indication) {
        if (indication.dosages?.contains(updatedDosage) ?? false) {
          indication.dosages = indication.dosages?.map((d) {
            return d == updatedDosage ? updatedDosage : d;
          }).toList();
        }
      });
    });
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
              if (widget.withDosages)
  Column(
    children: [
      const SizedBox(height: 20),
      const Text('Doseringar', style: TextStyle(fontSize: 20)),
      const SizedBox(height: 20),
      // Dosages
      if (widget.indication.dosages != null)
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.indication.dosages?.length,
          itemBuilder: (ctx, index) {
            return DosageSnippet(
              dosage: widget.indication.dosages![index], // Pass the correct dosage
              editMode: true,
              onDosageUpdated: (updatedDosage) {
                setState(() {
                  // Update the indication with the modified dosage
                  widget.indication.dosages![index] = updatedDosage;

                  // Optionally update the parent Drug if needed, e.g.,
                  widget.drug.updateDrug();
                });
              }, // Callback to update the dosage
            );
          },
        ),
    ],
  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
