import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/modules_feature/modules/rotem/mini_summary_card.dart';
// Your existing imports...
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/field_config.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/rotem_action.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/rotem_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/misc_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/obstetric_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/liver_evaluation_strategy.dart';
import 'package:hane/ui_components/category_chips.dart';
import 'package:hane/ui_components/dosage_snippet.dart';


class RotemWizardScreen extends StatefulWidget {
  const RotemWizardScreen({Key? key}) : super(key: key);

  @override
  State<RotemWizardScreen> createState() => _RotemWizardScreenState();
}

class _RotemWizardScreenState extends State<RotemWizardScreen> {
  static const _totalSteps = 5;
  int _currentStep = 0;

  // Strategies
  final List<RotemEvaluationStrategy> _allStrategies = [
    MiscEvaluationStrategy(),
    ObstetricEvaluationStrategy(),
    LiverFailureEvaluationStrategy(),
  ];
  int? _selectedStrategyIndex;
  RotemEvaluationStrategy? get selectedStrategy =>
      _selectedStrategyIndex == null ? null : _allStrategies[_selectedStrategyIndex!];

  // One GlobalKey<FormState> per step (except step 0).
  final _formKeys = List.generate(_totalSteps, (_) => GlobalKey<FormState>());

  // Track whether each step is valid (null = untested, false = error, true = ok)
  final List<bool?> _stepValidity = List.filled(_totalSteps, null);

  // Once the user completes all steps, show the final recommended actions
  bool _wizardCompleted = false;
  bool _shouldShowSummary = false;

  // Input values, stored as strings
  final Map<RotemField, String> _inputValues = {};

