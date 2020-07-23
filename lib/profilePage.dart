import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'profilePage.dart';
import 'util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'usertask.dart';
import 'user.dart';
import 'home.dart';
import 'bezierContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  @override
  String name;
  String designation;
  String email;
  Set<String> projects;
  List<int> hourList;

  MyHomePage(String name, String designation, String email,Set<String> projects,
  List<int> hourList
  )
  {
    this.name = name;
    this.designation = designation;
    this.email = email;
    this.hourList = hourList;
    this.projects = projects;
  }

  _MyHomePageState createState() => new _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
 // var names;
  String lastname="";
  String firstLetter ="";
  TextEditingController controller1 = new TextEditingController();

  bool isShowRed = false;
  bool isButton = false;
  String name="";
  Set<String> projects = {};

  void manSenPage() {
    setState(() {
      isShowRed = false;
    });
   // print(isRed3);
  }
  manSenTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, manSenPage);
  }
  noSencheck()
  {
    setState(() {
      isShowRed = true;
    });
    manSenTime();

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
   // gethours(projects);
    //     addList(str);
  }

  getName() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").where("email", isEqualTo: widget.email).getDocuments();

    setState(() {
      name = qn.documents[0].data['name'];
    });

    var  names = name.split(' ');
    if(names.length == 1)
    {
      setState(() {
        firstLetter = names[0].substring(0,1).toUpperCase();
        lastname = "";
      });

    }
    else {
      setState(() {
        firstLetter = names[0].substring(0,1).toUpperCase();
        lastname = names[1].substring(0,1).toUpperCase();
      });

      print(lastname) ;  }
  }

  void initState()
  {
    super.initState();

     getName();
    getProject();
     getControlName();


  }

 getControlName() async
 {
   var firestore = Firestore.instance;
   QuerySnapshot qn = await firestore.collection("todo").document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").where("email", isEqualTo: widget.email).getDocuments();
   controller1 = new TextEditingController(text: qn.documents[0].data['name']);
 }


  addUserLate() async{

    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("todo").document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").where("email", isEqualTo: widget.email).getDocuments();

     for(int i=0;i<qn.documents.length;i++) {
       User user = new User(widget.email, qn.documents[i].data['password'], widget.designation,controller1.text, qn.documents[i].data['reportingMail']);

       print("yha bhi aaya");

       try {
         print("aya ky ander");
         Firestore.instance.runTransaction(
               (Transaction transaction) async {
             await Firestore.instance
                 .collection("todo")
                 .document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").document(
                 qn.documents[i].documentID)
                 .setData(user.toJson());
           },
         );
       } catch (e) {
         print(e.toString());
       }
     }

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyHomePage(widget.name, widget.designation, widget.email,widget.projects, widget.hourList)));



  }



  Widget build(BuildContext context) {
    return new Scaffold(
        body: WillPopScope(
          onWillPop:  ()
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Home(widget.name, widget.designation, widget.email, widget.projects, widget.hourList)));
          },
          child: SingleChildScrollView(
            child: Container(
              height: 800,
              child: new Stack(
                children: <Widget>[

                  Center(
                    child: Column(
                      children: <Widget>[
                        new SizedBox(
                          height: MediaQuery.of(context).size.height / 5 ,
                        ),
                        Container(
                            width: 110,
                            height: 110,
                            child: FittedBox(
    fit: BoxFit.contain,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text("${firstLetter}${lastname}", style: new TextStyle(color: Colors.white),),
    ),
    ),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(24,119, 234, 1),

                                borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                boxShadow: [
                                  BoxShadow(blurRadius: 7.0, color: Colors.black)
                                ])

                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(left:20.0, right: 20),
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    name,
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),

                                  new SizedBox(
                                    height: 8,
                                  ),


                                  Text(
                                    widget.designation,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Montserrat'),
                                  ),

                                    new SizedBox(
                                      height: 10,
                                    ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Edit Name:",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ],
                                  ),


                                  Stack(
                                    children: <Widget>[
                                      TextField(
                                        controller: controller1 ,
                                       onChanged: (str)
                                        {
                                          setState(() {
                                             isButton = true;
                                          });
                                        },
                                       decoration: InputDecoration(
                                         //suffixText: "Save",
                                       ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:240),
                                        child: new FlatButton(
                                            onPressed: () {
                                              //_controller.clear();
                                              if(isButton) {
                                                if (controller1.text
                                                    .trim()
                                                    .length == 0) {
                                                  noSencheck();
                                                }
                                                else {
                                                  setState(() {
                                                    isButton = false;
                                                    addUserLate();
                                                  });

                                                }
                                              }

                                            },
                                            child:Text("Save", style: new TextStyle(color: isButton? Colors.blue: Colors.grey ),)),
                                      ),


                                    ],
                                  ),


                                  if(isShowRed)
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      alignment: Alignment.centerRight,
                                      child: Text('Please Enter Name',
                                          style:
                                          TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.red)),
                                    ),
                                ],
                              ),


                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                     Padding(
                       padding: const EdgeInsets.all(40.0),
                       child:GestureDetector(
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
                             'Logout',
                             style: TextStyle(fontSize: 20, color: Colors.white),
                           ),
                         ),

                         onTap: () async
                         {

                           SharedPreferences prefs = await SharedPreferences.getInstance();
                           prefs.setString('email',null);
                           prefs.setString('name', null);
                           prefs.setString('designation', null);
                           Navigator.push(context,
                               MaterialPageRoute(builder: (context) => LoginPage()));
                         },
                       ),
                     )

                      ],
                    ),
                  ),


                  Positioned(
                      top: -MediaQuery.of(context).size.height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: BezierContainer()),
                ],
              ),


            ),
          ),
        ));
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}