
import 'dart:ui';

import 'package:flutter/material.dart';

class Event {

  String title = '';
  String description = '';

  DateTime startTime = DateTime.now();

  Color colour = Colors.blue;
}


class EventList {

  List<Event>? events;

}



