import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';

class EditNotesDialog extends StatefulWidget {
  final Drug drug;
  final bool isUserNote;
  final Function()? onUserNotesSaved;
  const EditNotesDialog(
      {Key? key,
      required this.drug,
      required this.isUserNote,
      this.onUserNotesSaved})
      : super(key: key);

  @override
  _EditNotesDialogState createState() => _EditNotesDialogState();
}

class _EditNotesDialogState extends State<EditNotesDialog> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _expandedNotesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the existing data
    _notesController.text = widget.isUserNote ? widget.drug.userNotes ?? '' : widget.drug.notes ?? '';
    _expandedNotesController.text = widget.drug.expandedNotes ?? '';

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
          title: Text(widget.isUserNote ? 'Dina anteckningar' : 'Anteckningar'),
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
                  if (widget.isUserNote) {
                    widget.drug.userNotes = _notesController.text;
                    widget.onUserNotesSaved?.call();
                  } else {
                  widget.drug.notes = _notesController.text;
                  widget.drug.expandedNotes = _expandedNotesController.text;
  
                  }
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
                    maxLines: 10,
                    textCapitalization: TextCapitalization.sentences,),

                 const SizedBox(height: 8),
                TextFormField(
                    controller: _expandedNotesController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Detaljerad info',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 4,
                    maxLines: 10,
                    textCapitalization: TextCapitalization.sentences,),
                  
              ],
            ),
          ),
        ),
      ),
    );
  }
}
