import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:provider/provider.dart';

class EditNotesDialog extends StatefulWidget {
  final Drug drug;
  const EditNotesDialog({Key? key, required this.drug}) : super(key: key);

  @override
  _EditNotesDialogState createState() => _EditNotesDialogState();
}

class _EditNotesDialogState extends State<EditNotesDialog> {
  final TextEditingController _notesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          title: const Text('Anteckningar'),
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
                  widget.drug.notes =
                      _notesController.text;
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
                // Name input

                const SizedBox(height: 8),
                TextFormField(
                    controller: _notesController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Anteckningar',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 4,
                    maxLines: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
