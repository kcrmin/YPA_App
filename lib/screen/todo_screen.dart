import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:ypa/component/calendar_bar.dart';
import 'package:ypa/component/todo_item.dart';
import 'dart:developer';
import 'package:ypa/database/drift_database.dart';
import 'package:get_it/get_it.dart';
import '../component/todo_card.dart';
import '../util/string_color.dart';
import 'mood_screen.dart';

class ToDoScreen extends StatefulWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  const ToDoScreen({
    required this.selectedDay,
    required this.focusedDay,
    Key? key,
  }) : super(key: key);

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.selectedDay = widget.selectedDay;
    this.focusedDay = widget.focusedDay;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          toolbarHeight: 90,
          backgroundColor: stringColor("AEBDCA"),
          title: const Text(
            'To Do List',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 32.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          CalendarBar(
            selectedDay: selectedDay,
            focusedDay: focusedDay,
            onDaySelected: onDaySelected,
            onPageChanged: onPageChanged(focusedDay),
          ),
          Expanded(
            child: StreamBuilder<List<Todo>>(
              key: ObjectKey(selectedDay),
              stream: GetIt.I<LocalDatabase>().getTodoByDate(selectedDay),
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
                return snapshot.hasData && snapshot.data!.isEmpty == false
                    ? ListView.separated(
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 1);
                        },
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: ObjectKey(snapshot.data![index].id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (DismissDirection direction) {
                              GetIt.I<LocalDatabase>()
                                  .removeTodoById(snapshot.data![index].id);
                            },
                            child: TodoContainer(
                              currentId: snapshot.data![index].id,
                              checked: snapshot.data![index].completed,
                              content: snapshot.data![index].title,
                              selectedDay: selectedDay,
                            ),
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Add To-Do", style: TextStyle(
                            color: Colors.grey,
                            fontSize: 24.0,
                          ),),
                          SizedBox(height: 130,)
                        ]
                      );
              },
            ),
          )
        ],
      ),
      // =====================================================================
      floatingActionButton: FloatingActionButton(
          backgroundColor: stringColor("AEBDCA"),
          child: Text(
            String.fromCharCode(Icons.add.codePoint),
            style: TextStyle(
              inherit: false,
              color: Colors.white,
              fontSize: 27.0,
              fontWeight: FontWeight.w800,
              fontFamily: Icons.add.fontFamily,
              package: Icons.add.fontPackage,
            ),
          ),
          onPressed: () async {
            final todo = await showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: stringColor("F5EFE6"),
                  title: const Text('New To Do'),
                  content: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter your Todo',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF7895B2)),
                      ),
                    ),
                    onSubmitted: (value) {
                      Navigator.of(context).pop(value);
                    },
                    cursorColor: Color(0xFF7895B2),
                  ),
                );
              },
            );
            if (todo != null) {
              addTodo(todo!);
            }
          }),
    );
    // ====================================================================
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;
    });
  }

  onPageChanged(DateTime focusedDay) {
    setState(() {
      this.focusedDay = focusedDay;
    });
  }

  addTodo(String todo) {
    print("create");
    setState(() {
      GetIt.I<LocalDatabase>().createTodo(TodosCompanion(
        title: Value(todo!),
        date: Value(selectedDay),
        completed: Value(false),
      ));
    });
  }
}
