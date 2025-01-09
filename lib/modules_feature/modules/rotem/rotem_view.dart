import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/rotem/evaluation_result.dart';
import 'package:hane/modules_feature/modules/rotem/mini_summary_card.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/field_config.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_action.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/misc_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/obstetric_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/liver_evaluation_strategy.dart';
import 'package:hane/ui_components/category_chips.dart';
import 'package:hane/ui_components/dosage_snippet.dart';

class RotemWizardScreen extends StatefulWidget {
  const RotemWizardScreen({super.key});

  @override
  State<RotemWizardScreen> createState() => _RotemWizardScreenState();
}

class _RotemWizardScreenState extends State<RotemWizardScreen> {
  int _currentStep = 0;
  int _totalSteps = 1; // Initially one step.

  final List<RotemEvaluationStrategy> _allStrategies = [
    MiscEvaluationStrategy(),
    ObstetricEvaluationStrategy(),
    LiverFailureEvaluationStrategy(),
  ];

  int? _selectedStrategyIndex;
  RotemEvaluationStrategy? get selectedStrategy =>
      _selectedStrategyIndex == null ? null : _allStrategies[_selectedStrategyIndex!];

  List<GlobalKey<FormState>> _formKeys = [];
  List<bool?> _stepValidity = [];

  bool _wizardCompleted = false;
  bool _shouldShowSummary = false;
  final Map<RotemField, String> _inputValues = {};

  // Unique key for the Stepper to force rebuild when steps count changes.
  Key _stepperKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    // Initialize with one step.
    _formKeys = List.generate(_totalSteps, (_) => GlobalKey<FormState>());
    _stepValidity = List.filled(_totalSteps, null);
  }

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
                if (_wizardCompleted) _buildEvaluationResults(),
              ],
            ),
          ),
          if (_shouldShowSummary)
            Positioned(
              left: MediaQuery.sizeOf(context).width - 150,
              top: MediaQuery.sizeOf(context).height / 8,
              child: Column(
                
                children: [
                  MiniSummaryCard(
                    strategy: selectedStrategy,
                    inputValues: _inputValues,
                  ),
                  if (selectedStrategy?.validateAll(_inputValues) == null)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _wizardCompleted = true;
                        });
                      },
                      child: const Text('Gå till resultat'),
                    ),
   
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepperContent() {
    return Stepper(
      key: _stepperKey,
      type: StepperType.vertical,
      currentStep: _currentStep,
      onStepTapped: _onStepTapped,
      steps: _buildSteps(),
      onStepContinue: _onStepContinue,
      controlsBuilder: (context, details) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(
                  (_currentStep < _totalSteps - 1) || (_totalSteps == 1) ? 'Nästa steg' : 'Se resultat',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Step> _buildSteps() {
    // Always start with the strategy picker step.
    List<Step> steps = [
      Step(
        title: const Text('Välj kontext'),
        subtitle: selectedStrategy == null
            ? null
            : Text(
                'Vald klinisk kontext: ${selectedStrategy?.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
        isActive: _currentStep == 0,
        state: _stepState(0),
        content: Align(
          alignment: Alignment.centerLeft,
          child: _buildStrategyPicker(),
        ),
      ),
    ];

    // If a strategy is selected, dynamically build additional steps based on sections.
    if (selectedStrategy != null) {
      // Group fields by section.
      final fieldsBySection = <RotemSection, List<FieldConfig>>{};
      for (var fieldConfig in selectedStrategy!.getRequiredFields()) {
        fieldsBySection.putIfAbsent(fieldConfig.section, () => []).add(fieldConfig);
      }

      // For each section, create a step.
      int stepIndex = 1; // starting index for steps after the picker
      fieldsBySection.forEach((section, fields) {
        steps.add(
          Step(
            title: Text(section.name.toUpperCase()),
            isActive: _currentStep == stepIndex,
            state: _stepState(stepIndex),
            content: Align(
              alignment: Alignment.centerLeft,
              child: Form(
                key: _formKeys.length > stepIndex ? _formKeys[stepIndex] : GlobalKey<FormState>(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: fields.map((fieldConfig) {
                    return _buildNumField(fieldConfig.label, fieldConfig.field);
                  }).toList(),
                ),
              ),
            ),
          ),
        );
        stepIndex++;
      });
    }

    return steps;
  }

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
          _inputValues.clear();
          _currentStep = 0;
          _wizardCompleted = false;
          _shouldShowSummary = false;

          // After selecting a strategy, determine the number of unique sections.
          final sections = selectedStrategy!.getRequiredFields()
              .map((fc) => fc.section)
              .toSet();
          _totalSteps = 1 + sections.length; // 1 for strategy picker + one per section

          _formKeys = List.generate(_totalSteps, (_) => GlobalKey<FormState>());
          _stepValidity = List.filled(_totalSteps, null);

          // Force Stepper to rebuild with a new key to handle changed steps length.
          _stepperKey = UniqueKey();
        });
      },
    );
  }

  Widget _buildNumField(String label, RotemField field) {
    final RotemEvaluationStrategy? strategy = selectedStrategy;
    if (strategy == null) {
      return const SizedBox.shrink();
    }

    // Retrieve field config to know if required, etc.
    late final FieldConfig fieldConfig;
    try {
      fieldConfig = strategy.getRequiredFields().firstWhere((cfg) => cfg.field == field);
    } on StateError {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: 120,
        child: TextFormField(
          textAlign: TextAlign.left,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 10),
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          ),
          style: const TextStyle(fontSize: 12),
          validator: (value) {
            if (_currentStep == 0) return null;
            if (value == null || value.trim().isEmpty) {
              if (fieldConfig.isRequired) {
                return 'Obligatoriskt';
              }
              return null;
            }
            final parsed = double.tryParse(value);
            if (parsed == null) {
              return 'Felaktig inmatning';
            }
            return null;
          },
          onSaved: (val) {
            if (val != null) {
              _inputValues[field] = val;
            }
          },
          initialValue: _inputValues[field],

              onFieldSubmitted: (_) {
          FocusScope.of(context).nextFocus();
        },
        ),
      ),
    );
  }
Widget _buildEvaluationResults() {
  if (selectedStrategy == null) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text('Ingen strategi vald. Vänligen välj en strategi.'),
    );
  }

  double? parseField(RotemField f) => double.tryParse(_inputValues[f] ?? '');

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

  return EvaluationResult(evaluator: evaluator);
}

  void _onStepTapped(int step) {
    if (selectedStrategy == null && step > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Välj en strategi först')));
      setState(() => _currentStep = 0);
      return;
    }
    if (selectedStrategy != null && _shouldShowSummary == false) {
      setState(() => _shouldShowSummary = true);
    }
    setState(() => _currentStep = step);
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      if (selectedStrategy == null) {
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

    final formKey = _formKeys[_currentStep];
    final isValid = formKey.currentState?.validate() ?? false;
    _stepValidity[_currentStep] = isValid;

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
          title: const Text('Inmatningen är färdig'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Värden'),
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
        const SnackBar(content: Text('Inmatningen är färdig')),
      );
    } else {
      setState(() => _currentStep += 1);
    }
  }

  StepState _stepState(int stepIndex) {
    if (stepIndex == 0) {
      if (_currentStep > stepIndex) return StepState.complete;
      return (_currentStep == stepIndex) ? StepState.editing : StepState.indexed;
    }

    final stepValid = _stepValidity.length > stepIndex ? _stepValidity[stepIndex] : null;
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