import 'package:flutter/material.dart';

class Module {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Widget moduleDetailView;

  Module({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.moduleDetailView,
  });
}
