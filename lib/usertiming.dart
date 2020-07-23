import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class UserTiming {
  String inTime;
  String outTime;
  DateTime date;
  DocumentReference reference;


  UserTiming(String inTime, String outTime, DateTime date) {
     this.inTime = inTime;
     this.outTime = outTime;
     this.date = date;
  }


  UserTiming.fromMap(Map<String, dynamic> map, {this.reference}) {
    inTime = map["inTime"];
    outTime = map["outTime"];
    date = map["date"];


  }

  UserTiming.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {
      'inTime': inTime,
      'outTime': outTime,
      'date': date,

    };
  }

}

