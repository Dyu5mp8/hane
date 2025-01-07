import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/antibiotics/models/antibiotic.dart';

class AntibioticDetailView extends StatelessWidget {
  final Antibiotic antibiotic;

  const AntibioticDetailView({
    Key? key,
    required this.antibiotic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If some fields can be null, we provide a fallback
    final String name = antibiotic.name ?? 'Unknown Antibiotic';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Basic info
            Text(
              name,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),

            // Description
            if (antibiotic.description != null)
              Text(
                antibiotic.description!,
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
        ExpansionTile(
          title: const Text('Dosage'),
          children: [
            ListTile(
              title: Text(
                antibiotic.dosage?.isNotEmpty == true
                    ? antibiotic.dosage!
                    : 'No dosage information available',
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Farmakokinetik'),
          children: [
            ListTile(
              title: Text(
                antibiotic.pharmacokinetics?.isNotEmpty == true
                    ? antibiotic.pharmacokinetics!
                    : 'No farmakokinetik information available',
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Side Effects'),
          children: [
            ListTile(
              title: Text(
                antibiotic.sideEffects?.isNotEmpty == true
                    ? antibiotic.sideEffects!
                    : 'No side effects listed',
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Pharmacodynamics'),
          children: [
            ListTile(
              title: Text(
                antibiotic.pharmacodynamics?.isNotEmpty == true
                    ? antibiotic.pharmacodynamics!
                    : 'No pharmacodynamics information available',
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Pharmacokinetics'),
          children: [
            ListTile(
              title: Text(
                antibiotic.pharmacokinetics?.isNotEmpty == true
                    ? antibiotic.pharmacokinetics!
                    : 'No pharmacokinetics information available',
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Activity'),
          children: [
            ListTile(
              title: Text(
                antibiotic.activity?.isNotEmpty == true
                    ? antibiotic.activity!
                    : 'No activity information available',
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Interactions'),
          children: [
            ListTile(
              title: Text(
                antibiotic.interactions?.isNotEmpty == true
                    ? antibiotic.interactions!
                    : 'No interactions information available',
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Assessment'),
          children: [
            ListTile(
              title: Text(
                antibiotic.assessment?.isNotEmpty == true
                    ? antibiotic.assessment!
                    : 'No assessment information available',
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Resistance'),
          children: [
            ListTile(
              title: Text(
                antibiotic.resistance?.isNotEmpty == true
                    ? antibiotic.resistance!
                    : 'No resistance information available',
              ),
            ),
          ],
        ),
      ],
    );
  }
}