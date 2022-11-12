import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:validators/validators.dart' as validator;

class Event{

  String participant;
  // final List<String> part = [];
  // String email;
  DateTime start;
  DateTime end;
  Color backgroundcolor =Colors.green;

  Event({
    required this.participant,
    // required this.email,
    // this.participant2 ='' ,
    required this.start,
    required this.end,
    this.backgroundcolor = Colors.green,
  });

  Event.fromJson(Map<dynamic,dynamic> json)
      : start = DateTime.parse(json['start_time'] as String),
        end = DateTime.parse(json['end_time'] as String),
        participant = json['participant'] as String;

  Map<dynamic,dynamic> toJson() => <dynamic,dynamic>{
    'start_time': start.toString(),
    'end_time' : end.toString(),
    'participant' : participant
  };
}



