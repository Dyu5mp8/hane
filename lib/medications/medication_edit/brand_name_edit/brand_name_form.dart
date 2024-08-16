import 'package:flutter/material.dart';
import 'package:hane/forms/generic_chip_form.dart';
import 'package:hane/forms/generic_chip_widget.dart';

class BrandNameForm extends GenericChipForm<dynamic> {
  BrandNameForm({required List<dynamic> brandNames}) : super(items: brandNames);
}

class BrandNameWidget extends StatelessWidget {
  final BrandNameForm brandNameForm;

  const BrandNameWidget({super.key, required this.brandNameForm});

  @override
  Widget build(BuildContext context) {
    return GenericChipWidget<dynamic>(
      form: brandNameForm,
      labelText: 'Varumärkesnamn',
      hintText: 'Lägg till synonym (ex. Alvedon)',
    );
  }
}