import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/nutrition_main_view/nutrition_view_model.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PatientDataWidget extends StatelessWidget {
  const PatientDataWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NutritionViewModel>();

    /// Safely handle null or unexpected values.
    final String weightText =
        (vm.patientWeight > 0) ? vm.patientWeight.toStringAsFixed(0) : 'N/A';
    final String lengthText =
        (vm.patientLength > 0) ? vm.patientLength.toStringAsFixed(0) : 'N/A';
    final String idealWeightText =
        (vm.idealWeight() > 0) ? vm.idealWeight().toStringAsFixed(0) : 'N/A';

    /// You can adapt these text styles to your theme or dark mode needs.
    final titleStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold);
    final subtitleStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontSize: 14);

    return GestureDetector(
      onTap: () {
        _showEditDialog(context, vm, weightText, lengthText, idealWeightText);
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Static Text
                    Text('Vårddygn: ', style: subtitleStyle),
                    // AnimatedSwitcher for Dynamic Text
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                      ) {
                        // Combine Fade, Scale, and Slide Transitions
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(
                              0.0,
                              0.5,
                            ), // Start slightly below
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        '${vm.day}',
                        key: ValueKey<int>(
                          vm.day,
                        ), // Unique Key based on vm.day
                        style: subtitleStyle, // Optional styling
                      ),
                    ),
                  ],
                ),
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
    NutritionViewModel vm,
    String weightText,
    String lengthText,
    String idealWeightText,
  ) {
    final formKey = GlobalKey<FormState>();

    // Controllers
    final TextEditingController weightController = TextEditingController(
      text: weightText != 'N/A' ? weightText : '',
    );
    final TextEditingController lengthController = TextEditingController(
      text: lengthText != 'N/A' ? lengthText : '',
    );
    final TextEditingController dayController = TextEditingController(
      text: vm.day.toString(),
    );

    // FocusNodes for KeyboardActions
    final FocusNode weightFocus = FocusNode();
    final FocusNode lengthFocus = FocusNode();
    final FocusNode dayFocus = FocusNode();

    // Save form method
    void saveForm() {
      if (formKey.currentState?.validate() ?? false) {
        final double newWeight = double.parse(weightController.text.trim());
        final double newLength = double.parse(lengthController.text.trim());
        final int newDay = int.parse(dayController.text.trim());

        // Update the ViewModel
        vm.setNewWeight(newWeight);
        vm.setNewLength(newLength);
        vm.setNewDay(newDay);

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
                focusNode: dayFocus,
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
                    // Vårddygn (Day)
                    TextFormField(
                      focusNode: dayFocus,
                      controller: dayController,
                      decoration: const InputDecoration(
                        labelText: 'Vårddygn',
                        hintText: 'Ange antal vårddygn',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vårddygn är obligatoriskt';
                        }
                        final number = int.tryParse(value);
                        if (number == null || number < 0) {
                          return 'Ange ett giltigt icke-negativt heltal';
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
