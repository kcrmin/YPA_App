import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:ypa/database/drift_database.dart';
import 'package:ypa/util/string_color.dart';

class GoalCard extends StatefulWidget {
  final int id;
  final String name;
  final int progress;
  final DateTime dueDate;
  const GoalCard({
    required this.id,
    required this.name,
    required this.progress,
    required this.dueDate,
    Key? key,
  }) : super(key: key);

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  String name = "";
  int progress = 0;
  DateTime dueDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.name = widget.name;
    this.progress = widget.progress;
    this.dueDate = widget.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Goal>(
      stream: GetIt.I<LocalDatabase>().getGoalByIdStream(widget.id),
      builder: (context, snapshot) {
        // error
        if(snapshot.hasError){
          return Center(child: Text("Something went wrong"),);
        }
        // Future build ran for the first time and Loading
        if(snapshot.connectionState != ConnectionState.none && !snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration: BoxDecoration(
            color: stringColor("F5EFE6"),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
            _TopHalf(name: snapshot.data!.title, dueDate: snapshot.data!.dueDate),
              _BottomHalf(progress: snapshot.data!.progress),
            ],
          ),
        );
      }
    );
  }
}

class _TopHalf extends StatelessWidget {
  final String name;
  final DateTime dueDate;
  const _TopHalf({required this.name, required this.dueDate, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final dDay = dueDate.difference(today).inDays;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            height: 25,
            decoration: BoxDecoration(
              color: checkStateColor(dDay), // change by its dueDate
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Center(
                child: Text(
                  dDayString(dDay),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  dDayString(int days) {
    if (days == 0) {
      return "D-Day";
    }
    if (days < 0) {
      return "D+${(days * -1).toString()}";
    }
    if (days > 0) return "D-${days.toString()}";
  }

  // check state
  checkStateColor(int dDay) {
    if (dDay <= 0) {
      return Colors.red;
    }
    if (dDay <= 7) {
      return Colors.orange;
    }
    if (dDay > 7) {
      return Colors.green;
    }
  }
}

class _BottomHalf extends StatelessWidget {
  final int progress;
  const _BottomHalf({
    required this.progress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0),
      child: StepProgressIndicator(
        totalSteps: 20,
        currentStep: (progress / 5).toInt(),
        size: 20,
        selectedColor: chooseColor(progress),
        unselectedColor: Colors.transparent,
        roundedEdges: Radius.circular(10),
      ),
    );
  }

  chooseColor(int progress) {
    final Color chosenColor;
    if (progress <= 25) {
      return chosenColor = Colors.red;
    }
    if (progress <= 50) {
      return chosenColor = Colors.orange;
    }
    if (progress <= 75) {
      return chosenColor = Colors.yellow;
    } else {
      return chosenColor = Colors.green;
    }
  }
}
