import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/data/source_firestore_handler.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source_type.dart';

class AdminNutritionEditview extends StatefulWidget {
  final Source? source;

  const AdminNutritionEditview({super.key, this.source});

  @override
  State<AdminNutritionEditview> createState() => _AdminNutritionEditviewState();
}

class _AdminNutritionEditviewState extends State<AdminNutritionEditview> with SourceFirestoreHandler {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();

  // Controllers for intermittent nutrition
  final TextEditingController _mlPerUnitController = TextEditingController();
  final TextEditingController _kcalPerUnitController = TextEditingController();
  final TextEditingController _proteinPerUnitController = TextEditingController();
  final TextEditingController _lipidPerUnitController = TextEditingController();

  // Controllers for continuous nutrition
  final TextEditingController _kcalPerMlController = TextEditingController();
  final TextEditingController _proteinPerMlController = TextEditingController();
  final TextEditingController _lipidPerMlController = TextEditingController();
  final TextEditingController _rateRangeMinController = TextEditingController();
  final TextEditingController _rateRangeMaxController = TextEditingController();


  // Existing state variables
  String? _selectedFlow; // "intermittent" or "continuous"
  SourceType? _selectedSourceType;

  @override
  void initState() {
    super.initState();
    if (widget.source != null) {
      _selectedFlow = widget.source is IntermittentSource ? 'intermittent' : 'continuous';
      _selectedSourceType = widget.source!.type;
      
      // Initialize the name field
      _nameController.text = widget.source!.name;

      if (widget.source is IntermittentSource) {
        final source = widget.source as IntermittentSource;
        _mlPerUnitController.text = source.mlPerUnit.toString();
        _kcalPerUnitController.text = source.kcalPerUnit.toString();
        _proteinPerUnitController.text = source.proteinPerUnit.toString();
        _lipidPerUnitController.text = source.lipidsPerUnit.toString();
      } else if (widget.source is ContinousSource) {
        final source = widget.source as ContinousSource;
        _kcalPerMlController.text = source.kcalPerMl.toString();
        _proteinPerMlController.text = source.proteinPerMl.toString();
        _lipidPerMlController.text = source.lipidsPerMl.toString();
        _rateRangeMinController.text = source.rateRangeMin?.toString() ?? '';
        _rateRangeMaxController.text = source.rateRangeMax?.toString() ?? '';
      }
    }
  }

  @override
  void dispose() {
    // Dispose all controllers to free up resources
    _nameController.dispose();
    _mlPerUnitController.dispose();
    _kcalPerUnitController.dispose();
    _proteinPerUnitController.dispose();
    _lipidPerUnitController.dispose();
    _kcalPerMlController.dispose();
    _proteinPerMlController.dispose();
    _lipidPerMlController.dispose();
    _rateRangeMinController.dispose();
    _rateRangeMaxController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _selectedFlow != null &&
        _selectedSourceType != null) {

    String? id = widget.source?.id;

      Source source;
      if (_selectedFlow == "intermittent") {
        source = IntermittentSource(
          id: id,
          name: _nameController.text.trim(),
          type: _selectedSourceType!,
          mlPerUnit: double.parse(_mlPerUnitController.text.trim()),
          kcalPerUnit: double.parse(_kcalPerUnitController.text.trim()),
          proteinPerUnit: double.parse(_proteinPerUnitController.text.trim()),
          lipidsPerUnit: double.parse(_lipidPerUnitController.text.trim()),
        );
      } else if (_selectedFlow == "continuous") {
        source = ContinousSource(
          id: id,
          name: _nameController.text.trim(),
          type: _selectedSourceType!,
          kcalPerMl: double.parse(_kcalPerMlController.text.trim()),
          proteinPerMl: double.parse(_proteinPerMlController.text.trim()),
          lipidsPerMl: double.parse(_lipidPerMlController.text.trim()),
          rateRangeMin: _rateRangeMinController.text.trim().isNotEmpty ? double.parse(_rateRangeMinController.text.trim()) : 0,
          rateRangeMax: _rateRangeMaxController.text.trim().isNotEmpty ? double.parse(_rateRangeMaxController.text.trim()) : 100,
        );
      } else {
        return;
      }

      try {
        await addDocument(collectionPath: 'nutritions', source: source);
        _resetForm();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nutrition sparad framgångsrikt!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fel när datan skulle sparas: $e')),
          );
        }
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _selectedFlow = null;
      _selectedSourceType = null;

