import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:ypa/component/custom_text.dart';
import 'package:ypa/database/drift_database.dart';

class GoalForm extends StatefulWidget {
  final int? selectedGoalId;

  const GoalForm({
    this.selectedGoalId,
    Key? key,
  }) : super(key: key);

  @override
  State<GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  final GlobalKey<FormState> formKey = GlobalKey();
  int? selectedGoalId;
  String? title;
  int progress = 0;
  DateTime dueDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Goal>(
        future: widget.selectedGoalId == null
            ? null
            : GetIt.I<LocalDatabase>()
                .getGoalByIdFuture(widget.selectedGoalId!),
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
          // When there's Future value but variables are never been set
          if (snapshot.hasData && title == null) {
            title = snapshot.data!.title;
            progress = snapshot.data!.progress;
            dueDate = snapshot.data!.dueDate;
            selectedGoalId = snapshot.data!.id;
          }
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              // border: Border.all(color: Colors.black, width: 1.0),
              color: Colors.white,
            ),
            height: 300, // _Middle1 = 250 || _Middle2 = 450
            width: 350,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                    child: _Top(
                      onDateChanged: onDateChanged,
                      selectedDay: dueDate,
                      initTitle: title ?? "",
                      onTextSaved: onTextSaved,
                      formKey: formKey,
                      dueDate: dueDate,
                    ),
                  ),
                  // _Middle1(currentNum: currentNum1, percentage: percentage, onChanged: onNumChanged1),
                  _Middle2(currentNum: progress, onChanged: onNumChanged2),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                    child: _Bottom(
                      dueDate: this.dueDate,
                      progress: this.progress,
                      onConfirmPressed: onConfirmPressed,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  onTextSaved(String? val) {
    setState(() {
      this.title = val;
    });
  }

  onConfirmPressed() {
    if (widget.selectedGoalId == null && formKey.currentState!.validate()) {
      print("Create");
      formKey.currentState!.save();
      Navigator.of(context).pop();
      return GetIt.I<LocalDatabase>().createGoal(GoalsCompanion(
        title: Value(this.title!),
        dueDate: Value(this.dueDate),
        progress: Value(this.progress),
      ));
    }
    if (widget.selectedGoalId != null && formKey.currentState!.validate()) {
      print("update");
      formKey.currentState!.save();
      Navigator.of(context).pop();
      return GetIt.I<LocalDatabase>().updateGoalById(
        widget.selectedGoalId!,
        GoalsCompanion(
          title: Value(this.title!),
          dueDate: Value(this.dueDate),
          progress: Value(this.progress),
        ),
      );
    }
  }

  onDateChanged(DateTime date) {
    setState(() {
      this.dueDate = date;
    });
  }

  // _Middle2
  void onNumChanged2(int val) {
    setState(() {
      this.progress = val;
    });
  }
}

class _Top extends StatelessWidget {
  final ValueChanged<DateTime> onDateChanged;
  final DateTime selectedDay;
  final DateTime dueDate;
  final String initTitle;
  final onTextSaved;
  final formKey;
  const _Top({
    required this.onDateChanged,
    required this.selectedDay,
    required this.initTitle,
    required this.onTextSaved,
    required this.formKey,
    required this.dueDate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String selectedDayString =
        "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child:
                      CustomText(onTextSaved: onTextSaved, title: initTitle)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Due Date : ${selectedDayString}",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height / 3,
                        child: CupertinoDatePicker(
                          initialDateTime: dueDate,
                          onDateTimeChanged: onDateChanged,
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.calendar_month_rounded),
            )
          ],
        ),
      ],
    );
  }
}

class _Middle1 extends StatelessWidget {
  final double currentNum;
  final int percentage;
  final dynamic onChanged;

  const _Middle1({
    required this.currentNum,
    required this.percentage,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("${(currentNum * 100).toInt()}%"),
          ],
        ),
        Slider(
          divisions: 20,
          value: currentNum,
          onChanged: onChanged,
        ),
        // NumberPicker(
        //   minValue: 0,
        //   maxValue: 100,
        //   value: currentNum,
        //   axis: Axis.horizontal,
        //   onChanged: onChanged,
        //   itemHeight: 100,
        //   itemWidth: 100,
        //   step: 5,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     border: Border.all(color: Colors.black),
        //   ),
        // ),
      ],
    );
  }
}

class _Middle2 extends StatelessWidget {
  final int currentNum;
  final dynamic onChanged;

  const _Middle2({
    required this.currentNum,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPicker(
          minValue: 0,
          maxValue: 100,
          value: currentNum,
          axis: Axis.horizontal,
          onChanged: onChanged,
          itemHeight: 100,
          itemWidth: 100,

          step: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class _Bottom extends StatelessWidget {
  final DateTime dueDate;
  final int progress;
  final onConfirmPressed;
  const _Bottom({
    required this.dueDate,
    required this.progress,
    required this.onConfirmPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: onConfirmPressed,
              child: Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
