import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_dialogs/edit_dosage_dialog.dart';
import 'package:hane/drugs/drug_detail/ui_components/dosage_snippet.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/utils/validate_drug_save.dart' as val;



class EditIndicationDialog extends StatefulWidget {
  final Drug drug;
  final Indication indication;
  final bool withDosages;
  final bool isNewIndication;

  const EditIndicationDialog(
      {super.key, required this.indication, required this.drug, this.withDosages = false, this.isNewIndication = false});

  @override
  _EditIndicationDialogState createState() => _EditIndicationDialogState();
}

class _EditIndicationDialogState extends State<EditIndicationDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    late List<Dosage> _tempDosages;

  @override

  void initState() {
    super.initState();
    // Create a deep copy of the dosages
    _tempDosages = widget.indication.dosages
        ?.map((dosage) => Dosage.from(dosage))
        .toList() ?? [];

    setData();
  }

  setData() {
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
      // Update the drug name with the new value
      widget.indication.name = _nameController.text;
      widget.indication.notes = _notesController.text;
      widget.indication.dosages = _tempDosages;

      if (widget.isNewIndication) {
        print('new indication');
        widget.drug.indications?.add(widget.indication);
      }

      widget.drug.updateDrug();
  
  
      Navigator.pop(context);
    }
  }


  @override

  Widget build(BuildContext context) {
 setData();
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.indication.name),
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: null,
          
          actions: [
            if (!widget.isNewIndication)
            TextButton(
              
                onPressed: () {
                  showDialog(context: context, builder: (ctx) => AlertDialog(
                    title: const Text('Vill du ta bort indikationen?'),
                  
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Avbryt')),
                      TextButton(
                          onPressed: () {
                  widget.drug.indications?.remove(widget.indication);
                  widget.drug.updateDrug();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Ta bort', style: TextStyle(color: Colors.red)),
              ),  
            ],
                    
                  ));
                },
                child: const Text('Ta bort', style: TextStyle(color: Colors.red)),
            ),
                
            

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
      Row(
        children: [
          const Text('Doseringar', style: TextStyle(fontSize: 20)),
          const Spacer(),
          IconButton(
            onPressed: () {
      
              Dosage newDosage = Dosage();
              showDialog(context: context, builder:(context) => 
              EditDosageDialog(
                dosage: newDosage, 
                onSave: (dosage) {
                  setState(() {
                    _tempDosages.add(dosage);
                  });
                }
                ));

       
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      const SizedBox(height: 20),
      // Dosages
      if (_tempDosages != null)
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _tempDosages.length,
          itemBuilder: (ctx, index) {
            return DosageSnippet(
              dosage: _tempDosages[index], // Pass the correct dosage
              editMode: true,
              onDosageUpdated: (updatedDosage) {
                setState(() {
                  // Update the indication with the modified dosage
                  _tempDosages[index] = updatedDosage;

             
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
