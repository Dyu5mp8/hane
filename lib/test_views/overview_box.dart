import 'package:flutter/material.dart';
class overviewBox extends StatelessWidget {
  const overviewBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      color: Colors.red,
      child: Column(
        children: [ 
        basicInfoRow(),
        noteRow(),
          contraindicationRow()



        ]
    )
    );
  }
}


class basicInfoRow extends StatelessWidget {
  const basicInfoRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      color: Colors.red,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text("Adrenalin", style: Theme.of(context).textTheme.headlineLarge),
              Text("cirkulation", style: Theme.of(context).textTheme.bodyMedium)
            
            ],),
          ),
          Column(

            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            Text("1mg/ml"),
            Text("0.1mg/ml")
          
          ],),
        ],
      )
    );
  }
}


class contraindicationRow extends StatelessWidget {
  const contraindicationRow({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      color: Colors.red,
      padding: EdgeInsets.all(10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
        Text("Kontraindikationer", style: TextStyle(fontSize: 16),),
        Text("ischemi takykardi bla bla", style: TextStyle(fontSize: 12),)

      ],)
    );
  }
}


class noteRow extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      color: Colors.red,
      padding: EdgeInsets.all(10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
        Text('Anteckningar', style: TextStyle(fontSize: 16),),
        Text('bla bla bla bla bla bla bla bla', style: TextStyle(fontSize: 12),)

      ],)
    );
  }
}