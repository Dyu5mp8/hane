import 'package:flutter/material.dart';

class ExpandedDialog extends StatelessWidget{

  final String? title;
  final String text;


  const ExpandedDialog({Key? key, required String this.text, String? this.title}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AlertDialog(


      title: (title != null) ? Text("$title (utökat)") : Text("Utökad information"),
      titleTextStyle: Theme.of(context).textTheme.headlineLarge,

        content: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.7,
          width: MediaQuery.sizeOf(context).width * 0.8,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      );
  
  }







}