import 'package:flutter/material.dart';
import 'package:hane/medications/views/medication_list_view/medication_list_view.dart';
import 'package:provider/provider.dart';
import 'package:hane/medications/services/medication_list_provider.dart';

class MedicationInitScreen extends StatelessWidget {
  final String user;

  MedicationInitScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    print('MedicationInitScreen: user: $user');
    return ChangeNotifierProvider(
      create: (context) => MedicationListProvider(user: user),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Initialize Medications'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'How would you like to start?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final medicationProvider =
                      Provider.of<MedicationListProvider>(context, listen: false);

                  medicationProvider.setUserData(user);
                  
                  await medicationProvider.queryMedications(isGettingDefaultList: false);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MedicationListView()));
                },
                child: Text('Start Fresh'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final medicationProvider =
                      Provider.of<MedicationListProvider>(context, listen: false);
                medicationProvider.setUserData(user);

                  await medicationProvider.copyMasterToUser();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MedicationListView()));
                },
                child: Text('Copy from Master'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}