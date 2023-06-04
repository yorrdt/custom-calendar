import 'package:flutter/material.dart';

class CalendarCell extends StatelessWidget {
  const CalendarCell({
    super.key,
    required this.dayNumber,
    required this.isSelected,
    required this.isBorder,
    required this.isEmpty,
    this.numberColor,
  });

  final int dayNumber;
  final bool isSelected;
  final bool isBorder;
  final bool isEmpty;
  final Color? numberColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.indigo : null,
        border: isBorder
            ? Border.all(
                color: Colors.white,
                width: 1,
              )
            : null,
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Text(
            "$dayNumber",
            style: TextStyle(
              color: numberColor ?? Colors.white,
              fontSize: 20,
            ),
          ),
          isEmpty
              ? const SizedBox.shrink()
              : Positioned(
                  bottom: 8,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    height: 4,
                    width: 4,
                  ),
                ),
        ],
      ),
    );
  }
}
