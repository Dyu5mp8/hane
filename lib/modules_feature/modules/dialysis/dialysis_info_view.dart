import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/dialysis/dialysis_consitutents_list.dart';

class DialysisInfoView extends StatelessWidget {
  const DialysisInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a Scaffold for consistent theming and layout
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mer information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show a dialog with more information
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Om denna modul'),
                    content: const Text(
                      'Denna modul bygger på hjälpmedlet "Dialysordinationsblad IVA Huddinge (20220625) utformat av Jonatan Grip. Ordination av kontinuerlig dialys kräver kunskap och erfarenhet. Denna modul är endast ett räknehjälpmedel. Varken upphovsmännen eller appskaparen ansvarar för eventuella fel eller skador som kan uppstå vid användning av detta hjälpmedel.', 
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Stäng'),
                      ),
                    ],
                  );
                },
              );
           
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Text(
              'Optimal dialysdos på indikation AKI anses vara 20 - 25 ml/kg/h. Hos instabila patienter finns ofta skäl att ha högre dos, särskilt som hänsyn måste tas till down-time pga undersökningar mm. Vid leversvikt används ofta betydligt högre dialysdoser.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20),
            const Text(
              "Tips för justeringar:\n\n"
              "• Ökning av blodflöde/predilutionsflöde/citratmål leder till ökning av dialysdos och tillförsel av bas -> mer alkalos.\n"
              "• Ökning av dialysatflöde leder till ökad dialysdos och ökad acidos (mer citrat dialyseras bort).\n"
              "• Ökning av postdilutionsflöde ökar dialysdosen utan att påverka syra-bas.",
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20),
            const Text(
              "Kalciumkvot = Fritt kalcium (mmol/l) / Joniserat kalcium (mmol/l)",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Kvot >2.5 tyder på citratackumulation. Om behov av kalciumersättning avtar mycket eller helt tyder det på urkalkning. I bägge dessa fall är det lämpligt att byta från citratdialys (se PM).',
              style: TextStyle(fontSize: 16.0),
            ),
            
            const SizedBox(height: 20),
          
            const DialysisConsitutentsList(),
          ],
        ),
      ),
    );
  }
}