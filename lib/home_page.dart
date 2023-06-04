import 'package:calendar_test/widget/calendar/calendar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double calendarCurrentHeight = 198;
  bool hideCalendar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Calendar Widget
          GestureDetector(
            onVerticalDragEnd: (DragEndDetails details) {
              double velocity = details.primaryVelocity!;

              if (velocity < 0) {
                setState(() {
                  calendarCurrentHeight = 198;
                  hideCalendar = true;
                });
              } else {
                setState(() {
                  calendarCurrentHeight = 406;
                  hideCalendar = false;
                });
              }
            },
            child: CalendarWidget(
              calendarHeight: calendarCurrentHeight,
              hideCalendar: hideCalendar,
            ),
          ),
        ],
      ),
    );
  }
}
