//
// Calendar Event
//


import 'package:flutter/material.dart';


class CalendarEvent {
  final String title;

  const CalendarEvent(this.title);

  @override
  String toString() => title;
}


class CalendarEventWidget extends StatefulWidget {
  @override
  _CalendarEventWidget createState() => _CalendarEventWidget();
}

class _CalendarEventWidget extends State<CalendarEventWidget> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text('Cal Event')
    );
  }
}