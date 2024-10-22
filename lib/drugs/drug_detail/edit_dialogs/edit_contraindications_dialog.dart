import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';

class EditContraindicationsDialog extends StatefulWidget {
  final Drug drug;
  const EditContraindicationsDialog({super.key, required this.drug});

  @override
  _EditContraindicationsDialogState createState() =>
      _EditContraindicationsDialogState();
}

class _EditContraindicationsDialogState
    extends State<EditContraindicationsDialog> {
  final TextEditingController _contraindicationController =
      TextEditingController();
  final TextEditingController _expandedContraindicationController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the existing data
    _contraindicationController.text = widget.drug.contraindication ?? '';
    _expandedContraindicationController.text =
        widget.drug.expandedContraindication ?? '';
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
          title: const Text('CAVE'),
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
                  // Update the drug name with the new value
                  widget.drug.contraindication =
                      _contraindicationController.text;
                  widget.drug.expandedContraindication = _expandedContraindicationController.text;
                      


                  Navigator.pop(context);
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
                const SizedBox(height: 20), // Name input
                TextFormField(
                    controller: _contraindicationController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Varningar och försiktighet',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 3,
                    maxLines: 10),

                const SizedBox(height: 20),

                TextFormField(
                    controller: _expandedContraindicationController,
                    decoration: const InputDecoration(
                      labelText: 'Utökad information',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 3,
                    maxLines: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
