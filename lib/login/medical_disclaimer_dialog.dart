import 'package:flutter/material.dart';
import 'package:hane/legal/disclaimer.dart';

class MedicalDisclaimerDialog extends StatelessWidget {
  const MedicalDisclaimerDialog({super.key, required this.onAccepted});

  final VoidCallback onAccepted;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Viktig information', style: TextStyle(fontSize: 20)),
      content: const SingleChildScrollView(
        child: ListBody(
          children: [
            Text(disclaimer, style: TextStyle(fontSize: 15)),
            SizedBox(height: 10),
            Text(
              'Genom att skapa ett konto bekräftar du att du är legitimerad '
              'hälso- och sjukvårdspersonal och att du förstår och accepterar '
              'detta ansvar.',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Avböj'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                10,
              ), // Consistent border radius
            ),
            backgroundColor: const Color.fromARGB(255, 51, 77, 97),
            // Padding to match your app's buttons
          ),
          onPressed: () {
            onAccepted(); // Proceed with registration
          },
          child: const Text(
            'Jag accepterar',
            style: TextStyle(
              fontSize: 15, // Font size to match other buttons
              color:
                  Colors.white, // Text color consistent with your app's theme
            ),
          ),
        ),
      ],
    );
  }
}
