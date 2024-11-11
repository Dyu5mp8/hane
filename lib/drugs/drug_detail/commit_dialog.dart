import 'package:flutter/material.dart';

class CommitDialog extends StatefulWidget {
  final Function(String, Map<String, String>) onCommit;
  final Map<String, String> reviewers;

  const CommitDialog({
    super.key,
    required this.onCommit,
    required this.reviewers,
  });

  @override
  State<CommitDialog> createState() => _CommitDialogState();
}

class _CommitDialogState extends State<CommitDialog> {
  final TextEditingController _commentController = TextEditingController();
  final Map<String, String> _selectedReviewerUIDs = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Spara ändringar'),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400), // Set max width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _commentController,
                minLines: 1,
                maxLines: 3,
                maxLength: 200,
                decoration: InputDecoration(
                  labelText: 'Ändringskommentar',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Välj granskare',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: widget.reviewers.entries.map((entry) {
                  return CheckboxListTile(
                    title: Text(entry.value),
                    value: _selectedReviewerUIDs.containsKey(entry.key),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedReviewerUIDs[entry.key] = entry.value;
                        } else {
                          _selectedReviewerUIDs.remove(entry.key);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Avbryt'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onCommit(_commentController.text, _selectedReviewerUIDs);
            Navigator.of(context).pop();
          },
          child: const Text('Spara'),
        ),
      ],
    );
  }
}