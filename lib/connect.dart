import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'event.dart';


class Access{
  final DatabaseReference _eventref =
  FirebaseDatabase.instance.reference().child('events');

  void saveEvent (Event event){
    _eventref.push().set(event.toJson());
  }

}