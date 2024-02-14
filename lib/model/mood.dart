import 'package:drift/drift.dart';

class Moods extends Table {
  // PRIMARY KEY
  IntColumn get id => integer().autoIncrement()();

  // Date
  DateTimeColumn get date => dateTime()();

  // Color
  IntColumn get colorId => integer()();

  @override
  Set<Column> get primaryKey => {id};
}