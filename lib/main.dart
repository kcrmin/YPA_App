import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ypa/const/custom_input_theme.dart';
import 'package:ypa/screen/classroom_screen.dart';
import 'database/drift_database.dart';
import 'package:ypa/screen/mood_screen.dart';
import 'screen/home_screen.dart';

const DEFAULT_COLORS = [
  "f44336",
  "ff9800",
  "4caf50",
  "00bcd4",
  "536dfe",
  "e91e63",
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(database);

  final colors = await database.getColors();

  if (colors.isEmpty) {
    for (String hexCode in DEFAULT_COLORS) {
      await database.createColor(MoodColorsCompanion(
        // must wrap value with Value
        color: Value(hexCode),
      ));
    }
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        inputDecorationTheme: CustomInputTheme().theme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/class': (context) => ClassroomScreen(),
        '/mood': (context) => MoodScreen(),
      },
    ),
  );
}
