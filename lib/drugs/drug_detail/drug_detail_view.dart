import 'package:hane/drugs/models/drug.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/indication_box.dart';
import 'package:hane/drugs/drug_detail/overview_box.dart';
import 'package:provider/provider.dart';

class DrugDetailView extends StatelessWidget {
  final Drug drug;

  const DrugDetailView({super.key, required this.drug});

  



  @override
  Widget build(BuildContext context) {

     return ChangeNotifierProvider<Drug>.value(
      value: drug,
      child: Scaffold(
        appBar: AppBar(
          title: Text(drug.name ?? 'Drug Details'),
        ),
        body: const Column(
          children: <Widget>[
            OverviewBox(),
            

            IndicationBox()
          ],
        ),
      ),
    );
  }
}