  // Draggable overlay offset
  Offset _overlayOffset = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ROTEM guide'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                _buildStepperContent(),
                // ──────────────────────────────────────────
                // SHOW EVALUATION RESULTS AT THE VERY BOTTOM
                if (_wizardCompleted) _buildEvaluationResults(),
              ],
            ),
          ),
          // The draggable overlay
    if (_shouldShowSummary)
  Positioned(
    left: MediaQuery.sizeOf(context).width - 150,
    top: MediaQuery.sizeOf(context).height / 8,
    child: MiniSummaryCard(
      strategy: selectedStrategy,
      inputValues: _inputValues,
    ),
  ),
        ],
      ),
    );
  }

  Widget _buildStepperContent() {
    return Stepper(
      type: StepperType.vertical,
      currentStep: _currentStep,
      onStepTapped: _onStepTapped,
      steps: _buildSteps(),
      onStepContinue: _onStepContinue,

      controlsBuilder: (context, details) {
        return Row(
          children: [
            ElevatedButton(
              onPressed: details.onStepContinue,
              child: Text(
                _currentStep < _totalSteps - 1 ? 'Nästa steg' : 'Se resultat',
              ),
            ),
          ],
        );
      },
    );
  }

  List<Step> _buildSteps() {
    return [
      // Step 0 - Strategy Picker
      Step(
        title: const Text('Select Strategy'),
        subtitle: Text('Vald kontext: ${selectedStrategy?.name ?? "Ingen vald"}'),
        isActive: _currentStep == 0,
        state: _stepState(0),
        content: Align(
          alignment: Alignment.centerLeft,
          child: _buildStrategyPicker(),
        ),
      ),
      // Step 1 - FIBTEM
      Step(
        title: const Text('FIBTEM'),
        isActive: _currentStep == 1,
        state: _stepState(1),
        content: Align(
          alignment: Alignment.centerLeft,
          child: Form(
            key: _formKeys[1],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNumField('CT FIBTEM (sec)', RotemField.ctFibtem),
                _buildNumField('A5 FIBTEM (mm)', RotemField.a5Fibtem),
                _buildNumField('A10 FIBTEM (mm)', RotemField.a10Fibtem),
              ],
            ),
          ),
        ),
      ),
      // Step 2 - EXTEM
      Step(
        title: const Text('EXTEM'),
        isActive: _currentStep == 2,
        state: _stepState(2),
        content: Align(
          alignment: Alignment.centerLeft,
          child: Form(
            key: _formKeys[2],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNumField('CT EXTEM (s)', RotemField.ctExtem),
                _buildNumField('A5 EXTEM (mm)', RotemField.a5Extem),
                _buildNumField('A10 EXTEM (mm)', RotemField.a10Extem),
                _buildNumField('ML EXTEM (%)', RotemField.mlExtem),
                _buildNumField('LI30 EXTEM (%)', RotemField.li30Extem),
              ],
            ),
          ),
        ),
      ),
      // Step 3 - INTEM
      Step(
        title: const Text('INTEM'),
        isActive: _currentStep == 3,
        state: _stepState(3),
        content: Align(
          alignment: Alignment.centerLeft,
          child: Form(
            key: _formKeys[3],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNumField('CT INTEM (sec)', RotemField.ctIntem),
              ],
            ),
          ),
        ),
      ),
      // Step 4 - HEPTEM
      Step(
        title: const Text('HEPTEM'),
        isActive: _currentStep == 4,
        state: _stepState(4),
        content: Align(
          alignment: Alignment.centerLeft,
          child: Form(
            key: _formKeys[4],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNumField('CT HEPTEM (sec)', RotemField.ctHeptem),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  // ──────────────────────────────────────────
  // STRATEGY PICKER (STEP 0)
Widget _buildStrategyPicker() {
  return CategoryChips(
    acceptAll: false,
    categories: _allStrategies.map((s) => s.name).toList(),
    selectedCategory: selectedStrategy?.name,
    onCategorySelected: (selectedCategory) {
      setState(() {
        _selectedStrategyIndex = _allStrategies.indexWhere(
          (s) => s.name == selectedCategory,
        );
        // Optionally reset or clear input values if the strategy changed
        _inputValues.clear();
      });
    },
  );
}
  // ──────────────────────────────────────────
  // UPDATED _buildNumField WITH NULL CHECK
  Widget _buildNumField(String label, RotemField field) {
    // Check if selectedStrategy is null
    final RotemEvaluationStrategy? strategy = selectedStrategy;
    if (strategy == null) {
      // Strategy not selected yet, return a disabled or placeholder widget
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
        child: SizedBox(
          width: 120,
          child: TextFormField(
            enabled: false,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(fontSize: 10, color: Colors.grey),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            ),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      );
    }

    // If strategy is available, proceed with normal logic
    late final FieldConfig fieldConfig;
    try {
      fieldConfig = strategy
          .getRequiredFields()
          .firstWhere((cfg) => cfg.field == field);
    } on StateError {
      // If the field is not required by the strategy, don't show it
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: SizedBox(
        width: 120,
        child: TextFormField(
          textAlign: TextAlign.left,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 10),
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 4,
            ),
          ),
          style: const TextStyle(fontSize: 12),
          validator: (value) {
            // If we're on step 0, there's no real fields => skip
            if (_currentStep == 0) return null;

            if (value == null || value.trim().isEmpty) {
              if (fieldConfig.isRequired) {
                return 'Req'; // required
              }
              return null; // OK
            }

            final parsed = double.tryParse(value);
            if (parsed == null) {
              return 'Inv'; // Invalid number
            }
            return null; // OK
          },
          onSaved: (val) {
            if (val != null) {
              _inputValues[field] = val;
            }
          },
          initialValue: _inputValues[field],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────
  // FINAL EVALUATION RESULTS
  Widget _buildEvaluationResults() {
    if (selectedStrategy == null) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Ingen strategi vald. Vänligen välj en strategi.'),
      );
    }

    // Parse numeric values from _inputValues (note: check for null/empty)
    double? parseField(RotemField f) =>
        double.tryParse(_inputValues[f] ?? '');

    // Build RotemEvaluator with final user input
    final evaluator = RotemEvaluator(
      ctFibtem: parseField(RotemField.ctFibtem),
      a5Fibtem: parseField(RotemField.a5Fibtem),
      a10Fibtem: parseField(RotemField.a10Fibtem),
      ctExtem: parseField(RotemField.ctExtem),
      a5Extem: parseField(RotemField.a5Extem),
      a10Extem: parseField(RotemField.a10Extem),
      mlExtem: parseField(RotemField.mlExtem),
      li30Extem: parseField(RotemField.li30Extem),
      ctIntem: parseField(RotemField.ctIntem),
      ctHeptem: parseField(RotemField.ctHeptem),
      strategy: selectedStrategy!,
    );

    // Evaluate to get recommended actions (or messages)
    final Map<String, dynamic> actions = evaluator.evaluate();

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(thickness: 1),
          const SizedBox(height: 8),
          const Text(
            'Recommended Actions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          if (actions.isEmpty)
            const Text('No specific actions.')
          else
            for (final entry in actions.entries) ...[
              // Assuming entry.value is a List<RotemAction>
              for (int i = 0; i < entry.value.length; i++) ...[
                DosageSnippet(
                  dosage: entry.value[i].dosage,
                  onDosageUpdated: (_) {
                    // Update handler logic here
                  },
                  availableConcentrations: entry.value[i].availableConcentrations,
                ),
                // Insert "Eller" between items, but not after the last one
                if (i < entry.value.length - 1) const Text("Eller"),
              ],
            ],
        ],
      ),
    );
  }
