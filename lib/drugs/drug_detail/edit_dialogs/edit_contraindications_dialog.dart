import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:provider/provider.dart';

class EditContraindicationsDialog extends StatefulWidget {
  final Drug drug;
  const EditContraindicationsDialog({super.key, required this.drug});

  @override
  _EditContraindicationsDialogState createState() => _EditContraindicationsDialogState();
}

class _EditContraindicationsDialogState extends State<EditContraindicationsDialog> {
  final TextEditingController _contraindicationController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the existing data
    _contraindicationController.text = widget.drug.contraindication ?? '';
  }

  @override
  void dispose() {
    _contraindicationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontraindikationer'),
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
           
              // Update the drug name with the new value
              widget.drug.contraindication = _contraindicationController.text;

              Navigator.pop(context);
            
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
                SizedBox(height:20),                // Name input
                TextFormField(
                  controller: _contraindicationController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Kontraindikationer',
                    border: OutlineInputBorder(),
                  ),

                          minLines: 3,
                          maxLines: 10
                
                  
                ),
                
              
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}