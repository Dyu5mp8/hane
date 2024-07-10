import 'package:hane/models/medication/medication.dart';
import 'package:flutter/material.dart';

class MedicationDetailView extends StatelessWidget {
  final Medication medication;

  MedicationDetailView({required this.medication});



  @override
  Widget build(BuildContext context) {
    final topContentText = Column(
      
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        
        Text(medication.name, style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 45.0)),
        Container(
          width: 80.0,
          child: new Divider(color: const Color.fromARGB(255, 175, 76, 76)),
        ),
        SizedBox(height: 2.0),
        Text(
          "Smärtstillande"
        ),
        SizedBox(height: 50.0),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 1, child: Text(medication.name)),
            Expanded(
                flex: 6,
                child: Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Text(
                      "Läkemedel",
                      style: TextStyle(color: Colors.white),
                    ))),
            Expanded(flex: 1, child: Text("test"))
          ],
        ),
      ],
    );
    final topContent = Stack(
      children: <Widget>[
        // Container(
        //     padding: EdgeInsets.only(left: 10.0),
        //     height: MediaQuery.of(context).size.height * 0.5,
        //     decoration: new BoxDecoration(
        //       image: new DecorationImage(
        //         image: new AssetImage("drive-steering-wheel.jpg"),
        //         fit: BoxFit.cover,
        //       ),
        //     )),
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: EdgeInsets.only(left: 40.0, top: 20.0), 
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(138, 154, 162, 0.898)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 58, 20, 20)),
          ),
        )
      ],
    );

    

    
    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name),
      ),
      body: Column(
        children: <Widget>[
          topContent,
          // bottomContent,
        ],
      )
    );
  }
  
}

