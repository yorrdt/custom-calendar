import 'package:flutter/material.dart';
import 'package:test_schedule/database/schedule_db.dart';
import 'package:test_schedule/model/schedule.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime(2023);
  DateTime date = DateTime(2023);
  List<Schedule> schedule = [];
  bool isLoadingSchedule = false;

  @override
  void initState() {
    super.initState();

    refreshSchedule();
  }

  @override
  void dispose() {
    ScheduleDatabase.instance.close();
    super.dispose();
  }

  Future refreshSchedule() async {
    setState(() {
      isLoadingSchedule = true;
    });

    schedule = await ScheduleDatabase.instance.readSchedule();

    setState(() {
      isLoadingSchedule = false;
    });
  }

  Future addScheduleItem(DateTime date) async {
    final scheduleItem = Schedule(title: "Some title", createdTime: date);

    await ScheduleDatabase.instance.create(scheduleItem);
  }

  Future onlyFilteredScheduleItems(DateTime dt) async {
    setState(() {
      isLoadingSchedule = true;
    });

    schedule = await ScheduleDatabase.instance.readScheduleRange(dt);

    setState(() {
      isLoadingSchedule = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2024),
                    );

                    if (newDate == null) return;

                    setState(() {
                      selectedDate = newDate;
                    });

                    onlyFilteredScheduleItems(selectedDate);
                  },
                  child: const Text("Select date"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2024),
                    );

                    if (newDate == null) return;

                    setState(() {
                      date = newDate;
                    });

                    addScheduleItem(date);
                    refreshSchedule();
                  },
                  child: const Text("Add new"),
                ),
                ElevatedButton(
                  onPressed: () {
                    refreshSchedule();
                  },
                  child: const Text("View all"),
                ),
              ],
            ),
            isLoadingSchedule
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: schedule.length,
                      itemBuilder: (context, index) {
                        final item = schedule[index];

                        return ListTile(
                          title: Text(item.title),
                          subtitle: Text(item.createdTime.toString()),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
