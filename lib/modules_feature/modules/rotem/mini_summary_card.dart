import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/rotem/models/field_config.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluation_strategy.dart';

class MiniSummaryCard extends StatelessWidget {
  final RotemEvaluationStrategy? strategy;
  final Map<RotemField, String> inputValues;

  const MiniSummaryCard({
    super.key,
    required this.strategy,
    required this.inputValues,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
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
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (strategy == null) {
      return const Text('Ingen strategi vald.');
    }

    // Group required fields from the strategy by section.
    final fieldsBySection = <RotemSection, List<FieldConfig>>{};
    for (var config in strategy!.getRequiredFields()) {
      fieldsBySection.putIfAbsent(config.section, () => []).add(config);
    }

    // Helper to get a short label for each RotemField.
    String fieldLabel(RotemField field) {
      switch (field) {
        case RotemField.ctFibtem:
          return 'CT';
        case RotemField.a5Fibtem:
          return 'A5';
        case RotemField.a10Fibtem:
          return 'A10';
        case RotemField.ctExtem:
          return 'CT';
        case RotemField.a5Extem:
          return 'A5';
        case RotemField.a10Extem:
          return 'A10';
        case RotemField.mlExtem:
          return 'ML';
        case RotemField.li30Extem:
          return 'LI30';
        case RotemField.ctIntem:
          return 'CT';
        case RotemField.ctHeptem:
          return 'CT';
        default:
          return field.toString();
      }
    }

    // Generate styled text widgets for each section.
    Map<RotemSection, List<Widget>> linesBySection = {};
    fieldsBySection.forEach((section, configs) {
      final lines = configs.map((config) {
        final valueStr = inputValues[config.field] ?? '';
        final valueDouble = double.tryParse(valueStr);
        final result = (valueDouble != null) ? config.result(valueDouble) : null;
return Text(
  '${fieldLabel(config.field)}: $valueStr',
  style: TextStyle(
    fontSize: 10,
    color: (result != null && result != Result.normal)
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).textTheme.bodyMedium?.color,
  ),
);
      
      }).toList();

      if (lines.isNotEmpty) {
        linesBySection[section] = lines;
      }
    });

    // Build UI quadrants dynamically based on available sections.
    List<Widget> quadrantRows = [];
    final sectionOrder = [
      RotemSection.fibtem,
      RotemSection.extem,
      RotemSection.intem,
      RotemSection.heptem,
    ];

    for (int i = 0; i < sectionOrder.length; i += 2) {
      final firstSection = sectionOrder[i];
      final secondSection = (i + 1 < sectionOrder.length) ? sectionOrder[i + 1] : null;

      final firstLines = linesBySection[firstSection] ?? [];
      final secondLines = (secondSection != null) ? linesBySection[secondSection] ?? [] : [];

      if (firstLines.isEmpty && (secondLines.isEmpty || secondSection == null)) continue;

      quadrantRows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (firstLines.isNotEmpty)
              Expanded(child: _buildQuadrantCell(firstSection.name.toUpperCase(), firstLines)),
            if (firstLines.isNotEmpty && secondLines.isNotEmpty)
              const SizedBox(width: 8),
            if (secondSection != null && secondLines.isNotEmpty)
              Expanded(child: _buildQuadrantCell(secondSection.name.toUpperCase(), secondLines as List<Widget>)),
          ],
        ),
      );
      quadrantRows.add(const SizedBox(height: 8)); // spacing between rows
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Inmatade värden',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        ...quadrantRows,
      ],
    );
  }

  Widget _buildQuadrantCell(String title, List<Widget> lines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
        ...lines,
      ],
    );
  }
}