import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hane/models/medication/indication.dart';
import 'package:hane/models/medication/medication.dart';
import 'package:provider/provider.dart';

class IndicationBox extends StatelessWidget {
  IndicationBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Medication>(
      builder: (context, medication, child) {
        var adultIndications = medication.adultIndications!;
        
        return Expanded(
          child: DefaultTabController(
                  length: adultIndications.length,
                  child: Column(
            children: [
              Container(
              height: 30,
              child: TabBar(
                  unselectedLabelStyle:
                      TextStyle(color: Color.fromARGB(255, 157, 157, 157)),
                  labelColor: Colors.black,
                  tabAlignment: TabAlignment.start,
                  indicatorSize: TabBarIndicatorSize.tab,
                  isScrollable: true,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.lightBlue,
                      border: Border.all(color: Colors.black, width: 0.4)),
                  tabs: [
          
                    ...adultIndications.map((indication) => Tab(
                      text: indication.name,
                    )).toList()
                  ])),
                
          
                    Expanded(
                      child: TabBarView(
                            children: [...adultIndications.map((indication) =>
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(indication.name,
                                    style: Theme.of(context).textTheme.headlineSmall),
                                SizedBox(
                                  height: 40,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: indication.bolusDosages.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(indication.bolusDosages[index].instruction),
                                              Divider(),
                                            ]);
                                      }),
                                )
                              ],
                            ),
                          ),
                            ]
                        ),
                    )
            ]
                    )
                    
          ),
        );
                });
           }
}