import 'package:flutter/material.dart';

class ScrollIndicator extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollIndicator({Key? key, required this.scrollController}) : super(key: key);

  @override
  _ScrollIndicatorState createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<ScrollIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isVisible = false; // Start with false to prevent flickering

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Repeat the animation in a loop
    _animationController.repeat(reverse: true);

    // Listen to scroll changes
    widget.scrollController.addListener(_scrollListener);

    // Initial check for visibility after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialVisibilityCheck();
    });
  }

  void _initialVisibilityCheck() {
    if (!widget.scrollController.hasClients) {
      // The scrollController is not attached yet, schedule another frame
      WidgetsBinding.instance.addPostFrameCallback((_) => _initialVisibilityCheck());
      return;
    }

    // Access the scroll metrics
    final maxScrollExtent = widget.scrollController.position.maxScrollExtent;
    final minScrollExtent = widget.scrollController.position.minScrollExtent;
    final currentScroll = widget.scrollController.position.pixels;

    // Check if content is scrollable
    if (maxScrollExtent - minScrollExtent <= 0) {
      // Content not scrollable
      if (_isVisible) {
        setState(() {
          _isVisible = false;
        });
      }
      return;
    }

    // Check if user is at the bottom
    if (currentScroll >= maxScrollExtent) {
      // User is at the bottom
      if (_isVisible) {
        setState(() {
          _isVisible = false;
        });
      }
    } else {
      // Content is scrollable and user is not at the bottom
      if (!_isVisible) {
        setState(() {
          _isVisible = true;
        });
      }
    }
  }

  void _scrollListener() {
    // Reuse the same logic for scroll events
    _initialVisibilityCheck();
  }

  @override
  void dispose() {
    // Clean up the controllers and listeners
    widget.scrollController.removeListener(_scrollListener);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return SlideTransition(
      position: _animationController.drive(
        Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(0, 0.4),
        ),
      ),
      child: Icon(
        Icons.arrow_circle_down_rounded,
        size: 24,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
