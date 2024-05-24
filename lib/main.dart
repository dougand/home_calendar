// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:home_calendar/calendar_event.dart';
import 'package:home_calendar/calendar_data.dart';
import 'package:home_calendar/edit_event.dart';
//import 'package:intl/date_symbol_data_local.dart';
import 'package:home_calendar/utils.dart';
import 'package:table_calendar/table_calendar.dart';

import 'color_picker.dart';


void main() {
  //initializeDateFormatting().then((_) => runApp(MyApp()));
//    runApp(const MyApp());
  runApp(const ColorPickerDemo());
//  runApp(const FormWidgetsDemo());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableCalendar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalendarPage(),
    );
  }
}


class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPage createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  CalendarData calData = CalendarData();



  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

//      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }


  @override
  Widget build(BuildContext context) {

    List<CalendarEvent> theList = calData.testList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Calendar'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            //eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
            onDaySelected: _onDaySelected,
            //onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),

          const SizedBox(height: 2.0),

          ElevatedButton(
            child: const Text('Add Event'),
            onPressed: () => {
              editEvent()
            },
          ),
          const SizedBox(height: 2.0),

          CalendarEventWidget(theList[0]),
          CalendarEventWidget(theList[1]),
          CalendarEventWidget(theList[2]),
        ],
      ),
    );
  }

  Future editEvent() => showDialog(
      context: context,
      builder: (context) => const EditEventForm(),
  );

  //}

}




//=================================================================
//
//    OLD menu
//

// class StartPage extends StatefulWidget {
//   @override
//   _StartPageState createState() => _StartPageState();
// }
//
// class _StartPageState extends State<StartPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('TableCalendar Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               child: Text('Basics'),
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TableBasicsExample()),
//               ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Range Selection'),
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TableRangeExample()),
//               ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Events'),
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TableEventsExample()),
//               ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Multiple Selection'),
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TableMultiExample()),
//               ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Complex'),
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => TableComplexExample()),
//               ),
//             ),
//             const SizedBox(height: 20.0),
//           ],
//         ),
//       ),
//     );
//   }
// }
