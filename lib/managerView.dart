import 'package:flutter/material.dart';
import 'home.dart';
import 'managerEmployeeData.dart';
import 'onboarding.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
class managerView extends StatefulWidget {
  @override
  String name;
  String designation;
  String email;
  Set<String> projects;
  List<int> hourList;
  managerView(String name, String designation, String email, Set<String> projects, List<int> hourList)
  {
    this.name = name;
    this.designation = designation;
    this.email = email;
    this.projects = projects;
    this.hourList = hourList;
  }

  _managerViewState createState() => _managerViewState();
}

class _managerViewState extends State<managerView> {
  @override

  String filePath;
  List<String> paths = [];

  String username = "blpcleanalerts@gmail.com";
  String password = "qwerty@1234";
 List<String> employeeList = [];
  
  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/data.csv';
    return File('$path/data.csv').create();
  }

  getPost() async
  {
     QuerySnapshot qn = await Firestore.instance.collection("todo").document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").where("reportingMail", isEqualTo: widget.email).getDocuments();
     for(int i=0;i<qn.documents.length;i++)
       {
         employeeList.add(qn.documents[i].data['email']);
       }

     getCsv();
  }

  getCsv() async {

    List<List<dynamic>> rows = List<List<dynamic>>();



    rows.add([
      "Email",
      "Product",
      "Customer",
      "Hours",
      "Date",
    ]);

    for(int i=0;i<employeeList.length;i++)
      {
      QuerySnapshot qn =   await Firestore.instance.collection("todo").document("Kbf1V676TEjD7E2sZIbO").collection("task")
            .where("email", isEqualTo: employeeList[i]).where("leave", isEqualTo: "no").getDocuments();

      if(qn != null)
        {
          for(int i=0;i<qn.documents.length;i++)
            {
              List<dynamic> row = List<dynamic>();
              row.add(qn.documents[i].data['email']);
              row.add(qn.documents[i].data['application']);
              row.add(qn.documents[i].data['project']);
              row.add(qn.documents[i].data['hours'].toString());
              row.add(qn.documents[i].data['date'].toString());

              rows.add(row);
            }
        }
      }

      File f = await _localFile;

      String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv);
      sendEmail();
    }


  void sendEmail()  async
  {
         print("ya aaya");

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Daily Sheet')
      ..recipients.add(widget.email)

      ..subject = 'Csv'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..attachments.add(FileAttachment(new File(filePath)));



    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());


    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //title: new Text("Warning: "),
          content: new Text("csv sent"),

          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],

        );
      },
    );
  }



  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: ()
        {

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Onboarding(widget.name, widget.designation, widget.email)));

        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:20),
          child: Container(
          child: Column(
            children: <Widget>[
              new SizedBox(
                height: 100,
              ),

              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.shade200,
                            offset: Offset(2, 4),
                            blurRadius: 5,
                            spreadRadius: 2)
                      ],
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.lightBlue[300], Colors.lightBlue[700]])),
                  child: Text(
                    'Personal ',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),

                onTap: ()
                {

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        Home(widget.name, widget.designation,
                            widget.email, widget.projects, widget.hourList)),
                  );


                  //addUserLate();
                },
              ),

              new SizedBox(
                height: 100,
              ),

              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.shade200,
                            offset: Offset(2, 4),
                            blurRadius: 5,
                            spreadRadius: 2)
                      ],
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.lightBlue[300], Colors.lightBlue[700]])),
                  child: Text(
                    'Employees Data',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),

                onTap: ()
                {

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        employeeData(widget.name, widget.designation,widget.email, widget.projects, widget.hourList)),
                  );


                  //addUserLate();
                },
              ),


              new SizedBox(
                height: 100,
              ),

              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.shade200,
                            offset: Offset(2, 4),
                            blurRadius: 5,
                            spreadRadius: 2)
                      ],
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.lightBlue[300], Colors.lightBlue[700]])),
                  child: Text(
                    'Download csv',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),

                onTap: ()
                {


                  getPost();
                  //addUserLate();
                },
              ),


            ],
          ),
          ),
        ),
      ),
    );
  }
}
