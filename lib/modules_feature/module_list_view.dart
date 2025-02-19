import 'package:flutter/material.dart';
import 'package:hane/modules_feature/models/module.dart';

// Module List View
class ModuleListView extends StatelessWidget {
  final List<Module> modules;

  ModuleListView({required this.modules});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        return ListTile(
          title: Text(module.name),
          subtitle: Text(module.description),
          leading: Icon(module.icon),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => module.moduleDetailView),
            );
          },
        );
      },
    );
  }
}
