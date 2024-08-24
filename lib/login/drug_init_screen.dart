import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_list_view/drug_list_view.dart';
import 'package:provider/provider.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class DrugInitScreen extends StatelessWidget {
  final String user;

  DrugInitScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ny användare?',
          style: textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ), // Use custom app theme text style
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.8),
              theme.colorScheme.primary
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Välj hur du vill börja',
                style: textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildStyledButton(
                context,
                label: "Påbörja en blank lista",
                onPressed: () async {
                  final drugProvider = Provider.of<DrugListProvider>(context, listen: false);
                  await drugProvider.queryDrugs(isGettingDefaultList: false, forceFromServer: true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DrugListView()),
                  );
                },
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(height: 20),
              _buildStyledButton(
                context,
                label: 'Kopiera från stamlistan',
                onPressed: () async {
                  final drugProvider = Provider.of<DrugListProvider>(context, listen: false);
                  drugProvider.setUserData(user);
                  await drugProvider.copyMasterToUser();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DrugListView()),
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
        backgroundColor: color, // Use the passed color for background
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimary, // Ensure text is readable
        ),
      ),
    );
  }
}