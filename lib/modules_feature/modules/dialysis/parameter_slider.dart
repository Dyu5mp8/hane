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
class ParameterSlider extends StatefulWidget {
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
  _ParameterSliderState createState() => _ParameterSliderState();
}
class _ParameterSliderState extends State<ParameterSlider> {
  // GlobalKey to access the blinking icon state
  final GlobalKey<BlinkingIconState> _blinkKey = GlobalKey<BlinkingIconState>();

  // Track the previous warning visibility for this slider
  bool _wasWarningPreviouslyVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<DialysisViewModel>(
      builder: (context, model, child) {
        final parameter = widget.parameterSelector(model);
        final textStyle = Theme.of(context).textTheme.bodyLarge;
        
        // Current warning visibility for this parameter
        bool isWarningCurrentlyVisible = parameter.warning != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${widget.label}: ${parameter.value.toStringAsFixed(1)}',
                  style: textStyle,
                ),
                const SizedBox(width: 8),
                Visibility(
                  visible: isWarningCurrentlyVisible,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        _showWarningDialog(context, parameter);
                      },
                      icon: BlinkingIcon(
                        key: _blinkKey, // Assign the global key
                        child: const Icon(
                          Icons.error_outline,
                          size: 23,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: const SizedBox()),
                widget.trailing ?? const SizedBox(),
              ],
            ),
            const SizedBox(height: 4),
            SfSlider(
              min: parameter.minValue,
              max: parameter.maxValue,
              value: parameter.value.clamp(parameter.minValue, parameter.maxValue),
              interval: widget.interval,
              stepSize: widget.stepSize,
              showTicks: widget.showTicks,
              thumbIcon: widget.thumbColor != null
                  ? Container(
                      decoration: BoxDecoration(
                        color: widget.thumbColor,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
              onChangeEnd: (_) {
                // Check for first-time warning transition upon slider release
                if (!_wasWarningPreviouslyVisible && isWarningCurrentlyVisible) {
                  _blinkKey.currentState?.restartBlink();
                }
                // Update previous warning state after handling
                _wasWarningPreviouslyVisible = isWarningCurrentlyVisible;

                // If warning exists, show dialog
                if (parameter.warning != null) {
                  _showWarningDialog(context, parameter);
                }
              },
              onChanged: (dynamic newVal) {
                widget.onChanged(model, newVal as double);
              },
            ),
          ],
        );
      },
    );
  }

  void _showWarningDialog(BuildContext context, DialysisParameter parameter) {
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
