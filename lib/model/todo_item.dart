import 'package:drift/drift.dart';

class Todos extends Table {
  // PRIMARY KEY
  IntColumn get id => integer().autoIncrement()();

  // Content
  TextColumn get title => text()();

  // Date
  DateTimeColumn get date => dateTime()();

  // Completed
  BoolColumn get completed => boolean()();
}