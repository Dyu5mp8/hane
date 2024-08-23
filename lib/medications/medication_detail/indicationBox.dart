import 'package:flutter/material.dart';
import 'package:hane/medications/controllers/dosageViewHandler.dart';
import 'package:hane/medications/medication_edit/medication_detail_form.dart';
import 'package:hane/medications/medication_edit/medication_edit_detail.dart';
import 'package:hane/medications/ui_components/dosage_snippet.dart';
import 'package:hane/medications/models/indication.dart';
import 'package:hane/medications/models/medication.dart';
import 'package:provider/provider.dart';


class IndicationBox extends StatelessWidget {
  const IndicationBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Medication>(
      builder: (context, medication, child) {

        if (medication.indications == null || medication.indications!.isEmpty) {
          return const Column(
            children: [
              SizedBox(height:20),
              Icon(Icons.lightbulb_circle, color: Colors.grey, size: 50),
              Text("Inga indikationer ännu! Lägg till indikation eller gör andra ändringar..."),
              SizedBox(height:20),
              AddIndicationButton(),
            ],
          );

        }
   
        return _IndicationView(indications: medication.indications!, concentrations: medication.concentrations);
      },
    );
  }
}

class _IndicationView extends StatelessWidget {
  final List<Indication> indications;
  final List<Concentration>? concentrations;

  const _IndicationView({required this.indications, this.concentrations});

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: DefaultTabController(
        length: indications.length,
        child: Column(
          children: [
            _IndicationTabs(indications: indications),
            _IndicationTabView(indications: indications, concentrations: concentrations),
            const AddIndicationButton(),
          ],
        ),
      ),
    );
  }
}

class _IndicationTabs extends StatelessWidget {
  final List<Indication> indications;

  const _IndicationTabs({required this.indications});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 30,
      child: TabBar(
        unselectedLabelStyle: const TextStyle(color: Color.fromARGB(255, 157, 157, 157)),
        labelColor: Colors.black,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.lightBlue,
          border: Border.all(color: Colors.black, width: 0.4),
        ),
        tabs: indications.map((indication) => Tab(text: indication.name)).toList(),
      ),
    );
  }
}

class _IndicationTabView extends StatelessWidget {
  final List<Indication> indications;
  final List<Concentration>? concentrations;

  const _IndicationTabView({required this.indications, this.concentrations});

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: TabBarView(
        children: indications.map((indication) => _IndicationDetails(indication: indication, concentrations: concentrations,)).toList(),
      ),
    );
  }
}

class _IndicationDetails extends StatelessWidget {
  final Indication indication;
  final List<Concentration>? concentrations;

  _IndicationDetails({
    required this.indication,
    this.concentrations,
    });

  
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(indication.name, style: Theme.of(context).textTheme.headlineSmall),
          if (indication.notes != null) Text(indication.notes!),
          
          if (indication.dosages != null)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(1),
              itemCount: indication.dosages?.length,
              itemBuilder: (context, index) {
      
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (indication.dosages != null)
                    
                    DosageSnippet(dosage: indication.dosages![index], 
                    dosageViewHandler: (DosageViewHandler(
                        super.key,
                        dosage: indication.dosages![index],
                        availableConcentrations: concentrations,
                       
                    )
                      ),
                    ),
                   
                 
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddIndicationButton extends StatelessWidget {
  const AddIndicationButton({super.key});

  @override
  Widget build(BuildContext context) {
    var _medication = Provider.of<Medication>(context, listen: false);

    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MedicationEditDetail(medicationForm: MedicationForm(medication: _medication))));
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Redigera läkemedel'),
          SizedBox(width: 10),
          const Icon(Icons.edit),
        ],
      ),
    );
  }
}