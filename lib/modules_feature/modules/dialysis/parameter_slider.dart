import 'package:flutter/material.dart';
import 'package:hane/ui_components/blinking_icon.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_view_model.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_parameter.dart';
import 'package:flutter/material.dart';
import 'package:hane/ui_components/blinking_icon.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_view_model.dart';
import 'package:hane/modules_feature/modules/dialysis/models/dialysis_parameter.dart';

class ParameterSlider extends StatelessWidget {
  final String label;
  final DialysisParameter Function(DialysisViewModel) parameterSelector;
  final void Function(DialysisViewModel, double) onChanged;
  final Color? thumbColor;
  final double? stepSize;
  final double? interval;
  final bool showTicks;
  final Widget? trailing;

  const ParameterSlider({
    Key? key,
    required this.label,
    required this.parameterSelector,
    required this.onChanged,
    this.thumbColor,
    this.stepSize,
    this.interval,
    this.showTicks = false,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DialysisViewModel>(
      builder: (context, model, child) {
        final parameter = parameterSelector(model);
        final textStyle = Theme.of(context).textTheme.bodyLarge;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$label: ${parameter.value.toStringAsFixed(1)}',
                  style: textStyle,
                ),
                SizedBox(width: 8),
               Visibility(
  visible: parameter.warning != null,
  maintainSize: true,
  maintainAnimation: true,
  maintainState: true,
  child: SizedBox(
    width: 24, // desired width
    height: 24, // desired height
    child: IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(), 
      onPressed: () {
        _showWarningDialog(context, parameter);
      },
      icon: BlinkingIcon(key :Key(label),child: const Icon(FontAwesome.circle_exclamation_solid, size: 20, color: Colors.deepOrange,)), // Smaller icon size
    ),
  ),
),
Expanded(child:SizedBox()), // Align trailing to the right
                trailing ?? const SizedBox(),
              ],
            ),
            const SizedBox(height: 4),
            SfSlider(
              min: parameter.minValue,
              max: parameter.maxValue,
              value:
                  parameter.value.clamp(parameter.minValue, parameter.maxValue),
              interval: interval,
              stepSize: stepSize,
              showTicks: showTicks,
              thumbIcon: thumbColor != null
                  ? Container(
                      decoration: BoxDecoration(
                        color: thumbColor,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
              onChangeEnd: (_) {
                if (parameter.warning != null)
                _showWarningDialog(context, parameter);
                
              },
              onChanged: (dynamic newVal) {
                onChanged(model, newVal as double);
              },
            ),
          ],
        );
      },
    );
  }

  _showWarningDialog(BuildContext context, DialysisParameter parameter) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Varning'),
          content: Text(parameter.warning ?? ''),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('OK'),
            ),
          ],
        );
      },
    );


  }
}

class CitrateSwitch extends StatelessWidget {
  const CitrateSwitch({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DialysisViewModel>(
      builder: (context, model, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Lås', style: Theme.of(context).textTheme.bodyLarge),
            Transform.scale(
              scale: 0.7, // Slightly smaller switch
              child: Switch(
                value: model.isCitrateLocked,
                onChanged: (value) {
                  model.isCitrateLocked = value;
                },
                activeTrackColor: Colors.orange,
              ),
            ),
          ],
        );
      },
    );
  }
}
