import 'package:flutter/material.dart';
import 'package:hane/forms/generic_chip_form.dart';
import 'package:hane/forms/generic_chip_widget.dart';

class CategoryForm extends GenericChipForm<dynamic> {
  CategoryForm({required List<dynamic> categories}) : super(items: categories);
}

class CategoryWidget extends StatelessWidget {
  final CategoryForm categoryForm;

  const CategoryWidget({super.key, required this.categoryForm});

  @override
  Widget build(BuildContext context) {
    return GenericChipWidget<dynamic>(
      form: categoryForm,
      labelText: 'Kategorier',
      hintText: "Lägg till kategori (ex. smärtstillande)",
    );
  }
}