import 'package:flutter/material.dart';
import 'package:hane/ui_components/auto_scroll_expansion_tile.dart';

class DialysisConsitutentsList extends StatelessWidget {
  const DialysisConsitutentsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dialysisData = [
      {
        'title': 'Predilution',
        'children': [
          {
            'title': 'Regiocit',
            'rows': [
              {'label': 'Citrat (mmol/L)', 'value': '18'},
              {'label': 'Na+ (mmol/L)', 'value': '140'},
              {'label': 'Cl- (mmol/L)', 'value': '86'},
            ],
          },
        ],
      },
      {
        'title': 'Dialysvätska',
        'children': [
          {
            'title': 'Biphozyl',
            'rows': [
              {'label': 'Na+ (mmol/L)', 'value': '140'},
              {'label': 'K+ (mmol/L)', 'value': '4'},
              {'label': 'Mg2+ (mmol/L)', 'value': '0.75'},
              {'label': 'Ca2+ (mmol/L)', 'value': '0'},
              {'label': 'Cl- (mmol/L)', 'value': '122'},
              {'label': 'HCO3- (mmol/L)', 'value': '22'},
              {'label': 'HPO42- (mmol/L)', 'value': '1'},
              {'label': 'Laktat- (mmol/L)', 'value': '0'},
              {'label': 'Glukos (mmol/L)', 'value': '0'},
              {'label': 'Citrat (mmol/L)', 'value': '0'},
            ],
          },
        ],
      },
      {
        'title': 'Postdilution',
        'children': [
          {
            'title': 'Phoxilium',
            'rows': [
              {'label': 'Na+ (mmol/L)', 'value': '140'},
              {'label': 'K+ (mmol/L)', 'value': '4'},
              {'label': 'Mg2+ (mmol/L)', 'value': '0.6'},
              {'label': 'Ca2+ (mmol/L)', 'value': '1.25'},
              {'label': 'Cl- (mmol/L)', 'value': '115.9'},
              {'label': 'HCO3- (mmol/L)', 'value': '30'},
              {'label': 'Laktat- (mmol/L)', 'value': '0'},
              {'label': 'Glukos (mmol/L)', 'value': '0'},
              {'label': 'HPO42- (mmol/L)', 'value': '1.2'},
            ],
          },
          {
            'title': 'Hemosol B0',
            'rows': [
              {'label': 'Na+ (mmol/L)', 'value': '140'},
              {'label': 'K+ (mmol/L)', 'value': '0'},
              {'label': 'Mg2+ (mmol/L)', 'value': '0.5'},
              {'label': 'Ca2+ (mmol/L)', 'value': '1.75'},
              {'label': 'Cl- (mmol/L)', 'value': '109.5'},
              {'label': 'HCO3- (mmol/L)', 'value': '32'},
              {'label': 'Laktat- (mmol/L)', 'value': '3'},
              {'label': 'Glukos (mmol/L)', 'value': '0'},
              {'label': 'HPO42- (mmol/L)', 'value': '0'},
            ],
          },
        ],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Innehåll dialysvätskor",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            decoration: TextDecoration.underline,
          ),
        ),
        ...dialysisData.map((group) {
          return AutoScrollExpansionTile(
            title: Text(group['title'] as String),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children:
                      (group['children'] as List).map((solution) {
                        return AutoScrollExpansionTile(
                          title: Text(solution['title'] as String),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                children:
                                    (solution['rows'] as List).map((row) {
                                      return ListTile(
                                        dense: true,
                                        title: Text(row['label'] as String),
                                        trailing: Text(row['value'] as String),
                                        contentPadding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 16.0,
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
