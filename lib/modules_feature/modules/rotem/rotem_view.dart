import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/field_config.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/liver_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/rotem_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/strategies.dart';
import 'package:hane/ui_components/scroll_indicator.dart';




class RotemScreen extends StatefulWidget {
  @override
  _RotemScreenState createState() => _RotemScreenState();
}

class _RotemScreenState extends State<RotemScreen> {
  final _formKey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();

  // We have multiple strategies. Let's keep them in a list:
  final List<RotemEvaluationStrategy> _strategies = [
    ObstetricEvaluationStrategy(),
    ThoraxEvaluationStrategy(),
    LiverFailureEvaluationStrategy()
  ];

  // Track which strategy is selected
  int _selectedStrategyIndex = 0;

  // The currently active strategy
  RotemEvaluationStrategy get _strategy => _strategies[_selectedStrategyIndex];

  // Controllers/focus nodes
  final Map<RotemField, TextEditingController> _controllers = {};
  final Map<RotemField, FocusNode> _focusNodes = {};

  // Validation / result
  Map<String, String> _actions = {};
  String? _globalError;

  @override
  void initState() {
    super.initState();
    _initControllersAndFocusNodes();
  }

  void _initControllersAndFocusNodes() {
    // Clear any existing
    _controllers.clear();
    _focusNodes.clear();

    // Initialize for whichever strategy is currently active
    for (var field in _strategy.getRequiredFields()) {
      _controllers[field.field] = TextEditingController();
      _focusNodes[field.field] = FocusNode();
    }
  }

  void _switchStrategy(int newIndex) {
    setState(() {
      _selectedStrategyIndex = newIndex;
      _actions.clear();
      _globalError = null;
      // Re-initialize controllers/focus for the new strategy
      _initControllersAndFocusNodes();
    });
  }

  @override
  void dispose() {
    // Dispose controllers & focus nodes
    for (var c in _controllers.values) {
      c.dispose();
    }
    for (var f in _focusNodes.values) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Top-level structure: a Column, so the top/bottom controls are fixed,
    // and only the middle grid is scrollable.
    return Scaffold(
      appBar: AppBar(
        title: const Text('ROTEM Evaluator'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // 1) Strategy Chooser
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _buildStrategyChooser(),
            ),

            // 2) The 2x2 grid in a scrollable area
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Stack(
                  children: [
                    _buildGridLayout(),
                    Positioned(child: ScrollIndicator(scrollController: _scrollController)), 
                  ],
              ),
            ),
          ),

            // 3) Display global error if any
            if (_globalError != null) ...[
              const SizedBox(height: 6),
              Text(
                _globalError!,
                style: const TextStyle(color: Colors.red),
              ),
            ],

            // 4) Evaluate Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: _evaluate,
                child: const Text('Evaluate', style: TextStyle(fontSize: 14)),
              ),
            ),

            // 5) Results
            if (_actions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  children: _buildResultWidgets(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// A Material 3 SegmentedButton for strategy selection
  Widget _buildStrategyChooser() {
    final strategyLabels = ["Obstetric", "Thorax", "Liver Failure"];

    return SegmentedButton<int>(
      segments: List.generate(
        _strategies.length,
        (i) => ButtonSegment<int>(
          value: i,
          label: Text(
            strategyLabels[i],
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
      selected: {_selectedStrategyIndex},
      onSelectionChanged: (Set<int> newSelection) {
        // Typically only one item is selected at a time
        final selectedValue = newSelection.first;
        _switchStrategy(selectedValue);
      },
      showSelectedIcon: false, // Hide default check icon if desired
    );
  }

  /// Builds a 2x2 grid:
  /// - FIBTEM (upper-left)
  /// - EXTEM (upper-right)
  /// - INTEM (lower-left)
  /// - HEPTEM (lower-right)
  Widget _buildGridLayout() {
    // Group fields by their section
    final fields = _strategy.getRequiredFields();
    final fieldsBySection = <RotemSection, List<FieldConfig>>{};
    for (var f in fields) {
      fieldsBySection.putIfAbsent(f.section, () => []).add(f);
    }

    return Column(
      children: [
        // Upper Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FIBTEM (upper-left)
            Expanded(
              child: _buildSectionWidget(RotemSection.fibtem, fieldsBySection),
            ),
            const SizedBox(width: 8),
            // EXTEM (upper-right)
            Expanded(
              child: _buildSectionWidget(RotemSection.extem, fieldsBySection),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Lower Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INTEM (lower-left)
            Expanded(
              child: _buildSectionWidget(RotemSection.intem, fieldsBySection),
            ),
            const SizedBox(width: 8),
            // HEPTEM (lower-right)
            Expanded(
              child: _buildSectionWidget(RotemSection.heptem, fieldsBySection),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds a widget for a specific section if it has fields.
  Widget _buildSectionWidget(RotemSection section,
      Map<RotemSection, List<FieldConfig>> fieldsBySection) {
    final sectionFields = fieldsBySection[section];
    if (sectionFields == null || sectionFields.isEmpty) {
      return Container(); // No fields for this section
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _sectionTitle(section),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          for (final field in sectionFields) _buildField(field),
        ],
      ),
    );
  }

  String _sectionTitle(RotemSection section) {
    switch (section) {
      case RotemSection.fibtem:
        return 'FIBTEM';
      case RotemSection.extem:
        return 'EXTEM';
      case RotemSection.intem:
        return 'INTEM';
      case RotemSection.heptem:
        return 'HEPTEM';
    }
  }

  Widget _buildField(FieldConfig config) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        style: const TextStyle(fontSize: 14),
        controller: _controllers[config.field],
        focusNode: _focusNodes[config.field],
        keyboardType: config.inputType,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: config.label,
          labelStyle: const TextStyle(fontSize: 12),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        ),
        validator: (value) {
          if (config.required && (value == null || value.isEmpty)) {
            return '${config.label} is required';
          }
          if (config.validator != null) {
            return config.validator!(value);
          }
          return null;
        },
      ),
    );
  }

  void _evaluate() {
    setState(() {
      _globalError = null;
    });

    if (!_formKey.currentState!.validate()) {
      return; // If per-field validation fails, stop here.
    }

    // Gather field values
    final values = <RotemField, String?>{};
    _controllers.forEach((field, controller) {
      values[field] = controller.text;
    });

    // Cross-field validation from the strategy
    final crossFieldError = _strategy.validateAll(values);
    if (crossFieldError != null) {
      setState(() {
        _globalError = crossFieldError;
      });
      return;
    }

    // Build evaluator
    final evaluator = RotemEvaluator(
      ctExtem: _parseDouble(values[RotemField.ctExtem]),
      ctIntem: _parseDouble(values[RotemField.ctIntem]),
      a5Fibtem: _parseDouble(values[RotemField.a5Fibtem]),
      a10Fibtem: _parseDouble(values[RotemField.a10Fibtem]),
      a5Extem: _parseDouble(values[RotemField.a5Extem]),
      a10Extem: _parseDouble(values[RotemField.a10Extem]),
      mlExtem: _parseDouble(values[RotemField.mlExtem]),
      ctHeptem: _parseDouble(values[RotemField.ctHeptem]),
      strategy: _strategy,
    );

    setState(() {
      _actions = _strategy.evaluate(evaluator);
    });
  }

  List<Widget> _buildResultWidgets() {
    return _actions.entries.map((entry) {
      return Text(
        '${entry.key}: ${entry.value}',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      );
    }).toList();
  }

  double? _parseDouble(String? value) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value);
  }
}