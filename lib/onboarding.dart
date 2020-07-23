import 'package:flutter/material.dart';

import 'util.dart';
import 'empty.dart';
import 'loginPage.dart';
import 'profilePage.dart';
import 'managerView.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minimize_app/minimize_app.dart';
import 'package:connectivity/connectivity.dart';

class Onboarding extends StatefulWidget {

  String name;
  String designation;
  String email;
  Onboarding(String name, String designation, String email)
  {
    this.name = name;
    this.designation = designation;
    this.email = email;
  }

  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override

  Set<String> projects ={};
  List<int> hourList =[];
  List<int> taskCount = [];

   void initState()
   {
     super.initState();
    getProject();

   }
  getProject() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("task").where("email", isEqualTo: widget.email).getDocuments();
    for(int i=0;i<qn.documents.length;i++)
    {
      projects.add(qn.documents[i].data['project']);
    }

    print(projects);
    gethours(projects);
    //     addList(str);
  }

  gethours(Set<String> projects) async
  {
    for(int i=0;i<projects.length;i++) {
      var firestore = Firestore.instance;
      QuerySnapshot qn = await firestore.collection("todo").document(
          "Kbf1V676TEjD7E2sZIbO").collection("task").where(
          "email", isEqualTo: widget.email)
          .where("project", isEqualTo: projects.elementAt(i))
          .getDocuments();
      int hours = 0;
      for (int i = 0; i < qn.documents.length; i++) {
        hours = hours + qn.documents[i].data['hours'];
      }
      hourList.add(hours);
      taskCount.add(qn.documents.length);
    }
    print(hourList);


  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:  ()
      {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Onboarding(widget.name, widget.designation, widget.email)));
      },
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(

          decoration: BoxDecoration(
              image: DecorationImage(
                //  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),

                  image: AssetImage("assets/images/corona.png"), fit: BoxFit.cover)),


          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Column(
                  children: <Widget>[
                      new SizedBox(
                        height:MediaQuery.of(context).size.height/1.14,
                      ),
                    GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),

                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.white, Colors.white])),
                        child: Text(
                          'Get Started',
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                      ),

                      onTap: ()   async
                      {
                        if(widget.designation == 'Senior Management')
                        {

                          var connectivityResult = await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                            // I am connected to a mobile network.

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => managerView(widget.name, widget.designation, widget.email, projects, hourList)),
                            );

                          }

                          else
                          {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  //title: new Text("Warning: "),
                                  content: new Text("You are not connected to Internet."),

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


                        }
                        else {


                          var connectivityResult = await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                            // I am connected to a mobile network.

                         if(widget.designation == "Employee") {
                           Navigator.pushReplacement(
                             context,
                             MaterialPageRoute(builder: (context) =>
                                 Home(widget.name, widget.designation,
                                     widget.email, projects, hourList)),
                           );
                         }

                         else
                           {
                             Navigator.pushReplacement(
                               context,
                               MaterialPageRoute(builder: (context) => managerView(widget.name, widget.designation, widget.email, projects, hourList)),
                             );
                           }

                          }

                          else
                          {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  //title: new Text("Warning: "),
                                  content: new Text("You are not connected to Internet."),

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


                          }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
