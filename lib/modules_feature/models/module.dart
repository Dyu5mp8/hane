import 'package:flutter/material.dart';


class Module {
  final String name;
  final String description;
  final IconData icon;
  final Widget moduleDetailView;

  Module({
    required this.name,
    required this.description,
    required this.icon,
    required this.moduleDetailView,
  });
}