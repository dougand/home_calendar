// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:home_calendar/calendar_event.dart';
import 'package:home_calendar/edit_event.dart';
import 'package:home_calendar/utils.dart';
import 'package:home_calendar/event_list.dart';
import 'package:table_calendar/table_calendar.dart';


void main() {
  //initializeDateFormatting().then((_) => runApp(MyApp()));
  runApp(const MyApp());
//  runApp(const ColorPickerDemo());
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

  //CalendarData calData = CalendarData();

  void refreshEvents() {
    debugPrint('refreshEvents');
    setState(() {

    });
  }

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
    List<Event> theList = EventList().events;

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
            onPressed: () =>
            {
              createEvent()
            },
          ),
          const SizedBox(height: 2.0),

          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: theList.length,
              itemBuilder: (context, index) {
                var event = theList[index];
                return
                  Dismissible(
            
                      key: Key(event.id),
                      onDismissed: (direction) {
                        print('dismissed');
                      },

                      background: slideRightBackground(),
                      secondaryBackground: slideLeftBackground(),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          //  Swipe to delete
                          final bool res = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                      "Are you sure you want to delete this item?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        // TODO: Delete the item from DB etc..
                                        setState(() {
                                        //todo:  itemsList.removeAt(index);
                                        });
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                );
                              });
                          return res;
                        } else {
                          //  Swipe to edit
                          // TODO: Navigate to edit page;
                          Event ev = theList[index];
                          print("clicked ${ev.toString()}");
                          editEvent(ev);

                        }
                      },
                      child: InkWell(
                          onTap: () {
                            // Tap to edit
                            Event ev = theList[index];
                            print("clicked ${ev.toString()}");
                            editEvent(ev);
                          },
                          child: CalendarEventWidget(event)));
              },
            ),
          ),


          // for( var event in theList )
          //   Dismissible(
          //       key: Key(event.id),
          //       onDismissed: (direction){
          //         print('dismissed');
          //       },
          //       child: CalendarEventWidget(event))

          //        theList.map((event) => new CalendarEventWidget(event));

          //         CalendarEventWidget(theList[0]),
          //         CalendarEventWidget(theList[1]),
          //         CalendarEventWidget(theList[2]),
        ],
      ),
    );
  }

  Future createEvent() async {
    Event newEvent = Event.blank();
    newEvent.title = 'try this';

    var result = await showDialog(
      context: context,
      builder: (context) => EditEventForm(event: newEvent, isNew: true),
    );

    if (result is Event) {
      print("New Event created:");
      print(result.toJson());
      EventList().addEvent(result);
      refreshEvents();
    }
    else {
      print("-- Cancelled --");
    }
  }


  Future editEvent( Event ev ) async {

    var result = await showDialog(
      context: context,
      builder: (context) => EditEventForm(event: ev, isNew: false),
    );

    if (result is Event) {
      print("New Event created:");
      print(result.toJson());
      EventList().addEvent(result);
      refreshEvents();
    }
    else {
      print("-- Cancelled --");
    }
  }



  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }


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
