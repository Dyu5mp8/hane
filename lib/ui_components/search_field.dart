import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const SearchField({
    Key? key,
    required this.controller,
    this.placeholder = 'Search...',
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: CupertinoSearchTextField(
        controller: controller,
        placeholder: placeholder,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(148, 76, 78, 95),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}