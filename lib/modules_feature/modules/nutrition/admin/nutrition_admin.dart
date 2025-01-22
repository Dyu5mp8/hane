import 'package:cloud_firestore/cloud_firestore.dart' hide Source;
import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source.dart';
import 'package:hane/modules_feature/modules/nutrition/models/source_type.dart';

class NutritionAdmin extends StatefulWidget {
  @override
  State<NutritionAdmin> createState() => _NutritionAdminState();
}

class _NutritionAdminState extends State<NutritionAdmin> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _selectedFlow; // "intermittent" or "continuous"
  SourceType? _selectedSourceType;
  String _name = '';

  // Fields for intermittent nutrition
  double _mlPerUnit = 0.0;
  double _kcalPerUnit = 0.0;
  double _proteinPerUnit = 0.0;
  double _lipidPerUnit = 0.0;

  // Fields for continuous nutrition
  double _kcalPerMl = 0.0;
  double _proteinPerMl = 0.0;
  double _lipidPerMl = 0.0;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && 
        _selectedFlow != null && 
        _selectedSourceType != null) {
      _formKey.currentState!.save();

      Source source;
      if (_selectedFlow == "intermittent") {
        source = IntermittentSource(
          name: _name,
          type: _selectedSourceType!,
          mlPerUnit: _mlPerUnit,
          kcalPerUnit: _kcalPerUnit,
          proteinPerUnit: _proteinPerUnit,
          lipidsPerUnit: _lipidPerUnit,
        );
      } else if (_selectedFlow == "continuous") {
        source = ContinousSource(
          name: _name,
          type: _selectedSourceType!,
          kcalPerMl: _kcalPerMl,
          proteinPerMl: _proteinPerMl,
          lipidsPerMl: _lipidPerMl,
        );
      } else {
        return;
      }

      try {
        await _firestore.collection('nutritions').add(source.toJson());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nutrition sparad')),
          );
        }
        _resetForm();
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
      _name = '';
      _mlPerUnit = 0.0;
      _kcalPerUnit = 0.0;
      _proteinPerUnit = 0.0;
      _kcalPerMl = 0.0;
      _proteinPerMl = 0.0;
    });
  }

  Widget _buildIntermittentFields() {
    return Column(
      children: [
        _buildNumberField(
          label: 'Gram mL per enhet',
          onSaved: (value) => _mlPerUnit = double.parse(value!),
        ),
        const SizedBox(height: 12),
        _buildNumberField(
          label: 'Gram kcal per enhet',
          onSaved: (value) => _kcalPerUnit = double.parse(value!),
        ),
        const SizedBox(height: 12),
        _buildNumberField(
          label: 'Gram protein per enhet',
          onSaved: (value) => _proteinPerUnit = double.parse(value!),
        ),
        const SizedBox(height: 12),
        _buildNumberField(
          label: 'Gram lipider per enhet',
          onSaved: (value) => _lipidPerUnit = double.parse(value!),
        ),
      ],
    );
  }

  Widget _buildContinuousFields() {
    return Column(
      children: [
        _buildNumberField(
          label: 'Kcal per mL',
          onSaved: (value) => _kcalPerMl = double.parse(value!),
        ),
        const SizedBox(height: 12),
        _buildNumberField(
          label: 'Gram protein per mL',
          onSaved: (value) => _proteinPerMl = double.parse(value!),
        ),
        const SizedBox(height: 12),
        _buildNumberField(
          label: 'Gram lipider per mL',
          onSaved: (value) => _lipidPerMl = double.parse(value!),
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
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
      onSaved: onSaved,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Text(
              'Lägg till ny nutrition',
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
                            _formKey.currentState?.reset();
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Namn',
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Ange ett namn' : null,
                        onSaved: (val) => _name = val ?? '',
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
}