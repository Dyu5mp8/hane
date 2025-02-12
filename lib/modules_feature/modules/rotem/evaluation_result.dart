import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/dosage_view_handler.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_action.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';
import 'package:hane/ui_components/dosage_snippet.dart';


class EvaluationResult extends StatelessWidget {
final Map<String, List<RotemAction>> actions;
final String strategyName;

  const EvaluationResult({
    Key? key,
    this.strategyName = 'Fel: klinisk kontext okänd',
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            Text(
              'Vald klinisk kontext: ${strategyName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('Överväg dessa åtgärder i kombination med klinisk bedömning:'),
            const SizedBox(height: 6),
      
            // If there are no actions, show a placeholder text
            if (actions.isEmpty)
              const Text('Inga föreslagna åtgärder utifrån givna resultat.')
            else
              // Otherwise, display each key-value pair in its own Container
              for (final entry in actions.entries) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
               
                
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // The entry key as a descriptor
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // List all associated dosages, with "ELLER" in between
                      for (int i = 0; i < entry.value.length; i++) ...[
                        ChangeNotifierProvider(
                          create: (_) => DosageViewHandler(
                            dosage: entry.value[i].dosage,
                            availableConcentrations: entry.value[i].availableConcentrations,
                            onDosageDeleted: () {},
                            onDosageUpdated: (updatedDosage) {
                            },
                                                  
                          ),
                          child: DosageSnippet(
                           
                          ),
                        ),
                        if (i < entry.value.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: const [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    'ELLER',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }
}