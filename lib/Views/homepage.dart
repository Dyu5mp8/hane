import 'package:flutter/material.dart';
import 'package:hane/medications/views/medication_list_view/medication_list_view.dart';
// import 'Module1.dart';
import 'Module2.dart';
import 'Module3.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hane'),
        toolbarHeight: 80,
      ),
      body: Center(
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ), 
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MedicationListView()),
                );
              },
              child: const Text('Läkemedel'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => ()),
            //     );
            //   },
            //   child: const Text('Module Two'),
            // ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ModuleThree()),
                );
              },
              child: const Text('Firestore Example'),
            ),
              

          ],
        ),
      ),
    );
  }
}