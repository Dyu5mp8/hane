import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/antibiotics/models/antibiotic.dart';

class AntibioticDetailView extends StatefulWidget {
  final Antibiotic antibiotic;

  const AntibioticDetailView({
    Key? key,
    required this.antibiotic,
  }) : super(key: key);

  @override
  _AntibioticDetailViewState createState() => _AntibioticDetailViewState();
}

class _AntibioticDetailViewState extends State<AntibioticDetailView> {
  bool _isExpanded = false;

  void _toggleExpandCollapse() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If some fields can be null, we provide a fallback
    final String name = widget.antibiotic.name ?? 'Unknown Antibiotic';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            onPressed: _toggleExpandCollapse,
          ),
        ],
      ),
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
          isExpanded: _isExpanded,
        ),
        DetailExpansionTile(
          title: 'Farmakokinetik',
          content: widget.antibiotic.pharmacokinetics,
          isExpanded: _isExpanded,
        ),
        DetailExpansionTile(
          title: 'Biverkningar',
          content: widget.antibiotic.sideEffects,
          isExpanded: _isExpanded,
        ),
        DetailExpansionTile(
          title: 'Farmakodynamik',
          content: widget.antibiotic.pharmacodynamics,
          isExpanded: _isExpanded,
        ),
        DetailExpansionTile(
          title: 'Brytpunkter och mikrobiologisk aktivitet',
          content: widget.antibiotic.activity,
          isExpanded: _isExpanded,
        ),
        DetailExpansionTile(
          title: 'Interaktioner',
          content: widget.antibiotic.interactions,
          isExpanded: _isExpanded,
        ),
        DetailExpansionTile(
          title: 'RAF:s bedömning',
          content: widget.antibiotic.assessment,
          isExpanded: _isExpanded,
        ),
        DetailExpansionTile(
          title: 'Resistensutveckling',
          content: widget.antibiotic.resistance,
          isExpanded: _isExpanded,
        ),
      ],
    );
  }
}

class DetailExpansionTile extends StatelessWidget {
  final String title;
  final String? content;
  final bool isExpanded;

  const DetailExpansionTile({
    Key? key,
    required this.title,
    this.content,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      initiallyExpanded: isExpanded,
      leading: Icon(Icons.info_outline),
      children: [
        ListTile(
          title: Text(
            content?.isNotEmpty == true ? content! : 'Ingen information tillgänglig',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}