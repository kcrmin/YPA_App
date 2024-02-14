import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get_it/get_it.dart';
import 'package:ypa/database/drift_database.dart';
import 'package:ypa/util/string_color.dart';

typedef ColorSetter = void Function(int id);

class MoodPieChart extends StatelessWidget {
  final double radius;
  final double excited_value;
  final double sad_value;
  final double calm_value;
  final double happy_value;
  final double frustrated_value;
  final double angry_value;
  final ColorSetter colorSetter;
  final DateTime selectedDay;
  final onDoubleTap;
  int? selectedColor;

  MoodPieChart({
    required this.radius,
    required this.excited_value,
    required this.sad_value,
    required this.calm_value,
    required this.happy_value,
    required this.frustrated_value,
    required this.angry_value,
    required this.colorSetter,
    required this.selectedDay,
    required this.onDoubleTap,
    this.selectedColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 40),
              _IndicatorList(),
              Expanded(
                child: _Chart(
                  radius: radius,
                  excited_value: excited_value,
                  sad_value: sad_value,
                  calm_value: calm_value,
                  happy_value: happy_value,
                  frustrated_value: frustrated_value,
                  angry_value: angry_value,
                ),
              ),
            ],
          ),
          FutureBuilder<List<MoodColor>>(
              future: GetIt.I<LocalDatabase>().getColors(),
              builder: (context, snapshot) {
                return _MoodPicker(
                  colors: snapshot.hasData ? snapshot.data! : [],
                  colorSetter: colorSetter,
                  selectedColor: selectedColor,
                  selectedDay: selectedDay,
                  onDoubleTap: onDoubleTap,
                );
              }),
        ],
      ),
    );
  }
}

class _MoodPicker extends StatelessWidget {
  final List<MoodColor> colors;
  final colorSetter;
  int? selectedColor;
  final onDoubleTap;
  final DateTime selectedDay;
  _MoodPicker({
    required this.colors,
    required this.colorSetter,
    this.selectedColor,
    required this.selectedDay,
    required this.onDoubleTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 9),
          Text(
            "Pick Your Color",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Divider(),
          Wrap(
            spacing: 20,
            runSpacing: 16,
            children: colors
                .map((e) => GestureDetector(
                      onDoubleTap: onDoubleTap,
                      onTap: () {
                        colorSetter(e.id);
                      },
                      child: renderColor(
                          stringColor(e.color), selectedColor == e.id),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget renderColor(Color color, bool selected) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            width: selected ? 3.0 : 0,
            color: Colors.black38,
          )),
    );
  }
}

class _Chart extends StatelessWidget {
  final double radius;
  final double excited_value;
  final double sad_value;
  final double calm_value;
  final double happy_value;
  final double frustrated_value;
  final double angry_value;

  const _Chart(
      {required this.radius,
      required this.excited_value,
      required this.sad_value,
      required this.calm_value,
      required this.happy_value,
      required this.frustrated_value,
      required this.angry_value,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return radius == 0
        ? Align(
            alignment: Alignment.center,
            child: Text(
              "How was your day?",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ))
        : Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: radius == 0 ? 100 : 197,
              child: PieChart(PieChartData(
                sections: showingSections(),
                centerSpaceRadius: 35,
                startDegreeOffset: 270,
              )),
            ),
          );
  }

  List<PieChartSectionData> showingSections() {
    final PieChartSectionData defaultPieChart = PieChartSectionData(
      // Basic Settings
      radius: radius,
      titlePositionPercentageOffset: 0.5,
      titleStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );

    return List.generate(6, (i) {
      switch (i) {
        case 0:
          return defaultPieChart.copyWith(
            color: Colors.pink,
            value: excited_value,
            title: "${excited_value.toStringAsFixed(0)}%",
          );
        case 1:
          return defaultPieChart.copyWith(
            color: Colors.indigoAccent,
            value: sad_value,
            title: "${sad_value.toStringAsFixed(0)}%",
          );
        case 2:
          return defaultPieChart.copyWith(
            color: Colors.cyan,
            value: calm_value,
            title: "${calm_value.toStringAsFixed(0)}%",
          );
        case 3:
          return defaultPieChart.copyWith(
            color: Colors.green,
            value: happy_value,
            title: "${happy_value.toStringAsFixed(0)}%",
          );
        case 4:
          return defaultPieChart.copyWith(
            color: Colors.orange,
            value: frustrated_value,
            title: "${frustrated_value.toStringAsFixed(0)}%",
          );
        case 5:
          return defaultPieChart.copyWith(
            color: Colors.red,
            value: angry_value,
            title: "${angry_value.toStringAsFixed(0)}%",
          );
        default:
          throw Error();
      }
    });
  }
}

class _IndicatorList extends StatelessWidget {
  const _IndicatorList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Indicator(color: Colors.red, title: "Angry"),
          _Indicator(color: Colors.orange, title: "Frustrated"),
          _Indicator(color: Colors.green, title: "Happy"),
          _Indicator(color: Colors.cyan, title: "Calm"),
          _Indicator(color: Colors.indigoAccent, title: "Sad"),
          _Indicator(color: Colors.pink, title: "Excited")
        ],
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String title;
  const _Indicator({required this.color, required this.title, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 15,
            height: 15,
            color: color,
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
