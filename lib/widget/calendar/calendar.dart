import 'package:calendar_test/model/calendar.dart';
import 'package:calendar_test/widget/calendar/calendar_cell.dart';
import 'package:calendar_test/widget/drag_handle.dart';
import 'package:flutter/material.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({
    super.key,
    required this.calendarHeight,
    required this.hideCalendar,
  });

  final double calendarHeight;
  final bool hideCalendar;

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.calendarHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.orangeAccent,
            Colors.redAccent,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () {},
                      tooltip: "Menu",
                      splashRadius: 24,
                      icon: const Icon(
                        Icons.menu_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "${Calendar.getMonthName(selectedDay)}, ${Calendar.getYear(selectedDay)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () {},
                      tooltip: "More",
                      splashRadius: 24,
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Column(
                children: [
                  _namesOfDaysOfWeek(),
                  const SizedBox(height: 12),
                  widget.hideCalendar ? _weekLine() : _monthGrid(), // 0 - 4
                ],
              ),
            ),
            const SizedBox(height: 12),
            DragHandle(color: const Color(0xFFE7E0EC).withOpacity(0.4)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _namesOfDaysOfWeek() {
    List<Widget> list = [];
    List<String> daysOfTheWeek = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];

    for (int i = 0; i < daysOfTheWeek.length; i++) {
      list.add(
        Container(
          alignment: Alignment.center,
          width: 48,
          child: Text(
            daysOfTheWeek[i],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: list,
    );
  }

  Widget _monthGrid() {
    List<Widget> weeksList = [];
    final DateTime dayOfMonth = Calendar.getFirstDayOfMonth(selectedDay);

    for (int week = 0; week < 5; week++) {
      List<Widget> daysList = [];

      for (int day = 0; day < 7; day++) {
        DateTime currentDateTime = DateTime(
          dayOfMonth.year,
          dayOfMonth.month,
          dayOfMonth.day + day + 7 * week + getFirstDayOfMonthOffset(dayOfMonth), // 7 * week - shift for week
        );

        daysList.add(
          GestureDetector(
            onTap: () {
              setState(() {
                selectedDay = currentDateTime;
              });
            },
            child: CalendarCell(
              dayNumber: Calendar.getDayNumber(currentDateTime),
              isSelected: Calendar.isEqaulsYMd(selectedDay, currentDateTime),
              isBorder: Calendar.isNotEqaulsYMd(selectedDay, DateTime.now()) && Calendar.isEqaulsYMd(currentDateTime, DateTime.now()),
              isEmpty: true,
              numberColor: (selectedDay.month != currentDateTime.month) ? Colors.grey : null,
            ),
          ),
        );
      }

      weeksList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: daysList,
        ),
      );

      if (week < 4) {
        weeksList.add(const SizedBox(height: 4)); // padding between weeks
      }
    }

    return Column(children: weeksList);
  }

  Widget _weekLine() {
    DateTime firstDayOfWeek = Calendar.getFirstDayOfWeek(selectedDay);
    List<Widget> daysList = [];

    for (int day = 0; day < 7; day++) {
      DateTime currentDateTime = DateTime(
        firstDayOfWeek.year,
        firstDayOfWeek.month,
        firstDayOfWeek.day + day,
      );

      daysList.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDay = currentDateTime;
            });
          },
          child: CalendarCell(
            dayNumber: Calendar.getDayNumber(currentDateTime),
            isSelected: Calendar.isEqaulsYMd(selectedDay, currentDateTime),
            isBorder: Calendar.isNotEqaulsYMd(selectedDay, DateTime.now()) && Calendar.isEqaulsYMd(currentDateTime, DateTime.now()),
            isEmpty: true,
            numberColor: (selectedDay.month != currentDateTime.month) ? Colors.grey : null,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: daysList,
    );
  }

  int getFirstDayOfMonthOffset(DateTime dt) {
    const Map<String, int> offsetMap = {
      "Monday": 0,
      "Tuesday": 1,
      "Wednesday": -2,
      "Thursday": -3,
      "Friday": -4,
      "Saturday": -5,
      "Sunday": -6,
    };

    return offsetMap[Calendar.getDayName(dt)]!;
  }
}
