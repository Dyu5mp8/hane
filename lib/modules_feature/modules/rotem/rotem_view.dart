
import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/rotem/evaluation_result.dart';
import 'package:hane/modules_feature/modules/rotem/mini_summary_card.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/field_config.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluation_strategy.dart';

import 'package:hane/modules_feature/modules/rotem/models/strategies/misc_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/obstetric_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/liver_evaluation_strategy.dart';
import 'package:hane/ui_components/category_chips.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:flutter/foundation.dart';

class RotemWizardScreen extends StatefulWidget {
  const RotemWizardScreen({super.key});

  @override
  State<RotemWizardScreen> createState() => _RotemWizardScreenState();
}

class _RotemWizardScreenState extends State<RotemWizardScreen> {
  int _currentStep = 0;
  int _totalSteps = 1; // Initially one step.
  final List<FocusNode> _focusNodes = [];
  final Map<RotemField, FocusNode> _fieldFocusNodes = {};
  final List<RotemEvaluationStrategy> _allStrategies = [
    MiscEvaluationStrategy(),
    ObstetricEvaluationStrategy(),
    LiverFailureEvaluationStrategy(),
  ];

  final RotemEvaluator evaluator = RotemEvaluator();

  int? _selectedStrategyIndex;
  RotemEvaluationStrategy? get selectedStrategy =>
      _selectedStrategyIndex != null
          ? _allStrategies[_selectedStrategyIndex!]
          : null;

