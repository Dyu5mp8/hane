import 'package:flutter/material.dart';
import 'package:hane/ui_components/blinking_icon.dart';
import 'package:provider/provider.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_view_model.dart';


class DialysisResult extends StatefulWidget {
  const DialysisResult({Key? key}) : super(key: key);

  @override
  _DialysisResultState createState() => _DialysisResultState();
}
class _DialysisResultState extends State<DialysisResult> {
  // GlobalKey to access the blinking icon state
  final GlobalKey<BlinkingIconState> _blinkKey = GlobalKey<BlinkingIconState>();

  // Track the previous warning state
  bool _wasWarningPreviouslyVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<DialysisViewModel>(
      builder: (context, model, child) {
        bool isWarningCurrentlyVisible = model.doseWarning != null;

        // Check for transition: no warning previously but warning now
        if (!_wasWarningPreviouslyVisible && isWarningCurrentlyVisible) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _blinkKey.currentState?.restartBlink();
          });
        }

        // Update the tracked state for future comparisons
        _wasWarningPreviouslyVisible = isWarningCurrentlyVisible;

        return Padding(
          padding: const EdgeInsets.only(bottom: 30, top: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dialysdos (ml/kg/h): ${model.dose.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Visibility(
                    visible: isWarningCurrentlyVisible,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              // Restart blinking on press if needed
                              _blinkKey.currentState?.restartBlink();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Varning'),
                                    content: Text(model.doseWarning ?? ''),
                                    actions: [
                                      TextButton(
                                        onPressed: Navigator.of(context).pop,
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: BlinkingIcon(
                              key: _blinkKey,
                              child: const Icon(
                                Icons.error_outline,
                                size: 23,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Filtrationsfraktion: ${(model.filtrationFraction * 100).toStringAsFixed(2)}%',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}