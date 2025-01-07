import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hane/modules_feature/modules/antibiotics/models/antibiotic.dart';
import 'package:hane/modules_feature/modules/antibiotics/antibiotic_detail_view.dart';

class AntibioticsListView extends StatelessWidget {
  const AntibioticsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Antibiotics List (Cache First)'),
      ),
      body: FutureBuilder<List<Antibiotic>>(
        future: Antibiotic.fetchFromCacheFirstThenServer(),
        builder: (context, snapshot) {
          // 1) Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2) Error state
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // 3) Data retrieved
          final antibiotics = snapshot.data ?? [];
          if (antibiotics.isEmpty) {
            return const Center(child: Text('No antibiotics found.'));
          }

          return ListView.builder(
            itemCount: antibiotics.length,
            itemBuilder: (context, index) {
              final antibiotic = antibiotics[index];
              final name = antibiotic.name ?? 'Unnamed Antibiotic';

              return ListTile(
                title: Text(name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AntibioticDetailView(antibiotic: antibiotic),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}