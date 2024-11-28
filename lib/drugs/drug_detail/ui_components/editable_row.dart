import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';

class EditableRow extends StatefulWidget {
  final String? text;
  final Widget editDialog;
  final bool isEditMode;
  final TextStyle? textStyle;
  final bool hideWhenNotEditing;
  final EdgeInsets? padding;
  final Color? editingBackgroundColor;
  final Color? nonEditingBackgroundColor;
  final Duration animationDuration;
  final double iconSize;

  const EditableRow({
    super.key,
    required this.text,
    required this.editDialog,
    required this.isEditMode,
    this.textStyle,
    this.hideWhenNotEditing = false,
    this.padding,
    this.editingBackgroundColor,
    this.nonEditingBackgroundColor = Colors.transparent,
    this.animationDuration = const Duration(milliseconds: 500),
    this.iconSize = 20.0,
  });

  @override
  State<EditableRow> createState() => _EditableRowState();
}

class _EditableRowState extends State<EditableRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _iconAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isEditMode) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant EditableRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEditMode) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditMode = Provider.of<EditModeProvider>(context).editMode;

    if (widget.hideWhenNotEditing && !widget.isEditMode) {
      return const SizedBox.shrink();
    }

    final padding = widget.padding ??
        (widget.isEditMode
            ? const EdgeInsets.symmetric(vertical: 4, horizontal: 8)
            : const EdgeInsets.only(top: 8));

    return InkWell(
      onTap: isEditMode
          ? () {
              showDialog(
                context: context,
                builder: (context) => widget.editDialog,
              );
            }
          : null,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: isEditMode
              ? 
                  Theme.of(context).chipTheme.backgroundColor
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                widget.text?.isNotEmpty == true ? widget.text! : "",
                style: widget.textStyle?.copyWith(
                    
                      fontWeight: widget.isEditMode
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ) ??
                    Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: widget.isEditMode
                              ? Colors.blue[800]
                              : Colors.black,
                          fontWeight: widget.isEditMode
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
              ),
            ),
            if (widget.isEditMode)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ScaleTransition(
                  scale: _iconAnimation,
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue[800],
                    size: widget.iconSize,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
