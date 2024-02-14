import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:ypa/component/banner.dart';
import 'package:ypa/database/drift_database.dart';
import 'package:ypa/layout/main_layout.dart';
import 'package:ypa/model/mood_with_color.dart';
import 'package:ypa/screen/todo_screen.dart';
import 'package:ypa/component/pie_chart.dart';

import '../component/calendar.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({Key? key}) : super(key: key);

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<MoodWithColor>>(
          stream: GetIt.I<LocalDatabase>().getMoodWithColor(),
          builder: (context, snapshot) {
            // if(snapshot.hasData){
            // List<int> colorIdList = [];
            // List<DateTime> dateList = [];
            //   colorIdList = snapshot.data!.map((e) => e.colorId).toList();
            //   dateList = snapshot.data!.map((e) => e.date).toList();
            // }
            // error
            if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong"),
              );
            }
            // Future build ran for the first time and Loading
            if (snapshot.connectionState != ConnectionState.none &&
                !snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 53,
                  color: Color(0xFFAEBDCA),
                ),
                _Top(
                  selectedDay: selectedDay,
                  focusedDay: focusedDay,
                  onDaySelected: onDaySelected,
                  onPageChanged: onPageChanged,
                  onDoubleTap: onDoubleTap,
                  moodList: snapshot.data!,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Banners(title: "My Mood Status"),
                const SizedBox(
                  height: 10,
                ),
                _Bottom(
                  focusedDay: focusedDay,
                  colorSetter: onColorPick,
                  selectedColor: selectedColorId,
                  selectedDay: selectedDay,
                  onDoubleTap2: onDoubleTap2,
                ),
              ],
            );
          }),
    );
  }

  onDoubleTap2() {
    setState(() {
      GetIt.I<LocalDatabase>().removeMoodByDate(selectedDay);
    });
    onDaySelected(selectedDay, focusedDay);
  }

  onColorPick(int id) {
    setState(
      () {
        if (this.selectedColorId == null) {
          print("Create");
          GetIt.I<LocalDatabase>().createMood(
            MoodsCompanion(
              date: Value(selectedDay),
              colorId: Value(id),
            ),
          );
        }
        this.selectedColorId = id;
        GetIt.I<LocalDatabase>().updateMoodByDate(
          selectedDay,
          MoodsCompanion(
            date: Value(selectedDay),
            colorId: Value(id),
          ),
        );
      },
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
      //log('mood screen selected day: $selectedDay');
      this.selectedColorId = null;
    });
  }

  onPageChanged(DateTime focusedDay) {
    setState(() {
      this.focusedDay = focusedDay;
    });
  }

  onDoubleTap() {
    setState(() {
      onDaySelected(selectedDay, focusedDay);
      //log('mood screen selected day: $selectedDay');
    });
    //show todo_screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            ToDoScreen(selectedDay: selectedDay, focusedDay: focusedDay),
      ),
    );
  }
}

class _Top extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final onDaySelected;
  final onPageChanged;
  final GestureTapCallback onDoubleTap;
  final List<MoodWithColor> moodList;
  const _Top(
      {required this.selectedDay,
      required this.focusedDay,
      required this.onDaySelected,
      required this.onPageChanged,
      required this.onDoubleTap,
      required this.moodList,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Calendar(
        //todos: todos,
        selectedDay: selectedDay,
        focusedDay: focusedDay,
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  final DateTime selectedDay;
  final onDoubleTap2;
  DateTime focusedDay;
  ColorSetter colorSetter;
  int? selectedColor;

  _Bottom(
      {required this.focusedDay,
      required this.onDoubleTap2,
      required this.colorSetter,
      required this.selectedDay,
      this.selectedColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: FutureBuilder<List<Mood>>(
        future: GetIt.I<LocalDatabase>().getMoodByFocusedDay(focusedDay),
        builder: (context, snapshot) {
          // error
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong"),
            );
          }
          // Future build ran for the first time and Loading
          if (snapshot.connectionState != ConnectionState.none &&
              !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List angry = [];
          List frustrated = [];
          List happy = [];
          List calm = [];
          List sad = [];
          List excited = [];

          for (int i = 0; i < snapshot.data!.length; i++) {
            switch (snapshot.data![i].colorId) {
              case 1:
                angry.add(snapshot.data![i].colorId);
                break;
              case 2:
                frustrated.add(snapshot.data![i].colorId);
                break;
              case 3:
                happy.add(snapshot.data![i].colorId);
                break;
              case 4:
                calm.add(snapshot.data![i].colorId);
                break;
              case 5:
                sad.add(snapshot.data![i].colorId);
                break;
              case 6:
                excited.add(snapshot.data![i].colorId);
                break;
            }
          }
          int total = 0;

          total += angry.length.toInt();
          total += frustrated.length.toInt();
          total += happy.length.toInt();
          total += calm.length.toInt();
          total += sad.length.toInt();
          total += excited.length.toInt();

          if (snapshot.data!.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: FutureBuilder<Mood>(
                  future: GetIt.I<LocalDatabase>().getMoodByDate(selectedDay),
                  builder: (context, snapshot) {
                    selectedColor = snapshot.data?.colorId;

                    return MoodPieChart(
                      radius: 58,
                      angry_value: (angry.length.toDouble() / total) * 100,
                      frustrated_value:
                          (frustrated.length.toDouble() / total) * 100,
                      happy_value: (happy.length.toDouble() / total) * 100,
                      calm_value: (calm.length.toDouble() / total) * 100,
                      sad_value: (sad.length.toDouble() / total) * 100,
                      excited_value: (excited.length.toDouble() / total) * 100,
                      colorSetter: colorSetter,
                      selectedColor: selectedColor,
                      selectedDay: selectedDay,
                      onDoubleTap: onDoubleTap2,
                    );
                  },
                ),
              ),
            );
          } else {
            return MoodPieChart(
              radius: 0,
              angry_value: 0,
              frustrated_value: 0,
              happy_value: 0,
              calm_value: 0,
              sad_value: 0,
              excited_value: 0,
              colorSetter: colorSetter,
              selectedColor: selectedColor,
              selectedDay: selectedDay,
              onDoubleTap: onDoubleTap2,
            );
          }
        },
      ),
    );
  }
}
