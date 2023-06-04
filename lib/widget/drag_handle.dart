import 'package:flutter/material.dart';

class DragHandle extends StatelessWidget {
  const DragHandle({
    super.key,
    this.color,
    this.height,
    this.width,
  });

  final Color? color;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: width ?? 32,
      decoration: BoxDecoration(
        color: color ?? Colors.grey,
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
      ),
    );
  }
}