void _onStepTapped(int step) {
  if (selectedStrategy == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Välj en strategi först'))
    );
    // If tapping beyond step 0 without a strategy, reset to step 0.
    if (step > 0) {
      setState(() => _currentStep = 0);
    }
    return;
  }
  setState(() => _currentStep = step);
}

  void _onStepContinue() {
    
    // Step 0 logic
    if (_currentStep == 0) {
      if (selectedStrategy == null) {
        // Show a warning if no strategy is selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Välj en strategi först')),
        );
        return;
      }
      setState(() {
        _currentStep += 1;
        if (_currentStep > 0) _shouldShowSummary = true;
      });

      return;
    }

    // Step 1 and onward
    final formKey = _formKeys[_currentStep];
    final isValid = formKey.currentState?.validate() ?? false;
    _stepValidity[_currentStep] = isValid; // track validity state

    if (!isValid) {
      setState(() {});
      return;
    }

    formKey.currentState?.save();

    if (_currentStep == _totalSteps - 1) {
      final selectedStrategy = _allStrategies[_selectedStrategyIndex!];
      final globalError = selectedStrategy.validateAll(_inputValues);

      if (globalError != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Felaktig inmatning'),
            content: Text(globalError),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        _stepValidity[_currentStep] = false;
        setState(() {});
        return;
      }

      setState(() => _wizardCompleted = true);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('All steps completed!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Here are your final values:'),
                const SizedBox(height: 8),
                ..._inputValues.entries.map(
                  (entry) => Text('${entry.key.name}: ${entry.value}'),
                ),
              ],
            ),
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All steps completed!')),
      );
    } else {
      setState(() => _currentStep += 1);
    }

  }


  // Updated stepState logic:
  StepState _stepState(int stepIndex) {
    if (stepIndex == 0) {
      if (_currentStep > stepIndex) return StepState.complete;
      return (_currentStep == stepIndex)
          ? StepState.editing
          : StepState.indexed;
    }

    final stepValid = _stepValidity[stepIndex];
    if (stepValid == false) {
      return StepState.error;
    } else if (_currentStep > stepIndex) {
      return StepState.complete;
    } else if (_currentStep == stepIndex) {
      return StepState.editing;
    } else {
      return StepState.indexed;
    }
  }
}