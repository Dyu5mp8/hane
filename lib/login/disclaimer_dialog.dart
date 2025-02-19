import 'package:flutter/material.dart';

class DisclaimerDialog extends StatelessWidget {
  const DisclaimerDialog({super.key, required this.onAccepted});

  final VoidCallback onAccepted;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Viktig information'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: [
            Text(
              'Denna app är avsedd för medicinska yrkesverksamma. Informationen som '
              'presenteras är endast för utbildningsändamål och bör inte användas som '
              'ersättning för professionell medicinsk rådgivning, diagnos eller behandling.',
            ),
            SizedBox(height: 10),
            Text(
              'Genom att skapa ett konto bekräftar du att du är legitimerad '
              'hälso- och sjukvårdspersonal och att du förstår och accepterar '
              'detta ansvar.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Avböj'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAccepted();
          },
          child: const Text('Jag accepterar'),
        ),
      ],
    );
  }
}
