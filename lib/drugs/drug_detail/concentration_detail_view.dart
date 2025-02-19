import 'package:flutter/material.dart';
import 'package:hane/drugs/models/concentration.dart';

class ConcentrationDetailView extends StatelessWidget {
  final List<Concentration> concentrations;

  const ConcentrationDetailView(this.concentrations, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spädningar')),
      body: ListView(
        children:
            concentrations
                .where(
                  (concentration) =>
                      concentration.mixingInstructions?.isNotEmpty ?? false,
                )
                .map(
                  (concentration) => ExpansionTile(
                    initiallyExpanded: true,
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "$concentration ${(concentration.isStockSolution ?? false) ? " (Stamlösning)" : ""}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    subtitle:
                        concentration.getSecondaryRepresentation() != null
                            ? Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "(${concentration.getSecondaryRepresentation()!})",
                                style: const TextStyle(fontSize: 16),
                              ),
                            )
                            : null,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${concentration.mixingInstructions}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }
}
