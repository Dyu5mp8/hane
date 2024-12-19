import 'package:flutter/material.dart';
import 'package:hane/ui_components/dosage_list.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dosage_dialog.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/utils/validate_drug_save.dart' as val;

class EditIndicationDialog extends StatefulWidget {
  final Drug drug;
  final Indication indication;
  final bool withDosages;
  final bool isNewIndication;
  final Function()? onSave;

  const EditIndicationDialog(
      {super.key,
      required this.indication,
      required this.drug,
      this.withDosages = false,
      this.isNewIndication = false,
      this.onSave});

  @override
  State<EditIndicationDialog> createState() => _EditIndicationDialogState();
}

class _EditIndicationDialogState extends State<EditIndicationDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late List<Dosage> _tempDosages;

  @override
  void initState() {
    super.initState();
    _tempDosages = widget.indication.dosages
            ?.map((dosage) => Dosage.from(dosage))
            .toList() ??
        [];
    setData();
  }

  void setData() {
    _nameController.text = widget.indication.name;
    _notesController.text = widget.indication.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void saveIndication() {
    if (_formKey.currentState!.validate()) {
      widget.indication.name = _nameController.text;
      widget.indication.notes = _notesController.text;
      widget.indication.dosages = _tempDosages;

      if (widget.isNewIndication) {
        widget.drug.indications?.add(widget.indication);
      }

      widget.drug.updateDrug();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.indication.name),
        leading: IconButton(
          icon: const Icon(Icons.close, size: 20),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        actions: [
          if (!widget.isNewIndication)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Vill du ta bort indikationen?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Avbryt'),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.drug.indications?.remove(widget.indication);
                          widget.drug.updateDrug();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('Ta bort',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Ta bort', style: TextStyle(color: Colors.red)),
            ),
          IconButton(
            icon: const Icon(Icons.check, size: 20),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                saveIndication();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Namn',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  minLines: 1,
                  maxLines: 2,
                  validator: val.validateName,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _notesController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Anteckningar',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                  minLines: 3,
                  maxLines: 8,
                ),
                if (widget.withDosages)
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text('Doseringar',
                              style: TextStyle(fontSize: 18)),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Dosage newDosage = Dosage();
                              showDialog(
                                context: context,
                                builder: (context) => EditDosageDialog(
                                  dosage: newDosage,
                                  onSave: (dosage) {
                                    setState(() {
                                      _tempDosages.add(dosage);
                                    });
                                  },
                                ),
                              );
                            },
                            icon: const Icon(Icons.add, size: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Wrap ReorderableListView in a SizedBox with a fixed height
                      SizedBox(
                        height: 300, // Provide a fixed height for the list
                        child: DosageList(
                          dosages: _tempDosages,
                          drug: widget.drug,
                          editMode: true,
                        ),
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
