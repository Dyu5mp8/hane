import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/drugs/ui_components/custom_chip.dart';
import 'package:provider/provider.dart';
import 'package:hane/utils/validate_drug_save.dart' as val;

class EditNameDialog extends StatefulWidget {
  final Drug drug;
  const EditNameDialog({super.key, required this.drug});

  @override
  _EditNameDialogState createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  List<String> _brandNames = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the existing data
    _nameController.text = widget.drug.name ?? '';
    _brandNames = widget.drug.brandNames?.map((e) => e.toString()).toList() ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandNameController.dispose();
    super.dispose();
  }

  void _addBrandName() {
    if (_brandNameController.text.isNotEmpty) {
      setState(() {
        _brandNames.add(_brandNameController.text);
        _brandNameController.clear();
      });
    }
  }

  void _removeBrandName(String name) {
    setState(() {
      _brandNames.remove(name);
    });
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
            if (_nameController.text.isNotEmpty) {
              // Update the drug name with the new value
              widget.drug.name = _nameController.text;
              widget.drug.brandNames = _brandNames; // Update brand names list

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
                  controller: _nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Namn',
                    border: OutlineInputBorder(),
                  ),
                  validator: val.validateName,
                ),
                
                
                const SizedBox(height: 16),
                
                // Brand names input
                const Text('Varumärken'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _brandNameController,
                  decoration: InputDecoration(
                    labelText: 'Lägg till synonymer',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          _addBrandName();
                        }
                        
                    
                        },
                    ),
            
                  ),
                  validator: val.validateName,
                  
                ),
                const SizedBox(height: 8),
            
                // Display brand names as chips
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _brandNames
                      .map((name) => CustomChip(
                            label: name,
                          
                            onDeleted: () => _removeBrandName(name),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}