  List<GlobalKey<FormState>> _formKeys = [];
  List<bool?> _stepValidity = [];
  bool _shouldShowSummary = false;
  final Map<RotemField, String> _inputValues = {};
  List<FocusNode> get _allFocusNodes => _fieldFocusNodes.values.toList();

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
  void dispose() {
    // Dispose all focus nodes when done.
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ROTEM guide')),
      body: KeyboardActions(
        config: _buildKeyboardActionsConfig(),
        child: Stack(
          children: [
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(children: [_buildStepperContent()]),
            ),
            if (_shouldShowSummary)
              Positioned(
                left: MediaQuery.sizeOf(context).width - 150,
                top: MediaQuery.sizeOf(context).height / 8,
                child: Column(
                  children: [
                    MiniSummaryCard(
                      strategy: evaluator.strategy,
                      inputValues: _inputValues,
                    ),
                    if (evaluator.strategy?.validateAll(_inputValues) == null)
                      ElevatedButton(
                        onPressed: () {
                          evaluator.parseAndSet(_inputValues);
                          showResultsModal();
                        },
                        child: const Text('Gå till resultat'),
                      ),
                  ],
                ),
              ),
          ],
        ),
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
                  (_currentStep < _totalSteps - 1) || (_totalSteps == 1)
                      ? 'Nästa steg'
                      : 'Se resultat',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Step> _buildSteps() {
    final stepStyle = StepStyle(
      color: Theme.of(context).colorScheme.tertiaryFixed,
    );

    // Always start with the strategy picker step.
    List<Step> steps = [
      Step(
        stepStyle: stepStyle,
        title: const Text('Välj kontext'),
        subtitle:
            evaluator.strategy == null
                ? null
                : Text(
                  'Vald klinisk kontext: ${evaluator.strategy!.name}',
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
    if (evaluator.strategy != null) {
      // Define the desired order of sections
      const sectionOrder = [
        RotemSection.fibtem,
        RotemSection.extem,
        RotemSection.intem,
        RotemSection.heptem,
      ];

      // Group fields by section.
      final fieldsBySection = <RotemSection, List<FieldConfig>>{};
      for (var fieldConfig in evaluator.strategy!.getRequiredFields()) {
        fieldsBySection
            .putIfAbsent(fieldConfig.section, () => [])
            .add(fieldConfig);
      }

      // For each section in the desired order, create a step if it exists in the map.
      int stepIndex = 1; // Starting index for steps after the picker
      for (var section in sectionOrder) {
        if (fieldsBySection.containsKey(section)) {
          final fields = fieldsBySection[section]!;

          // Create a step for the section
          steps.add(
            Step(
              title: Text(section.name.toUpperCase()),
              isActive: _currentStep == stepIndex,
              state: _stepState(stepIndex),
              stepStyle: stepStyle,
              content: Align(
                alignment: Alignment.centerLeft,
                child: Form(
                  key:
                      _formKeys.length > stepIndex
                          ? _formKeys[stepIndex]
                          : GlobalKey<FormState>(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        fields.map((fieldConfig) {
                          return _buildNumField(
                            fieldConfig.label,
                            fieldConfig.field,
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          );
          stepIndex++;
        }
      }
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
          // First update the selected strategy index.
          _selectedStrategyIndex = _allStrategies.indexWhere(
            (s) => s.name == selectedCategory,
          );

          // Now that selectedStrategy is updated, assign it to the evaluator.
          evaluator.strategy = selectedStrategy;

          _inputValues.clear();
          evaluator.clear();
          _currentStep = 0;

          _shouldShowSummary = false;

          // After selecting a strategy, determine the number of unique sections.
          final sections =
              selectedStrategy!
                  .getRequiredFields()
                  .map((fc) => fc.section)
                  .toSet();
          _totalSteps =
              1 + sections.length; // 1 for strategy picker + one per section

          _formKeys = List.generate(_totalSteps, (_) => GlobalKey<FormState>());
          _stepValidity = List.filled(_totalSteps, null);

          // Force Stepper to rebuild with a new key to handle changed steps length.
          _stepperKey = UniqueKey();
          _fieldFocusNodes.clear();
          _focusNodes.clear();
          for (var fieldConfig in selectedStrategy!.getRequiredFields()) {
            final node = FocusNode();
            _fieldFocusNodes[fieldConfig.field] = node;
            _focusNodes.add(node);
          }
        });
      },
    );
  }

  Widget _buildNumField(String label, RotemField field) {
    final strategy = evaluator.strategy;
    if (strategy == null) return const SizedBox.shrink();

    late final FieldConfig fieldConfig;
    try {
      fieldConfig = strategy.getRequiredFields().firstWhere(
        (cfg) => cfg.field == field,
      );
    } on StateError {
      return const SizedBox.shrink();
    }

    final focusNode = _fieldFocusNodes[field] ?? FocusNode();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: 120,
        child: TextFormField(
          focusNode: focusNode,
          textAlign: TextAlign.left,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,

          decoration: InputDecoration(
            labelStyle: Theme.of(context).textTheme.bodyLarge,
            label:
                fieldConfig.isRequired
                    ? RichText(
                      text: TextSpan(
                        text: '$label ',

                        style: Theme.of(context).textTheme.bodyLarge,
                        children: const [
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ],
                      ),
                    )
                    : Text(label),
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 4,
            ),
          ),
          style: const TextStyle(fontSize: 12),
          validator: (value) {
            if (_currentStep == 0) return null;
            if (value == null || value.trim().isEmpty) {
              if (fieldConfig.isRequired) return 'Obligatoriskt';
              return null;
            }
            if (double.tryParse(value) == null) return 'Felaktig inmatning';
            return null;
          },
          onSaved: (val) {
            if (val != null) _inputValues[field] = val;
          },
          initialValue: _inputValues[field],
          onFieldSubmitted: (_) {
            FocusScope.of(context).nextFocus();
          },
          onTapOutside: (event) {
            final formState =
                focusNode.context != null ? Form.of(focusNode.context!) : null;
            setState(() {
              if (formState != null) {
                formState.save();
              }
            });
          },
        ),
      ),
    );
  }

  void _onStepTapped(int step) {
    if (evaluator.strategy == null && step > 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Välj en strategi först')));
      setState(() => _currentStep = 0);
      return;
    }
    if (evaluator.strategy != null && _shouldShowSummary == false) {
      setState(() => _shouldShowSummary = true);
    }
    setState(() => _currentStep = step);
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      if (evaluator.strategy == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Välj en strategi först')));
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
      final globalError = evaluator.strategy!.validateAll(_inputValues);

      if (globalError != null) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
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

      // Use the existing evaluator and update its fields in bulk
      evaluator.parseAndSet(_inputValues);

      // Display evaluation result in a modal dialog
      showResultsModal();

      // Optionally show a snackbar or perform other UI updates
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Inmatningen är färdig')));
    } else {
      setState(() => _currentStep += 1);
    }
  }

  void showResultsModal() {
    showModalBottomSheet(
      isDismissible: true,
      scrollControlDisabledMaxHeightRatio: 100,
      context: context,
      builder: (BuildContext context) {
        return EvaluationResult(
          actions: evaluator.evaluate(),
          strategyName: evaluator.strategy!.name,
        );
      },
    );
  }

  StepState _stepState(int stepIndex) {
    if (stepIndex == 0) {
      if (_currentStep > stepIndex) return StepState.complete;
      return (_currentStep == stepIndex)
          ? StepState.editing
          : StepState.indexed;
    }

    if (_currentStep == stepIndex) {
      return StepState.editing;
    } else {
      return StepState.indexed;
    }
  }

  KeyboardActionsConfig _buildKeyboardActionsConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform:
          !kIsWeb ? KeyboardActionsPlatform.ALL : KeyboardActionsPlatform.IOS,
      keyboardBarColor: Theme.of(context).colorScheme.surfaceBright,
      actions:
          _allFocusNodes.map((node) {
            return KeyboardActionsItem(
              displayArrows: false,
              focusNode: node,
              toolbarButtons: [
                (node) {
                  return TextButton(
                    onPressed: () {
                      // Use FocusScope to move to the next field
                      FocusScope.of(context).nextFocus();

                      // Optionally save the current field's form state
                      final currentContext = node.context;
                      if (currentContext != null) {
                        final formState = Form.of(currentContext);
                        formState.save();
                                            }
                    },
                    child: Row(
                      children: [
                        Text(
                          "Nästa",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward),
                      ],
                    ),
                  );
                },
              ],
            );
          }).toList(),
    );
  }
}
