import 'package:flutter/material.dart';
import 'package:hane/models/medication/indication.dart';
import 'package:hane/models/medication/medication.dart';
import 'package:provider/provider.dart';

class IndicationBox extends StatelessWidget {
  const IndicationBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Medication>(
      builder: (context, medication, child) {
        if (medication.adultIndications == null || medication.adultIndications!.isEmpty) {
          return const Text('No indications available');
        }
        return _IndicationView(adultIndications: medication.adultIndications!);
      },
    );
  }
}

class _IndicationView extends StatelessWidget {
  final List<Indication> adultIndications;

  const _IndicationView({required this.adultIndications});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: adultIndications.length,
        child: Column(
          children: [
            _IndicationTabs(adultIndications: adultIndications),
            _IndicationTabView(adultIndications: adultIndications),
            AddIndicationButton(),
          ],
        ),
      ),
    );
  }
}

class _IndicationTabs extends StatelessWidget {
  final List<Indication> adultIndications;

  const _IndicationTabs({required this.adultIndications});

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
        tabs: adultIndications.map((indication) => Tab(text: indication.name)).toList(),
      ),
    );
  }
}

class _IndicationTabView extends StatelessWidget {
  final List<Indication> adultIndications;

  const _IndicationTabView({required this.adultIndications});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        children: adultIndications.map((indication) => _IndicationDetails(indication: indication)).toList(),
      ),
    );
  }
}

class _IndicationDetails extends StatelessWidget {
  final Indication indication;

  const _IndicationDetails({required this.indication});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(indication.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 40),
        Expanded(
          child: ListView.builder(
            itemCount: indication.bolusDosages.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(indication.bolusDosages[index].instruction),
                  const Divider(),
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
        medication.addIndication(Indication(name: 'New indication'));
      },
      child: const Text('Add indication'),
    );
  }
}