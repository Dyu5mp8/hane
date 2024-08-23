import 'package:flutter/material.dart';
import 'package:hane/medications/medication_list_view/medication_list_view.dart';
import 'package:provider/provider.dart';
import 'package:hane/medications/services/medication_list_provider.dart';


class MedicationInitScreen extends StatelessWidget {
  final String user;

  MedicationInitScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);  // Access the current theme
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Initialize Medications',
          style: textTheme.titleLarge, // Use custom app theme text style
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary.withOpacity(0.8), theme.colorScheme.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'How would you like to start?',
                style: textTheme.headlineLarge!.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildStyledButton(
                context,
                label: 'Start Fresh',
                onPressed: () async {
                  final medicationProvider = Provider.of<MedicationListProvider>(context, listen: false);
                  await medicationProvider.queryMedications(isGettingDefaultList: false, forceFromServer: true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MedicationListView()),
                  );
                },
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(height: 20),
              _buildStyledButton(
                context,
                label: 'Copy from Master',
                onPressed: () async {
                  final medicationProvider = Provider.of<MedicationListProvider>(context, listen: false);
                  medicationProvider.setUserData(user);
                  await medicationProvider.copyMasterToUser();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MedicationListView()),
                  );
                },
                color: theme.colorScheme.tertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}