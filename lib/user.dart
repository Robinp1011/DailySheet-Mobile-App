import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class User {
    String email;
    String password;
    String designation;
    String name;
    String reportingMail;
  DocumentReference reference;


  User(String email, String password, String designation, String name, String reportingMail) {
    this.email = email;
    this.password = password;
    this.designation = designation;
    this.name = name;
    this.reportingMail = reportingMail;
  }


  User.fromMap(Map<String, dynamic> map, {this.reference}) {
    email = map["email"];
    password = map["password"];
    designation = map["designation"];
    name = map["name"];
    reportingMail = map["reportingMail"];

  }

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {
      'email': email,
      'password': password,
      'designation': designation,
      'name':name,
      'reportingMail':reportingMail

    };
  }

}

