import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/change_log.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:intl/intl.dart';

class ReviewDialog extends StatefulWidget {
  final Drug drug;
  final String? currentUserUID;

  const ReviewDialog({
    super.key,
    required this.drug,
    required this.currentUserUID,
  });

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  Map<String, String> acceptedReviewers = {};
  Map<String, String> availableReviewers = {};

  @override
  void initState() {
    super.initState();
    acceptedReviewers = Map.from(widget.drug.hasReviewedUIDs ?? {});
    availableReviewers = Map.from(widget.drug.shouldReviewUIDs ?? {});
  }

  String formatTimestamp(String timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  void _onChangeLogChanged() {
    setState(() {
      // Update the state to reflect changes in the change log
    });
  }

  void _navigateToChangeLog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeLog(
          drug: widget.drug,
          onChanged: _onChangeLogChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final latestChangeNote = widget.drug.latestReviewChangeNotes();

    return AlertDialog(
      title: Row(children: [
        const Text('Granskning'),
        const Expanded(child: SizedBox()),
        TextButton(
          onPressed: () {
            _navigateToChangeLog(context);
          },
          child: const Text('Ändringshistorik'),
        ),
      ]),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (latestChangeNote != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Senaste ändring att granska:',
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 8),
                    Text(
                        'Kommentar: ${latestChangeNote['comment'] ?? 'Ingen ändringskommentar'}'),
                    Text(
                      'Tidpunkt: ${formatTimestamp(latestChangeNote['timestamp'])}\nAnvändare: ${latestChangeNote['user']}',
                    ),
                  ],
                ),
              ),
            const Divider(),
            Text('Granskare:',
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: availableReviewers.entries.map((entry) {
                  final reviewerUID = entry.key;
                  final reviewerEmail = entry.value;
                  final isSelected = acceptedReviewers.keys.contains(reviewerUID);
                  final isCurrentUser = reviewerUID == widget.currentUserUID;
                  return CheckboxListTile(
                    value: isSelected,
                    title: Text(reviewerEmail),
                    onChanged: isCurrentUser
                        ? (bool? value) {
                            setState(() {
                              if (value == true) {
                                acceptedReviewers[reviewerUID] = reviewerEmail;
                              } else {
                                acceptedReviewers.remove(reviewerUID);
                              }
                            });
                          }
                        : null, // Disable checkbox for other users
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: isCurrentUser ? null : Colors.grey,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Update the drug's reviewerUIDs
            widget.drug.hasReviewedUIDs = acceptedReviewers;
            // Save changes using the DrugListProvider or appropriate method
            final drugListProvider =
                Provider.of<DrugListProvider>(context, listen: false);
            drugListProvider.addDrug(widget.drug);
            Navigator.pop(context);
          },
          child: const Text('Spara'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Avbryt'),
        ),
      ],
    );
  }
}
