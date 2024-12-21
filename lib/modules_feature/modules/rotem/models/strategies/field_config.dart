import 'package:flutter/material.dart';
import 'package:hane/modules_feature/modules/rotem/models/rotem_evaluator.dart';

typedef FieldValidator = String? Function(String? value);

class FieldConfig {
  final String label;
  final RotemField field;
  final bool required;
  final TextInputType inputType;
  final RotemSection section;
  final FieldValidator? validator; // Optional per-field validator

  FieldConfig({
    required this.label,
    required this.field,
    required this.section,
    this.required = false,
    this.inputType = TextInputType.number,
    this.validator,
  });
}