import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class indicationBox extends StatelessWidget {
  indicationBox({
    super.key,
  });

var dosages = ["vid livshotande allergi: ge 0.3mg iv.", "vid anafylaxi: ge 0.3mg im.", "vid livshotande astmaanfall: ge 0.3mg im."];

  @override
Widget build(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.5,
    width: MediaQuery.of(context).size.width,

    color: Colors.red,
    padding: EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
  
    
      children: [
        Text("Indikation: Anafylaxi", style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(
          height: 40,
        ),
        
        Expanded(
          child: SafeArea(
            child: ListView.builder(
              itemCount: dosages.length,
              itemBuilder: (context, index)
                       
            {
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(dosages[index] as String),
                Divider(),
                ]);
            
            }),
          ),
        )
        

        
      ],
    ),
  );
}
}