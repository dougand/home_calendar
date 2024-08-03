
//import 'dart:html';
//import 'dart:ui';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';




class Event {

  String title = '';
  String details = '';

  DateTime date = DateTime.now();

  Color colour = Colors.blue;


  Event(this.title,this.details, this.date, this.colour);

  Event.blank() {
    title="";
    details="";
    colour = Colors.blue;
    date = DateTime.now();
  }

  // Convert an instance of this class to a Map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'details': details,
      'date': date.toString(),
      'colour': colour.toString(),
    };
  }


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

    events = <Event>[];

    print('EventList initialised');
    loadEventsFromFile();
  }



  List<Event>? events;


  void addEvent( Event ev )
  {
    events?.add(ev);
    debugPrint('EventList count = ${events?.length.toString()}');

    saveEventsToFile();

    loadEventsFromFile();
  }



  Future<File> saveEventsToFile() async {
    final file = await _localFile;

    List<String>? jsonStringList = events?.map((ev) => jsonEncode(ev.toJson())).toList();

    // Write the file
    return file.writeAsString(jsonStringList?.join() as String);
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



