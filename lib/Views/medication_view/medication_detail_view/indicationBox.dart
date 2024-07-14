import 'package:flutter/material.dart';
import 'package:hane/Views/medication_view/medication_detail_view/dosageViewHandler.dart';
import 'package:hane/models/medication/bolus_dosage.dart';
import 'package:hane/models/medication/indication.dart';
import 'package:hane/models/medication/medication.dart';
import 'package:provider/provider.dart';
import  'package:hane/Views/medication_view/medication_detail_view/dosageViewHandler.dart';

class IndicationBox extends StatelessWidget {
  const IndicationBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Medication>(
      builder: (context, medication, child) {
        print(medication.indications);
        if (medication.indications == null || medication.indications!.isEmpty) {
          return const Text('No indications available');
        }
        return _IndicationView(indications: medication.indications!);
      },
    );
  }
}

class _IndicationView extends StatelessWidget {
  final List<Indication> indications;

  const _IndicationView({required this.indications});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: indications.length,
        child: Column(
          children: [
            _IndicationTabs(indications: indications),
            _IndicationTabView(indications: indications),
            AddIndicationButton(),
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

  const _IndicationTabView({required this.indications});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        children: indications.map((indication) => _IndicationDetails(indication: indication)).toList(),
      ),
    );
  }
}

class _IndicationDetails extends StatelessWidget {
  final Indication indication;
  final DosageViewHandler dosageViewHandler = DosageViewHandler();

  _IndicationDetails({required this.indication});

  



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(indication.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 40),
        Expanded(
          child: ListView.builder(
            itemCount: indication.dosages?.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dosageViewHandler.showDosage(indication.dosages![index])),
                  const SizedBox(height: 20),
               
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class AddIndicationButton extends StatelessWidget {
  const AddIndicationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final medication = Provider.of<Medication>(context, listen: false);
        medication.addIndication(Indication(name: 'New indication', isPediatric: false));
      },
      child: const Text('Add indication'),
    );
  }
}