import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/dosageViewHandler.dart';
import 'package:hane/drugs/drug_edit/drug_detail_form.dart';
import 'package:hane/drugs/drug_edit/drug_edit_detail.dart';
import 'package:hane/drugs/drug_detail/ui_components/dosage_snippet.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:provider/provider.dart';


class IndicationBox extends StatelessWidget {
  const IndicationBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Drug>(
      builder: (context, drug, child) {

        if (drug.indications == null || drug.indications!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
             
              children: [
                SizedBox(height:20),
                Icon(Icons.lightbulb_circle, color: Colors.grey, size: 50),
                Text("Inga indikationer ännu! Lägg till indikation eller gör andra ändringar..."),
                SizedBox(height:20),
                AddIndicationButton(),
              ],
            ),
          );

        }
   
        return _IndicationView(indications: drug.indications!, concentrations: drug.concentrations);
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
              _IndicationTabs(indications: indications),
              _IndicationTabView(indications: indications, concentrations: concentrations),
              const AddIndicationButton(),
            ],
          ),
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
      decoration: const BoxDecoration(
        color: Colors.white, // Set a solid, non-transparent background color

 
      ),
      child: TabBar(
        unselectedLabelStyle: const TextStyle(color: Color.fromARGB(255, 157, 157, 157)),
        labelColor: Colors.black,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(70),
          color: Colors.lightBlue,
          border: Border.all(color: Colors.black, width: 0.5),
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

  const _IndicationDetails({
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
          if (indication.notes != null) Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(indication.notes!, style: const TextStyle(fontSize: 14)),
          ),
          
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
    var drug = Provider.of<Drug>(context, listen: false);

    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DrugEditDetail(drugForm: DrugForm(drug: drug))));
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Redigera läkemedel'),
          SizedBox(width: 10),
          Icon(Icons.edit),
        ],
      ),
    );
  }
}

