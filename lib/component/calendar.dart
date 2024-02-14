//import 'package:calendar_test/const/colors.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ypa/model/mood_with_color.dart';
import 'package:ypa/util/string_color.dart';

import '../database/drift_database.dart';

class Calendar extends StatefulWidget {
  //final List<String> todos;
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final OnDaySelected? onDaySelected;
  final onPageChanged;
  //final List<todoItem> todoList;

  Calendar({
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    required this.onPageChanged,
    //required this.todoList,
    Key? key,
  }) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    final defaultBoxDeco = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(6.0),
    );
    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );
    return TableCalendar(
      daysOfWeekHeight: 50,
      focusedDay: widget.focusedDay,
      firstDay: DateTime(1800),
      lastDay: DateTime(3000),
      headerVisible: true,
      headerStyle: const HeaderStyle(
          formatButtonVisible: false, // remove 2 weeks button
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 32.0,
            color: Colors.white,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFAEBDCA),
          )),

      // custom builder
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, todos) {
          return StreamBuilder<MoodWithColor>(
              stream: GetIt.I<LocalDatabase>().getMoodWithColorByDate(day),
              builder: (context, snapshot) {
                return Container(
                  width: 20,
                  height: 10,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    color: (snapshot.hasData &&
                            day.toUtc().month ==
                                widget.focusedDay.toUtc().month)
                        ? stringColor(snapshot.data!.moodColor.color)
                        : Colors.transparent,

                    //retrieve color of a specific day for moodMap, do not display color for not focused month or when key(date) not contained in the map
                    // color: stringColor(GetIt.I<LocalDatabase>().getMoodWithColorByDate(day).map((event) => event.moodColor.color).toString()),
                    // (day.month == focusedDay.month &&
                    //         GetIt.I<LocalDatabase>().getMoodWithColorByDate(day) !=
                    //             null)
                    //     ? Color(
                    //         int.parse(
                    //           "FF${GetIt.I<LocalDatabase>().getMoodWithColorByDate(day).map((event) => event.moodColor.color).toString()}",
                    //           radix: 16,
                    //         ),
                    //       )
                    //     : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              });
        },
      ),

      // calendar style customize
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        markersAlignment: Alignment.bottomCenter,

        todayDecoration: BoxDecoration(
            color: stringColor("7895B2"),
            borderRadius: BorderRadius.circular(6.0)),

        // DATE BOX DECORATION
        // weekdays
        defaultDecoration: defaultBoxDeco,
        // weekends
        weekendDecoration: defaultBoxDeco,
        // selected date
        selectedDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: Colors.deepPurple,
            width: 1.0,
          ),
        ),

        // DATE TEXT STYLES

        // weekday text
        defaultTextStyle: defaultTextStyle,
        // weekend text
        weekendTextStyle: defaultTextStyle,
        // selected date
        selectedTextStyle: defaultTextStyle.copyWith(
          color: Colors.deepPurple,
        ),

        // error
        // [problem] outside dates are set as circular shape with animation
        // [solution] make ou®tside shape to rectangle
        outsideDecoration: const BoxDecoration(
          shape: BoxShape.rectangle,
        ),
        // [problem] page doesn't move to the date selected outside
        // [solution] change focusedDay
      ),

      // store input data of date selected
      onDaySelected: widget.onDaySelected,
      onPageChanged: widget.onPageChanged,

      // enable to select date and display
      selectedDayPredicate: (DateTime day) {
        if (widget.selectedDay == null) {
          return false;
        }

        return day.year == widget.selectedDay!.year &&
            day.month == widget.selectedDay!.month &&
            day.day == widget.selectedDay!.day;
      },
    );
  }
}
