import 'package:flutter/material.dart';

/// A widget that displays a child icon with a badge showing a count retrieved
/// from a provided [Future<int>]. If the count is zero, the badge is not shown.
class CountBadge extends StatelessWidget {
  final Future<int> futureCount;
  final Widget child;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Color? badgeColor;
  final TextStyle? badgeTextStyle;

  const CountBadge({
    Key? key,
    required this.futureCount,
    required this.child,
    this.loadingWidget,
    this.errorWidget,
    this.badgeColor,
    this.badgeTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: futureCount,
      builder: (context, snapshot) {
        // While waiting for the future, show either a loading widget or the child
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ?? child;
        }

        // On error or no data, show either an error widget or the child
        if (snapshot.hasError || !snapshot.hasData) {
          return errorWidget ?? child;
        }

        final count = snapshot.data!;
        if (count == 0) {
          // If count is zero, just show the child without a badge
          return child;
        }

        // If count > 0, display the built-in Badge widget
        return Badge(
          label: Text(
            count.toString(),

          ),
          child: child,
        );
      },
    );
  }
}