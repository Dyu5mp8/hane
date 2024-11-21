import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/indication_tab_view.dart';
import 'package:hane/drugs/drug_detail/indication_tabs.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';

class IndicationBox extends StatelessWidget {
  const IndicationBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Drug>(
      builder: (context, drug, child) {
        return Expanded(
          child: DefaultTabController(
            length: drug.indications!.length,
            child: const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: [
                  IndicationTabs(),
                  Expanded(child: IndicationTabView()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
