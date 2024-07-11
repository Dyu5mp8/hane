import 'package:flutter/material.dart';

class ModuleTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Expansion Tile'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),  
            
            ExpansionTile(
              expandedAlignment: Alignment.center,
              
              title: TextFormField(

                initialValue: 'amimox',
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              children: <Widget>[
                ListTile(
                  title: TextField(),
                ),
                ListTile(
                  title: TextField(),
                ),
                ListTile(
                  title: TextField(),
                ),
              ],
            ),
            ExpansionTile(title: TextField()),
          ],
        ),
      ),
    );
  }
}