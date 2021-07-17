import 'package:flutter/material.dart';

class Task{

  int id;
  String title;
  DateTime date;
  TimeOfDay time;
  String priority;
  int status;

  Task({this.title,this.date,this.time,this.priority, this.status});
  Task.withId({this.id,this.title,this.date,this.time,this.priority, this.status});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
     if (id != null) {
     map['id'] = id;
   }
    map['id'] = id;
    map['title'] = title;
    map['date'] = date.toIso8601String();
    map['time'] = time;
    map['priority'] = priority;
    map['status'] = status;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map){
    return Task.withId(
      id: map['id'], 
      title: map['title'],
      date: DateTime.parse(map['date']),
      time: map['date'],
      priority: map['priority'], 
      status: map['status']);
  }
}