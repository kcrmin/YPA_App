import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ypa/database/drift_database.dart';

class TodoContainer extends StatelessWidget {
  final int currentId;
  final bool checked;
  final String content;
  final DateTime selectedDay;
  const TodoContainer({
    required this.currentId,
    required this.checked,
    required this.content,
    required this.selectedDay,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFF5EFE6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
      child: CheckboxListTile(
        checkboxShape: const CircleBorder(eccentricity: 0.9),
        contentPadding: const EdgeInsets.all(3),
        checkColor: Colors.white,
        title: Text(content),
        value: checked,
        onChanged: onCheckBoxTap,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  onCheckBoxTap(bool? val) {
    if (val != null) {
      val = !val;
      GetIt.I<LocalDatabase>().updateTodoById(
        currentId,
        TodosCompanion(
          date: Value(selectedDay),
          title: Value(content),
          completed: Value(!val),
        ),
      );
    }
  }
}
