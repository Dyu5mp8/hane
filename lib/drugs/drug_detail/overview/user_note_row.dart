import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';

class UserNoteRow extends StatefulWidget {
  const UserNoteRow({super.key});

  @override
  State<UserNoteRow> createState() => _UserNoteRowState();
}

class _UserNoteRowState extends State<UserNoteRow> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  Drug? drug;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Add a listener to the focus node
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // The TextField has lost focus, write to backend
        _saveUserNotes();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newDrug = Provider.of<Drug>(context, listen: true);
    if (drug != newDrug) {
      drug = newDrug;
      _controller.text = drug?.userNotes ?? "";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose(); // Dispose of the focus node
    super.dispose();
  }

  void _saveUserNotes() {
    try {
      final value = _controller.text;
      // Update the user notes in the provider
      Provider.of<DrugListProvider>(context, listen: false)
          .addUserNotes(drug!.id!, value);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kunde inte spara anteckningar"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure drug is not null before proceeding
    if (drug == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        textCapitalization: TextCapitalization.sentences,
        maxLines: null, // Allows multiple lines
        textInputAction: TextInputAction.done,
        onTapOutside: (event) {
          FocusScope.of(context).previousFocus();
        },
        decoration: const InputDecoration(
          border: InputBorder.none, // Remove borders
          labelText: "Egna anteckningar",
          labelStyle: TextStyle(
            fontSize: 15,
          ),
          isDense: true, // Reduce height
          contentPadding: EdgeInsets.zero, // Remove padding
        ),
        style: const TextStyle(fontSize: 14),
        // Remove the onChanged callback to prevent writes on every character
        // onChanged: (value) {},
      ),
    );
  }
}