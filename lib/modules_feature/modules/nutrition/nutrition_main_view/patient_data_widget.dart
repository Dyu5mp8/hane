import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:provider/provider.dart';

class PatientDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NutritionViewModel>();

    /// Safely handle null or unexpected values.
    final String weightText = (vm.patientWeight > 0)
        ? vm.patientWeight.toStringAsFixed(0)
        : 'N/A';
    final String lengthText = (vm.patientLength > 0)
        ? vm.patientLength.toStringAsFixed(0)
        : 'N/A';

    final String idealWeightText = (vm.idealWeight() > 0)
        ? vm.idealWeight().toStringAsFixed(0)
        : 'N/A';

    /// You can adapt these text styles to your theme or dark mode needs.
    final titleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(

          fontWeight: FontWeight.bold,
        );
    final subtitleStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(

        );

    return InkWell(
      onTap: () {
        // TODO: Define an action (e.g., navigate to patient-detail screen or open an edit dialog).
      },
      // Ensures the ripple effect is clipped to the rounded shape
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Dark background to match the screenshot style; adjust if you have a Theme color for cards.
          color: Theme.of(context).cardColor.withOpacity(0.9), 
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.person,
              color: Theme.of(context).primaryColorLight,
              size: 28,
              semanticLabel: 'Patient icon',
            ),
            const SizedBox(width: 12),
            // Show the patient weight and length in a vertical column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  'Ordinationsvikt: $idealWeightText kg',
                  style: titleStyle,
                ),
                Text(
                  'Vikt: $weightText kg',
                  style: subtitleStyle,
                ),  
                Text(
                  'Längd: $lengthText cm',
                  style: subtitleStyle,
                ),
              ],
            ),
            Spacer(),
            // A forward arrow to reinforce that the card is tappable
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white54,
              semanticLabel: 'Go to details',
            ),
          ],
        ),
      ),
    );
  }
}