import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/models/concentration.dart';

class ConcentrationDetailView extends StatelessWidget {
  final List<Concentration> concentrations;

  const ConcentrationDetailView(this.concentrations);

@override
  build(context) => Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          title: const Text('Accordion'),
        ),
    body: Accordion(
  children: concentrations
      .where((concentration) => concentration.mixingInstructions?.isNotEmpty ?? false)
      .map((concentration) => AccordionSection(
            isOpen: true,
            header: Text(
              concentration.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: Column(
              children: [
                Text('Spädning: $concentration'),
                Text('Instruktion: ${concentration.mixingInstructions}'),
              ],
            ),
            headerBackgroundColor: Colors.blue,
            headerBackgroundColorOpened: Colors.blueAccent,
            headerBorderColor: Colors.blueGrey,
            headerBorderColorOpened: Colors.blueGrey[700],
            headerBorderWidth: 2.0,
            headerBorderRadius: 8.0,
            headerPadding: EdgeInsets.all(16.0),
            leftIcon: Icon(Icons.info, color: Colors.white),
            rightIcon: Icon(Icons.arrow_drop_down, color: Colors.white),
            contentBackgroundColor: Colors.white,
            contentBorderColor: Colors.blueGrey,
            contentBorderWidth: 1.0,
            contentBorderRadius: 8.0,
            contentHorizontalPadding: 16.0,
            contentVerticalPadding: 8.0,
            paddingBetweenOpenSections: 8.0,
            paddingBetweenClosedSections: 4.0,
          ))
      .toList(),
)
  );
} 