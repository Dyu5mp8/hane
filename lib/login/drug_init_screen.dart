import 'package:flutter/material.dart';
import 'package:hane/drugs/services/drug_list_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class DrugInitScreen extends StatelessWidget {
  final String user;

  const DrugInitScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ny användare?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildModeCard(
              context,
              title: 'Påbörja en blank lista',
              description:
                  'Skapa din egen lista från grunden utan några förinställda läkemedel. Detta ger dig full kontroll över innehållet.',
              buttonText: 'Börja med en blank lista',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DrugListWrapper()),
                );
              },
              icon: Icons.create,
              cardColor: const Color(0xFFE8F5E9), // Soft green background
              buttonColor: const Color(0xFF66BB6A), // Harmonious green button
            ),
            const SizedBox(height: 20),
            _buildModeCard(
              context,
              title: 'Kopiera från stamlistan',
              description:
                  'Kopiera över läkemedel från stamlistan för en snabb start. Du kan sedan redigera dem efter behov.',
              buttonText: 'Kopiera från stamlistan',
              onPressed: () async {
                final drugProvider = Provider.of<DrugListProvider>(context, listen: false);
                await drugProvider.copyMasterToUser();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DrugListWrapper()),
                );
              },
              icon: Icons.copy,
              cardColor: const Color(0xFFE3F2FD), // Soft blue background
              buttonColor: const Color(0xFF42A5F5), // Harmonious blue button
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
    required IconData icon,
    required Color cardColor,
    required Color buttonColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Icon(icon, size: 40, color: Theme.of(context).primaryColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 16,
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text(buttonText, style: Theme.of(context).textTheme.headlineMedium),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}