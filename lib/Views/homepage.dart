import 'package:flutter/material.dart';
// import 'Module1.dart';
import 'Module2.dart';
import 'Module3.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
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
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => ItemListPage()),
            //     );
            //   },
            //   child: const Text('Module One'),
            // ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ModuleTwo()),
                );
              },
              child: const Text('Module Two'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirestoreExample()),
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