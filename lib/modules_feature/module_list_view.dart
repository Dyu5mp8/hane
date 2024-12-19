import 'package:flutter/material.dart';
import 'package:hane/modules_feature/models/module.dart';

// Module List View
class ModuleListView extends StatelessWidget {
  final List<Module> modules;

  ModuleListView({required this.modules});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
      ),
      body: ListView.builder(
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(module.name),
              subtitle: Text(module.description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => module.moduleDetailView,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}