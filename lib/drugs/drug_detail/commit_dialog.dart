import 'package:flutter/material.dart';

class CommitDialog extends StatefulWidget {
  final Function(String) onCommit;

  const CommitDialog({super.key, required this.onCommit});

  @override
  State<CommitDialog> createState() => _CommitDialogState();
}

class _CommitDialogState extends State<CommitDialog> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save Changes'),
      content: TextField(
        controller: _commentController,
        decoration: const InputDecoration(
          labelText: 'Enter your comment',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final comment = _commentController.text;
            print(comment);
            if (comment.isNotEmpty) {
              widget.onCommit(comment);
            }
            else {
              widget.onCommit('Ingen ändringskommentar');
            }
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}