import 'package:drift/drift.dart';

class MoodColors extends Table {
  // PRIMARY KEY
  IntColumn get id => integer().autoIncrement()();

  // Color
  TextColumn get color => text()();
}