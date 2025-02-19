import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_view_model.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DialysisPatientDataWidget extends StatelessWidget {
  const DialysisPatientDataWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DialysisViewModel>();

    /// Safely handle null or unexpected values.
    final String weightText =
        (vm.weight > 0) ? vm.weight.toStringAsFixed(0) : 'N/A';
    final String lengthText =
        (vm.patientLength > 0) ? vm.patientLength.toStringAsFixed(0) : 'N/A';
    final String idealWeightText =
        (vm.idealWeight() > 0) ? vm.idealWeight().toStringAsFixed(0) : 'N/A';
    final String hematocritText =
        (vm.hematocritLevel > 0)
            ? (vm.hematocritLevel * 100).toStringAsFixed(0)
            : 'N/A';

    /// You can adapt these text styles to your theme or dark mode needs.
    final titleStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold);
    final subtitleStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontSize: 14);

    return GestureDetector(
      onTap: () {
        _showEditDialog(
          context,
          vm,
          weightText,
          lengthText,
          idealWeightText,
          hematocritText,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              Theme.of(context).cardColor, // Removed opacity for better clarity
          borderRadius: BorderRadius.circular(
            12,
          ), // Increased border radius for a smoother look
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Softer shadow color
              offset: const Offset(0, 4), // Increased vertical offset for depth
              blurRadius:
                  12, // Increased blur radius for a more diffused shadow
            ),
          ],
          border: Border.all(
            width: 1,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withOpacity(0.2), // Softer border color
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
              semanticLabel: 'Patient ikon',
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text('Ordinationsvikt: $idealWeightText kg', style: titleStyle),
                Text('Vikt: $weightText kg', style: subtitleStyle),
                Text('Längd: $lengthText cm', style: subtitleStyle),
                Text('Hematokrit: $hematocritText %', style: subtitleStyle),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,

              semanticLabel: 'Gå till detaljer',
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    DialysisViewModel vm,
    String weightText,
    String lengthText,
    String idealWeightText,
    String hematocritText,
  ) {
    final formKey = GlobalKey<FormState>();

    // Controllers
    final TextEditingController weightController = TextEditingController(
      text: weightText != 'N/A' ? weightText : '',
    );
    final TextEditingController lengthController = TextEditingController(
      text: lengthText != 'N/A' ? lengthText : '',
    );
    final TextEditingController hematocritController = TextEditingController(
      text: hematocritText != 'N/A' ? hematocritText : '',
    );

    // FocusNodes for KeyboardActions
    final FocusNode weightFocus = FocusNode();
    final FocusNode lengthFocus = FocusNode();
    final FocusNode hematocritFocus = FocusNode();

    // Save form method
    void saveForm() {
      if (formKey.currentState?.validate() ?? false) {
        final double newWeight = double.parse(weightController.text.trim());
        final double newLength = double.parse(lengthController.text.trim());
        final double newHematocrit = double.parse(
          hematocritController.text.trim(),
        );

        // Update the ViewModel
        vm.weight = newWeight;
        vm.patientLength = newLength;
        vm.hematocritLevel = newHematocrit / 100;

        // Close the dialog
        Navigator.of(context).pop();
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return KeyboardActions(
          config: KeyboardActionsConfig(
            keyboardActionsPlatform:
                !kIsWeb
                    ? KeyboardActionsPlatform.ALL
                    : KeyboardActionsPlatform.IOS,
            keyboardBarColor: Theme.of(context).colorScheme.surfaceBright,
            actions: [
              KeyboardActionsItem(
                focusNode: weightFocus,
                toolbarButtons: [
                  (node) {
                    return GestureDetector(
                      onTap: () => node.nextFocus(),
                      child: Row(
                        children: [
                          Text(
                            "Nästa",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward),
                          const SizedBox(width: 8),
                        ],
                      ),
                    );
                  },
                ],
              ),
              KeyboardActionsItem(
                focusNode: lengthFocus,
                toolbarButtons: [
                  (node) {
                    return GestureDetector(
                      onTap: () => node.nextFocus(),
                      child: Row(
                        children: [
                          Text(
                            "Nästa",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward),
                          const SizedBox(width: 8),
                        ],
                      ),
                    );
                  },
                ],
              ),
              KeyboardActionsItem(
                focusNode: hematocritFocus,
                toolbarButtons: [
                  (node) {
                    return GestureDetector(
                      onTap: saveForm,
                      child: Row(
                        children: [
                          Text(
                            "Klar",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.check),
                          const SizedBox(width: 8),
                        ],
                      ),
                    );
                  },
                ],
              ),
            ],
          ),
          child: AlertDialog(
            title: const Text('Redigera patientdata'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Vikt (Weight)
                    TextFormField(
                      focusNode: weightFocus,
                      controller: weightController,
                      decoration: const InputDecoration(
                        labelText: 'Vikt (kg)',
                        hintText: 'Ange vikt',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vikt är obligatoriskt';
                        }
                        final number = double.tryParse(value);
                        if (number == null || number <= 0) {
                          return 'Ange ett giltigt positivt tal';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Längd (Length)
                    TextFormField(
                      focusNode: lengthFocus,
                      controller: lengthController,
                      decoration: const InputDecoration(
                        labelText: 'Längd (cm)',
                        hintText: 'Ange längd',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Längd är obligatoriskt';
                        }
                        final number = double.tryParse(value);
                        if (number == null || number <= 0) {
                          return 'Ange ett giltigt positivt tal';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Hematokrit
                    TextFormField(
                      focusNode: hematocritFocus,
                      controller: hematocritController,

                      decoration: const InputDecoration(
                        labelText: 'Hematokrit (%)',
                        hintText: 'Ange hematokrit',
                        suffixText: '%',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Hematokrit är obligatoriskt';
                        }
                        final number = double.tryParse(value);
                        if (number == null || number < 2 || number > 100) {
                          return 'Ange ett rimligt värde (vanligen 20-50%)';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Avbryt'),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
              ElevatedButton(onPressed: saveForm, child: const Text('Spara')),
            ],
          ),
        );
      },
    );
  }
}
