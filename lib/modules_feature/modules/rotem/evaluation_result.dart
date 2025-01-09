import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_action.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/ui_components/dosage_snippet.dart';

class EvaluationResult extends StatelessWidget {
  final RotemEvaluator evaluator;

  const EvaluationResult({Key? key, required this.evaluator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, List<RotemAction>> actions = evaluator.evaluate();

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(thickness: 1),
          const SizedBox(height: 8),
          Text(
            'Vald klinisk kontext: ${evaluator.strategy.name}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text('Överväg dessa åtgärder i kombination med klinisk bedömning:'),
          const SizedBox(height: 6),
          if (actions.isEmpty)
            const Text('Inga föreslagna åtgärder')
          else
            for (final entry in actions.entries) ...[
              for (int i = 0; i < entry.value.length; i++) ...[
                DosageSnippet(
                  dosage: entry.value[i].dosage,
                  onDosageUpdated: (_) {},
                  availableConcentrations: entry.value[i].availableConcentrations,
                ),
                if (i < entry.value.length - 1) const Text("Eller"),
              ],
            ],
        ],
      ),
    );
  }
}