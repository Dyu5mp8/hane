import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:intl/intl.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class ChangeLog extends StatefulWidget {
  final Drug drug;
  final VoidCallback onChanged;

  const ChangeLog({super.key, required this.drug, required this.onChanged});

  @override
  State<ChangeLog> createState() => _ChangeLogState();
}

class _ChangeLogState extends State<ChangeLog> {
  late final DrugListProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<DrugListProvider>(context);
  }

  void _clearChangeLog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bekräfta'),
          content: const Text('Är du säker på att du vill radera loggen?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.drug.changeNotes = [];
                  Provider.of<DrugListProvider>(context, listen: false).addDrug(widget.drug);
                  widget.onChanged(); // Call the callback
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Radera'),
            ),
          ],
        );
      },
    );
  }

  void _removeChangeNoteAt(int index) {
    setState(() {
      widget.drug.changeNotes?.removeAt(index);
      Provider.of<DrugListProvider>(context, listen: false).addDrug(widget.drug);
      widget.onChanged(); // Call the callback
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ändringslogg'),
        actions: [
          if (provider.isAdmin)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _clearChangeLog(context);
              },
            ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.drug.changeNotes?.length ?? 0,
          itemBuilder: (context, index) {
            final changeNote = widget.drug.changeNotes![index];
            final comment = changeNote['comment'] ?? 'Ingen kommentar';
            final timestamp = changeNote['timestamp'] ?? 'Okänt datum';
            final user = changeNote['user'] ?? 'Okänd användare';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(comment),
                subtitle: Text(
                  'Tidpunkt: ${DateFormat.yMMMd().add_jm().format(DateTime.parse(timestamp))}\nAnvändare: $user',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Bekräfta'),
                          content: const Text('Är du säker på att du vill radera denna post?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _removeChangeNoteAt(index);
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Radera'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}