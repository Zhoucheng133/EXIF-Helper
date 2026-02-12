import 'package:flutter/material.dart';

class CheckboxItem extends StatefulWidget {

  final bool val;
  final ValueChanged? onChanged;
  final String label;

  const CheckboxItem({super.key, required this.val, required this.onChanged, required this.label});

  @override
  State<CheckboxItem> createState() => _CheckboxItemState();
}

class _CheckboxItemState extends State<CheckboxItem> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          splashRadius: 0,
          value: widget.val,
          onChanged: widget.onChanged,
        ),
        GestureDetector(
          onTap: widget.onChanged==null ? null : () => widget.onChanged!(!widget.val),
          child: Text(widget.label)
        ),
      ],
    );
  }
}