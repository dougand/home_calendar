
//import 'dart:html';
//import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';




class Event {

  String title = '';
  String description = '';

  DateTime startTime = DateTime.now();

  Color colour = Colors.blue;
}


class EventList {

  static final EventList _instance = EventList._internal();

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory EventList() {
  return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  EventList._internal() {
  // initialization logic
    print('EventList initialised');
    loadEventsFromFile();
  }



  List<Event>? events;


  Future<File> saveEventsToFile() async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('This is a test');
  }


  Future<int> loadEventsFromFile() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      print('loadEventsFromFile() $contents');

      return 1;
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }


  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

}



