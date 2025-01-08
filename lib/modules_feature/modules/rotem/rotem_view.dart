import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
// Your existing imports...
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/field_config.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/rotem_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/thorax_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/obstetric_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/liver_evaluation_strategy.dart';
import 'package:hane/ui_components/category_chips.dart';

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
    ThoraxEvaluationStrategy(),
    ObstetricEvaluationStrategy(),
    LiverFailureEvaluationStrategy(),
  ];
  int _selectedStrategyIndex = 0;

  // One GlobalKey<FormState> per step (except step 0).
  final _formKeys = List.generate(_totalSteps, (_) => GlobalKey<FormState>());

  // Track whether each step is valid (null = untested, false = error, true = ok)
  final List<bool?> _stepValidity = List.filled(_totalSteps, null);

  // Once the user completes all steps, show the final recommended actions
  bool _wizardCompleted = false;

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
          Positioned(

              left: MediaQuery.sizeOf(context).width - 150,
              top: MediaQuery.sizeOf(context).height/4,
              child: _buildMiniSummaryCard(),
            ),
        ]
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
      onStepCancel: _onStepCancel,
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
                _buildNumField('CT EXTEM (sec)', RotemField.ctExtem),
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
      selectedCategory: _allStrategies[_selectedStrategyIndex].name,
      onCategorySelected: (selectedCategory) {
        setState(() {
      
          _selectedStrategyIndex = _allStrategies.indexWhere(
        
            (s) => s.name == selectedCategory,
          );
        });
      },
    );
  }

  // ──────────────────────────────────────────
  // UPDATED _buildNumField USING FieldConfig’s minValue/maxValue
  Widget _buildNumField(String label, RotemField field) {
    // Find the currently selected strategy
    final strategy = _allStrategies[_selectedStrategyIndex];

    // Find the config for the requested field, if it exists
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
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.00),
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

  String _buildHintText(FieldConfig config) {
    final minStr =
        (config.minValue != null) ? '${config.minValue!.toInt()}' : '0';
    final maxStr =
        (config.maxValue != null) ? '${config.maxValue!.toInt()}' : '∞';
    return '$minStr - $maxStr';
  }

  // ──────────────────────────────────────────
  // DRAGGABLE OVERLAY SUMMARY (mini summary in top layer)
  Widget _buildMiniSummaryCard() {
    return Card(
      elevation: 6,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(8),
          child: _buildMiniQuadrantSummary(),
        ),
      ),
    );
  }

  Widget _buildMiniQuadrantSummary() {
    final fibtemLines = [
      'CT: ${_inputValues[RotemField.ctFibtem] ?? ''}',
      'A5: ${_inputValues[RotemField.a5Fibtem] ?? ''}',
      'A10: ${_inputValues[RotemField.a10Fibtem] ?? ''}',
    ];
    final extemLines = [
      'CT: ${_inputValues[RotemField.ctExtem] ?? ''}',
      'A5: ${_inputValues[RotemField.a5Extem] ?? ''}',
      'A10: ${_inputValues[RotemField.a10Extem] ?? ''}',
      'ML: ${_inputValues[RotemField.mlExtem] ?? ''}',
      'LI30: ${_inputValues[RotemField.li30Extem] ?? ''}',
    ];
    final intemLines = [
      'CT: ${_inputValues[RotemField.ctIntem] ?? ''}',
    ];
    final heptemLines = [
      'CT: ${_inputValues[RotemField.ctHeptem] ?? ''}',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Inmatade värden',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildQuadrantCell('FIBTEM', fibtemLines)),
            const SizedBox(width: 8),
            Expanded(child: _buildQuadrantCell('EXTEM', extemLines)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildQuadrantCell('INTEM', intemLines)),
            const SizedBox(width: 8),
            Expanded(child: _buildQuadrantCell('HEPTEM', heptemLines)),
          ],
        ),
      ],
    );
  }

  Widget _buildQuadrantCell(String title, List<String> lines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
        for (final line in lines) Text(line, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  // ──────────────────────────────────────────
  // FINAL EVALUATION RESULTS
  Widget _buildEvaluationResults() {
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
      strategy: _allStrategies[_selectedStrategyIndex],
    );

    // Evaluate to get recommended actions (or messages)
    final Map<String, Dosage> actions = evaluator.evaluate();

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
          if (actions.isEmpty) const Text('No specific actions.'),
          for (final entry in actions.entries)
            Text('• ${entry.key}: ${entry.value}'),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // CORNER-SNAPPING
  void _snapOverlayToCorner() {
    final screenSize = MediaQuery.of(context).size;
    const overlayWidth = 220;  // must match the card width
    const overlayHeight = 180; // approximate card height after padding

    final corners = [
      const Offset(10, 0), // top-left
      Offset(screenSize.width - overlayWidth - 40, 0), // top-right
      Offset(10, screenSize.height - overlayHeight - 80), // bottom-left
      Offset(screenSize.width - overlayWidth - 40,
          screenSize.height - overlayHeight - 80), // bottom-right
    ];

    double minDist = double.infinity;
    Offset bestCorner = corners.first;
    for (final c in corners) {
      final dist = (c - _overlayOffset).distanceSquared;
      if (dist < minDist) {
        minDist = dist;
        bestCorner = c;
      }
    }
    setState(() => _overlayOffset = bestCorner);
  }

  // ──────────────────────────────────────────
  // STEPPER LOGIC
  void _onStepTapped(int stepIndex) {
    setState(() => _currentStep = stepIndex);
    // Reposition overlay whenever a step is tapped:
    _snapOverlayToCorner();
  }

  void _onStepContinue() {
    // Step 0 has no actual form fields, so skip validation
    if (_currentStep == 0) {
      setState(() => _currentStep = 1);
      _snapOverlayToCorner();
      return;
    }

    // 1) Per-field validation on the current step
    final formKey = _formKeys[_currentStep];
    final isValid = formKey.currentState?.validate() ?? false;
    _stepValidity[_currentStep] = isValid; // track validity state

    if (!isValid) {
      // If this step’s fields are invalid, don’t proceed
      setState(() {});
      return;
    }

    // Save the field values into _inputValues
    formKey.currentState?.save();

    // 2) If we are on the last step, run strategy-level validation
    if (_currentStep == _totalSteps - 1) {
      final selectedStrategy = _allStrategies[_selectedStrategyIndex];
      final globalError = selectedStrategy.validateAll(_inputValues);

      if (globalError != null) {
        // The strategy says something is still missing or invalid
        // => Show a dialog or a SnackBar to the user
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
        // Mark this step invalid
        _stepValidity[_currentStep] = false;
        setState(() {});
        return; // Stop here
      }

      // Otherwise, everything is good => mark wizard completed
      setState(() => _wizardCompleted = true);

      // Optionally show a summary dialog
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

      // Show a quick toast
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All steps completed!')),
      );
    } else {
      // Not the last step => move to the next
      setState(() => _currentStep += 1);
    }

    // Re-snap the draggable overlay
    _snapOverlayToCorner();
  }

  void _onStepCancel() {
    if (_currentStep == 0) {
      Navigator.pop(context);
    } else {
      setState(() => _currentStep -= 1);
      _snapOverlayToCorner();
    }
  }

  // Updated stepState logic:
  // If a step’s form is known invalid, show StepState.error
  StepState _stepState(int stepIndex) {
    // Step 0 has no fields; ignore validity for step 0
    if (stepIndex == 0) {
      if (_currentStep > stepIndex) return StepState.complete;
      return (_currentStep == stepIndex)
          ? StepState.editing
          : StepState.indexed;
    }

    final stepValid = _stepValidity[stepIndex];
    if (stepValid == false) {
      // The user tried to continue but that step was invalid
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