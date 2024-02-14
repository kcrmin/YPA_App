import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ypa/component/date_card.dart';
import 'package:ypa/component/goal_card.dart';
import 'package:ypa/component/goal_form.dart';
import 'package:ypa/component/home_banner.dart';
import 'package:ypa/database/drift_database.dart';
import 'package:ypa/layout/main_layout.dart';
import 'package:ypa/screen/todo_screen.dart';
import 'package:ypa/util/goal_dialog.dart';
import 'package:ypa/component/pie_chart.dart';

import '../component/calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          _Top(),
          SizedBox(
            height: 10,
          ),
          HomeBanner(title: "Goal"),
          SizedBox(
            height: 4,
          ),
          _Bottom(),
        ],
      ),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
      //log('mood screen selected day: $selectedDay');
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
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) =>
            ToDoScreen(selectedDay: selectedDay, focusedDay: focusedDay)));
  }
}

class _Top extends StatelessWidget {
  const _Top({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/mood');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        child: DateCard(),
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<List<Goal>>(
            stream: GetIt.I<LocalDatabase>().getGoals(),
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
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 12.0,
                  );
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showGoalDialog(context, snapshot.data![index].id);
                    },
                    child: Dismissible(
                      key: ObjectKey(snapshot.data![index].id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (DismissDirection direction) {
                        GetIt.I<LocalDatabase>()
                            .removeGoalById(snapshot.data![index].id);
                      },
                      child: GoalCard(
                        id: snapshot.data![index].id,
                        name: snapshot.data![index].title,
                        progress: snapshot.data![index].progress,
                        dueDate: snapshot.data![index].dueDate,
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
