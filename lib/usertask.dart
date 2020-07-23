import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class UserTask{
  String email;
  String project;
  String task;
  int hours;
  DateTime date;
  String leave;
  String application;
  String inTime;
  String outTime;
  DocumentReference reference;


  UserTask(String email, String project, String task, int hours, DateTime date, String leave, String application, String inTime, String outTime) {
    this.email = email;
    this.project  = project;
    this.task = task;
    this.hours = hours;
    this.date = date;
    this.leave =  leave;
    this.application = application;
    this.inTime = inTime;
    this.outTime = outTime;

  }


  UserTask.fromMap(Map<String, dynamic> map, {this.reference}) {
    email = map["email"];
    project = map["project"];
    task = map["task"];
    hours = map["hours"];
    date = map["date"];
    leave = map["leave"];
    application = map["application"];
    inTime = map["inTime"];
    outTime = map["outTime"];

  }

  UserTask.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {
      'email': email,
      'project': project,
      'task': task,
      'hours': hours,
      'date': date,
      'leave': leave,
      'application': application,
      'inTime': inTime,
      'outTime':outTime

    };
  }

}

