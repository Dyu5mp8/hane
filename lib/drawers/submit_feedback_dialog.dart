import 'package:flutter/material.dart';

class SubmitFeedbackDialog extends StatefulWidget {
  final void Function(String)? onFeedbackSaved;

  const SubmitFeedbackDialog({Key? key, this.onFeedbackSaved}) : super(key: key);

  @override
  State<SubmitFeedbackDialog> createState() => _SubmitFeedbackDialogState();
}

class _SubmitFeedbackDialogState extends State<SubmitFeedbackDialog> {
  final TextEditingController _feedbackController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _saveFeedback() {
    if (_formKey.currentState!.validate()) {
      widget.onFeedbackSaved?.call(_feedbackController.text.trim());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 300,
        height: 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: _feedbackController,
                autofocus: true,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Feedback',
                  border: OutlineInputBorder(),
                ),
                minLines: 10,
                maxLines: 10,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 500,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vänligen skriv in din feedback.';
                  }
                  return null;
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _saveFeedback,
                  child: const Icon(Icons.check),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}