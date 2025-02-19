import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/antibiotics/models/antibiotic.dart';

class AntibioticDetailView extends StatefulWidget {
  final Antibiotic antibiotic;

  const AntibioticDetailView({super.key, required this.antibiotic});

  @override
  _AntibioticDetailViewState createState() => _AntibioticDetailViewState();
}

class _AntibioticDetailViewState extends State<AntibioticDetailView> {
  @override
  Widget build(BuildContext context) {
    // If some fields can be null, we provide a fallback
    final String name = widget.antibiotic.name ?? 'Unknown Antibiotic';

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Description
            if (widget.antibiotic.description != null)
              Text(
                widget.antibiotic.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),

            const SizedBox(height: 16),

            // Expandable sections
            _buildExpandableSections(),
          ],
        ),
      ),
    );
  }

  /// Build out the expansion tiles.
  /// You can add or remove sections based on what your Antibiotic model includes.
  Widget _buildExpandableSections() {
    return Column(
      children: [
        DetailExpansionTile(
          title: 'Dosering',
          content: widget.antibiotic.dosage,
        ),
        DetailExpansionTile(
          title: 'Farmakokinetik',
          content: widget.antibiotic.pharmacokinetics,
        ),
        DetailExpansionTile(
          title: 'Biverkningar',
          content: widget.antibiotic.sideEffects,
        ),
        DetailExpansionTile(
          title: 'Farmakodynamik',
          content: widget.antibiotic.pharmacodynamics,
        ),
        DetailExpansionTile(
          title: 'Brytpunkter och mikrobiologisk aktivitet',
          content: widget.antibiotic.activity,
        ),
        DetailExpansionTile(
          title: 'Interaktioner',
          content: widget.antibiotic.interactions,
        ),
        DetailExpansionTile(
          title: 'RAF:s bedömning',
          content: widget.antibiotic.assessment,
        ),
        DetailExpansionTile(
          title: 'Resistensutveckling',
          content: widget.antibiotic.resistance,
        ),
      ],
    );
  }
}

class DetailExpansionTile extends StatelessWidget {
  final String title;
  final String? content;

  const DetailExpansionTile({super.key, required this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),

      leading: const Icon(Icons.info_outline),
      children: [
        ListTile(
          title: Text(
            content?.isNotEmpty == true
                ? content!
                : 'Ingen information tillgänglig',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
