import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/field_config.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/rotem_evaluation_strategy.dart';
import 'package:hane/modules_feature/modules/rotem/models/strategies/rotem_action.dart';
// Ensure RotemField enum and other required imports are present.

class MiniSummaryCard extends StatelessWidget {
  final RotemEvaluationStrategy? strategy;
  final Map<RotemField, String> inputValues;

  const MiniSummaryCard({
    Key? key,
    required this.strategy,
    required this.inputValues,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (strategy == null) {
      return const Text('Ingen strategi vald.');
    }
    
    // Obtain the set of required fields for the current strategy
    final requiredFields = strategy!.getRequiredFields().map((fc) => fc.field).toSet();

    // Define groups of fields for each quadrant
    final fibtemFields = [RotemField.ctFibtem, RotemField.a5Fibtem, RotemField.a10Fibtem];
    final extemFields = [RotemField.ctExtem, RotemField.a5Extem, RotemField.a10Extem, RotemField.mlExtem, RotemField.li30Extem];
    final intemFields = [RotemField.ctIntem];
    final heptemFields = [RotemField.ctHeptem];

    // Helper to get field label based on RotemField enum
    String _fieldLabel(RotemField field) {
      switch(field) {
        case RotemField.ctFibtem: return 'CT';
        case RotemField.a5Fibtem: return 'A5';
        case RotemField.a10Fibtem: return 'A10';
        case RotemField.ctExtem: return 'CT';
        case RotemField.a5Extem: return 'A5';
        case RotemField.a10Extem: return 'A10';
        case RotemField.mlExtem: return 'ML';
        case RotemField.li30Extem: return 'LI30';
        case RotemField.ctIntem: return 'CT';
        case RotemField.ctHeptem: return 'CT';
        // Add additional cases as needed
        default: return field.toString();
      }
    }

    // Filter and generate lines only for required fields in a given list
    List<String> generateLines(List<RotemField> fields) {
      return fields
          .where((f) => requiredFields.contains(f))
          .map((f) => '${_fieldLabel(f)}: ${inputValues[f] ?? ''}')
          .toList();
    }

    final fibtemLines = generateLines(fibtemFields);
    final extemLines = generateLines(extemFields);
    final intemLines = generateLines(intemFields);
    final heptemLines = generateLines(heptemFields);

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
        for (final line in lines) 
          Text(line, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}