// database/drift_database.dart
// drift main layout
import 'dart:io';

// DB location package
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:ypa/model/mood_with_color.dart';

// models modify
import '../model/goal.dart';
import '../model/mood.dart';
import '../model/todo_item.dart';
import 'package:ypa/model/mood_color.dart';

part 'drift_database.g.dart'; // error for now

@DriftDatabase(
  tables: [
    Goals, // modify
    Moods, // modify
    Todos, // modify
    MoodColors,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // manage schema version

  /// create
  Future<int> createGoal(GoalsCompanion data) => into(goals)
      .insert(data); // Model/Table/Class in lowercase on first letter

  Future<int> createMood(MoodsCompanion data) => into(moods)
      .insert(data); // Model/Table/Class in lowercase on first letter

  Future<int> createTodo(TodosCompanion data) => into(todos)
      .insert(data); // Model/Table/Class in lowercase on first letter

  Future<int> createColor(MoodColorsCompanion data) =>
      into(moodColors).insert(data);

  /// select
  // select all
  Stream<List<Mood>> getMoods() => select(moods).watch();

  Stream<List<Goal>> getGoals() =>
  (select(goals)..orderBy([(t) => OrderingTerm.asc(t.dueDate)])).watch();

  Future<List<Todo>> getTodos() => select(todos).get();

  Stream<List<Todo>> getTodoByDate(DateTime day) =>
      (select(todos)..where((tbl) => tbl.date.equals(day))..orderBy([(t) => OrderingTerm.desc(t.completed)])).watch();

  Future<List<MoodColor>> getColors() => select(moodColors).get();

  // select by ID
  Future<Mood> getMoodByDate(DateTime day) =>
      (select(moods)..where((tbl) => tbl.date.equals(day))).getSingle();

  Future<List<Mood>> getMoodByFocusedDay(DateTime day) =>
      (select(moods)..where((tbl) => tbl.date.month.equals(day.month))).get();


  Future<Goal> getGoalByIdFuture(int id) =>
      (select(goals)..where((tbl) => tbl.id.equals(id))).getSingle();

  Stream<Goal> getGoalByIdStream(int id) =>
      (select(goals)..where((tbl) => tbl.id.equals(id))).watchSingle();

  Future<Todo> getTodoById(int id) =>
      (select(todos)..where((tbl) => tbl.id.equals(id))).getSingle();

  // Fake
  Stream<Goal> getGoalForFake() =>
      (select(goals)..where((tbl) => tbl.id.equals(-1))).watchSingle();

  // join query
  Stream<List<MoodWithColor>> getMoodWithColor() {
    final query = select(moods).join([
      innerJoin(moodColors,
          moodColors.id.equalsExp(moods.id)) // columnName is FK column name
    ]);

    // rows = all data, row = each data
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => MoodWithColor(
                  mood: row.readTable(moods),
                  moodColor: row.readTable(moodColors),
                ),
              )
              .toList(),
        );
  }

  Stream<MoodWithColor> getMoodWithColorByDate(DateTime date) {
    final query = select(moods).join([
      innerJoin(
          moodColors,
          moodColors.id
              .equalsExp(moods.colorId)) // columnName is FK column name
    ]);

    query.where(moods.date.equals(date));

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => MoodWithColor(
                  mood: row.readTable(moods),
                  moodColor: row.readTable(moodColors),
                ),
              )
              .toList()[0],
        );
  }

  /// Update
  Future<int> updateMoodByDate(DateTime day, MoodsCompanion data) =>
      (update(moods)..where((tbl) => tbl.date.equals(day))).write(data);

  Future<int> updateGoalById(int id, GoalsCompanion data) =>
      (update(goals)..where((tbl) => tbl.id.equals(id))).write(data);

  Future<int> updateTodoById(int id, TodosCompanion data) =>
      (update(todos)..where((tbl) => tbl.id.equals(id))).write(data);

  /// Remove
  removeMoodByDate(DateTime day) =>
      (delete(moods)..where((tbl) => tbl.date.equals(day))).go();

  removeGoalById(int id) =>
      (delete(goals)..where((tbl) => tbl.id.equals(id))).go();

  removeTodoById(int id) =>
      (delete(todos)..where((tbl) => tbl.id.equals(id))).go();
}

// set DB location
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder =
        await getApplicationDocumentsDirectory(); // bring application directory assigned by OS
    final file = File(p.join(dbFolder.path,
        'db.sqlite')); // Import library 'dart.io'. // set file name as db.sqlite
    return NativeDatabase(file);
  });
}
