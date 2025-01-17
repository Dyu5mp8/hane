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
            // Representing the equation using RichText
            Text("Kalciumkvot = Fritt kalcium (mmol/l) / Joniserat kalcium (mmol/l)",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
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