import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:hane/drugs/models/concentration.dart';

class ConcentrationDetailView extends StatelessWidget {
  final List<Concentration> concentrations;

  const ConcentrationDetailView(this.concentrations);

@override
  build(context) => Scaffold(
       
        appBar: AppBar(
          title: const Text('Spädningar'),
        ),
  body: Accordion(
  headerPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  paddingBetweenOpenSections: 8.0,
  paddingBetweenClosedSections: 4.0,
  maxOpenSections: 10,
  scaleWhenAnimating: true,
  initialOpeningSequenceDelay: 0,

  contentBackgroundColor: Theme.of(context).colorScheme.primaryFixed,
  children: concentrations
      .where((concentration) => concentration.mixingInstructions?.isNotEmpty ?? false)
      .map((concentration) => AccordionSection(
            isOpen: true,
            headerBackgroundColor: Theme.of(context).colorScheme.primary,
      
            headerBorderRadius: 20.0,
            headerBorderWidth: 2,
            contentBackgroundColor: const Color.fromARGB(255, 234, 228, 225),
            contentBorderRadius: 8.0,
            contentHorizontalPadding: 10,
            contentVerticalPadding: 10,
            header: Align(
              alignment: Alignment.centerRight,
              child: Text(
                concentration.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
            ),

             
     
            rightIcon: Icon(
              Icons.expand_more,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            content: 
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${concentration.mixingInstructions}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
            
          ))
      .toList(),
),
);
} 