      // Clear all controllers
      _nameController.clear();
      _mlPerUnitController.clear();
      _kcalPerUnitController.clear();
      _proteinPerUnitController.clear();
      _lipidPerUnitController.clear();
      _kcalPerMlController.clear();
      _proteinPerMlController.clear();
      _lipidPerMlController.clear();
      _rateRangeMinController.clear();
      _rateRangeMaxController.clear();
      
    });
  }

  Widget _buildIntermittentFields() {
    return Column(
      children: [
        _buildNumberField(
          controller: _mlPerUnitController,
          label: 'Gram mL per enhet',
        ),
        const SizedBox(height: 12),
        _buildNumberField(
          controller: _kcalPerUnitController,
          label: 'Gram kcal per enhet',
        ),
        const SizedBox(height: 12),
        _buildNumberField(
          controller: _proteinPerUnitController,
          label: 'Gram protein per enhet',
        ),
        const SizedBox(height: 12),
        _buildNumberField(
          controller: _lipidPerUnitController,
          label: 'Gram lipider per enhet',
        ),
      ] 
    );
  }

  Widget _buildContinuousFields() {
    return Column(
      children: [
        _buildNumberField(
          controller: _kcalPerMlController,
          label: 'Kcal per mL',
        ),
        const SizedBox(height: 12),
        _buildNumberField(
          controller: _proteinPerMlController,
          label: 'Gram protein per mL',
        ),
        const SizedBox(height: 12),
        _buildNumberField(
          controller: _lipidPerMlController,
          label: 'Gram lipider per mL',
        ),
        const SizedBox(height: 12),
        Row(children: [

          Expanded(child: _buildNumberField(label: "Reglage minimum", controller: _rateRangeMinController)),
          const SizedBox(width: 4),
          Expanded(child: _buildNumberField(label: "Reglage maximum", controller: _rateRangeMaxController)),
        ],)
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Ange $label';
        if (double.tryParse(value) == null) return 'Ange ett giltigt tal';
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.source != null ? 'Redigera Nutrition' : 'Lägg till Nutrition'),
        actions:   [
          IconButton(
            icon: (widget.source == null) ? const Icon(Icons.clear): const Icon(Icons.delete),
            onPressed: () {
              if (widget.source == null) {
                _resetForm();
                return;
              }
              else{
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Bekräfta'),
                    content: const Text('Ta bort nutritionskälla?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Avbryt'),
                      ),
                      TextButton(
                        onPressed: () {
                          try {
                          deleteDocument(collectionPath: "nutritions", source: widget.source!);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Nutritionskälla borttagen')),
                          );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Fel när datan skulle tas bort: $e')),
                            );
                          }
                        },
                        child: const Text('Ta bort'),
                      ),
                    ],
                  );
                },
              );
              }
            },
          

          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Text(
              widget.source != null ? 'Redigera nutrition' : 'Lägg till ny nutrition',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context).colorScheme.surface,
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                  width: 0.4,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SegmentedButton<String>(
                        segments: const <ButtonSegment<String>>[
                          ButtonSegment<String>(
                            value: 'intermittent',
                            label: Text('Intermittent'),
                          ),
                          ButtonSegment<String>(
                            value: 'continuous',
                            label: Text('Kontinuerlig'),
                          ),
                        ],
                        selected: _selectedFlow != null ? {_selectedFlow!} : <String>{},
                        emptySelectionAllowed: true,
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _selectedFlow = newSelection.isNotEmpty ? newSelection.first : null;
                            _resetControllersBasedOnFlow();
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<SourceType>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Typ av källa',
                        ),
                        value: _selectedSourceType,
                        items: SourceType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.displayName),
                          );
                        }).toList(),
                        validator: (val) => val == null ? 'Välj en källtyp' : null,
                        onChanged: (val) => setState(() {
                          _selectedSourceType = val;
                        }),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Namn',
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Ange ett namn' : null,
                      ),
                      const SizedBox(height: 12),
                      if (_selectedFlow == "intermittent") _buildIntermittentFields(),
                      if (_selectedFlow == "continuous") _buildContinuousFields(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text('Spara'),
                            onPressed: _submitForm,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Optional: Reset controllers based on the selected flow to avoid retaining
  /// data when switching between intermittent and continuous.
  void _resetControllersBasedOnFlow() {
    if (_selectedFlow == "intermittent") {
      // Clear continuous fields
      _kcalPerMlController.clear();
      _proteinPerMlController.clear();
      _lipidPerMlController.clear();
    } else if (_selectedFlow == "continuous") {
      // Clear intermittent fields
      _mlPerUnitController.clear();
      _kcalPerUnitController.clear();
      _proteinPerUnitController.clear();
      _lipidPerUnitController.clear();
    }
  }
}