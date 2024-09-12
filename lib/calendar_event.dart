//
// Calendar Event
//


import 'package:flutter/material.dart';

import 'event_list.dart';


class CalendarEvent {
  final String title;

  const CalendarEvent(this.title);

  @override
  String toString() => title;
}


class CalendarEventWidget extends StatefulWidget {

  final Event event;

  const CalendarEventWidget(this.event, {super.key});

  @override
  _CalendarEventWidget createState() => _CalendarEventWidget(event);
}

class _CalendarEventWidget extends State<CalendarEventWidget> {

  final Event event;

  _CalendarEventWidget(this.event);

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
      child: ListTile(
          title: Text(event.title)
            )

    );
  }
}