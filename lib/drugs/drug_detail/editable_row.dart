import 'package:flutter/material.dart';

class EditableRow extends StatefulWidget {
  final String? text;
  final Widget editDialog;
  final bool isEditMode;
  final TextStyle? textStyle;

  const EditableRow({
    Key? key,
    required this.text,
    required this.editDialog,
    required this.isEditMode,
    this.textStyle,
  }) : super(key: key);

  @override
  _EditableRowState createState() => _EditableRowState();
}

class _EditableRowState extends State<EditableRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _iconAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
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
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEditMode
          ? () {
              showDialog(
                context: context,
                builder: (context) => widget.editDialog,
              );
            }
          : null,
      child: Container(
        padding: widget.isEditMode ? EdgeInsets.symmetric(vertical: 4, horizontal:8) : EdgeInsets.only(top:8),
        decoration: BoxDecoration(
          color: widget.isEditMode ? Theme.of(context).primaryColorLight : Colors.transparent,
          borderRadius: BorderRadius.circular(16.0)
      
          
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                widget.text ?? "",
                style: widget.textStyle?.copyWith(
                      color: widget.isEditMode
                          ? Colors.blue[800]
                          : Colors.black,
                      fontWeight:
                          widget.isEditMode ? FontWeight.bold : FontWeight.normal,
                    ) ??
                    Theme.of(context).textTheme.headlineLarge!.copyWith(
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
                    Icons.edit_note_outlined,
                    color: Colors.blue[800],
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}