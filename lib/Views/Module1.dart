import 'package:flutter/material.dart';

class ItemListPage extends StatefulWidget {
  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<Map<String, String>> mockData = [
    {
      'name': 'Amoxicillin',
      'indication': 'Bacterial Infection',
      'dosage': '500 mg every 8 hours'
    },
    {
      'name': 'Ibuprofen',
      'indication': 'Pain Relief',
      'dosage': '400 mg every 4 to 6 hours'
    },
    {
      'name': 'Metformin',
      'indication': 'Type 2 Diabetes',
      'dosage': '500 mg twice a day'
    },
    {
      'name': 'Lisinopril',
      'indication': 'High Blood Pressure',
      'dosage': '10 mg once a day'
    },
    {
      'name': 'Simvastatin',
      'indication': 'High Cholesterol',
      'dosage': '20 mg once a day'
    },
    // Add more medications as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medications List'),
      ),
      body: ListView.builder(
        itemCount: mockData.length,
        itemBuilder: (context, index) {
          Map<String, String> item = mockData[index];
          return ListTile(
            title: Text(item['name']!),
            subtitle: Text('Indication: ${item['indication']} - Dosage: ${item['dosage']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailView(itemDetails: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ItemDetailView extends StatelessWidget {
  final Map<String, String> itemDetails;

  ItemDetailView({required this.itemDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail of ${itemDetails['name']}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Name: ${itemDetails['name']}', style: Theme.of(context).textTheme.headlineMedium),
            Text('Indication: ${itemDetails['indication']}', style: Theme.of(context).textTheme.labelSmall),
            Text('Dosage: ${itemDetails['dosage']}', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}