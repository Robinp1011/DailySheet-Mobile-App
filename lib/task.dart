import 'package:flutter/material.dart';

import 'appBars.dart';
import 'bottomNavigation.dart';
import 'fab.dart';
import 'util.dart';
import 'package:intl/intl.dart';
import 'profilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firstdataenterscreen.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'dart:math';
import 'package:expandable/expandable.dart';
import 'editTask.dart';
import 'home.dart';
import 'package:connectivity/connectivity.dart';

class Task extends StatefulWidget {
  //Task({Key key}) : super(key: key);
  String name;
  String designation;
  String email; 
  Set<String> projects;
  List<int> hourList;


  Task(String name, String designation, String email,Set<String> projects,
  List<int> hourList
  )
  {
    this.name = name;
    this.designation = designation;
    this.email = email;
    this.projects = projects;
    this.hourList = hourList;

  }

  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final bottomNavigationBarIndex = 1;
  List<String> projectList = [];
  List<String> applicationList = [];
  Random rand = new Random();
  int r1, r2, r3;
  int count =0;


  String name = "";

  Set<String> projects ={};
  List<int> hourList =[];
  List<int> taskCount = [];
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
    // getList();
     getName();
    getTask();
    getEditList();
    getProject();
  }

  String firstLetter="";
  String lastname="";


  Future  getPosts()  async
  {

    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("todo").document("Kbf1V676TEjD7E2sZIbO").collection("task").where("email", isEqualTo: widget.email).orderBy("date", descending: true).getDocuments();
    return qn.documents;
  }

    getTask()  async
  {

    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("todo").document("Kbf1V676TEjD7E2sZIbO").collection("task").where("email", isEqualTo: widget.email).orderBy("date", descending: true).getDocuments();
      for(int i=0;i<qn.documents.length;i++)
        {
          if(qn.documents[i].data['leave'] == "no")
            {
              setState(() {
                count = count +1;
              });
            }
          else
            continue;
        }

  }

  getEditList() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("customerList").getDocuments();
   projectList = [];
    for(int i=0;i<qn.documents.length;i++)
      {
        projectList.add(qn.documents[i].data['name']);
      }
    QuerySnapshot qn2 = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("projects").getDocuments();
   applicationList = [];
    for(int i=0;i<qn2.documents.length;i++)
      {
        applicationList.add(qn2.documents[i].data['name']);
      }

    //     addList(str);
  }



  getList() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("customerList").getDocuments();
    projectList =[];
    for(int i=0;i<qn.documents.length;i++)
      {
        projectList.add(qn.documents[i].data['name']);
      }

    QuerySnapshot qn2 = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("projects").getDocuments();
    applicationList = [];
    for(int i=0;i<qn2.documents.length;i++)
      {
        applicationList.add(qn2.documents[i].data['name']);
      }
    getNavigate();

    //     addList(str);
  }
  getNavigate()
  {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => IstScreen(projectList, widget.name, widget.designation, firstLetter,lastname, widget.email, projects,hourList, applicationList)));

  }


  getList2() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("projects").getDocuments();
    projectList = qn.documents[0].data['projectlist'];
 //   getNavigate();

    //     addList(str);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(

          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Home(widget.name, widget.designation, widget.email, projects, hourList)));

            },
          ),

        flexibleSpace: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        CustomPaint(
        painter: CircleOne(),
    ),
    CustomPaint(
    painter: CircleTwo(),
    ),
    ],
    ),

    title: Container(
    margin: EdgeInsets.only(top: 10),
    child: Column(
    children: <Widget>[

    Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    Text(
    'Hello ${name}',
    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    ),
    if(count<2)
    Text(
    'you have worked ${count} task',
    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
    )
      else
      Text(
        'you have worked ${count} tasks',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
      ),

    ],
    ),




    ],
    ),
    ),
    actions: <Widget>[
    GestureDetector (
    child: Container(
    margin: EdgeInsets.fromLTRB(0, 0, 20, 8),
    // height: 60,
    //  width: 60,
    decoration: BoxDecoration(
    color: Color.fromRGBO(24,119, 234, 1),
    shape: BoxShape.circle,
    //     borderRadius: BorderRadius.all(Radius.circular(30.0)),
    ),
    child: FittedBox(
    fit: BoxFit.contain,
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text("${firstLetter}${lastname}", style: new TextStyle(color: Colors.white, fontSize: 14),),
    )),
    ),
    onTap: () async
    {

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {


        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyHomePage(widget.name, widget.designation, widget.email, projects, hourList)));
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

    },
    ),
    ],
    elevation: 0,
    gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [CustomColors.HeaderBlueDark, CustomColors.HeaderBlueLight],
    ),
        ),





      body: WillPopScope(
        onWillPop: ()
        {

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Home(widget.name, widget.designation, widget.email, projects, hourList)));

        },

        child: Container(
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
              future: getPosts(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting)
                {
                  return new Text("loading");
                }
                else
                return ListView.builder(
                    itemCount: snapshot.data.length,

                    scrollDirection: Axis.vertical,
                    itemBuilder: (_, index)  {

                      return     Column(

                        children: <Widget>[
                          if(index >0)
                            if(snapshot.data[index].data['date'] != snapshot.data[index -1].data['date'])
                              Container(
                                margin: EdgeInsets.only(top: 15, left: 20, bottom: 15),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      DateFormat('dd-MMM-yyyy').format(snapshot.data[index].data['date'].toDate()).toString(),
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: CustomColors.TextSubHeader),
                                    ),
                                  ],
                                ),
                              ),

                          if(index ==0)
                            Container(
                              margin: EdgeInsets.only(top: 15, left: 20, bottom: 15),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    DateFormat('dd-MMM-yyyy').format(snapshot.data[index].data['date'].toDate()).toString(),
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: CustomColors.TextSubHeader),
                                  ),
                                ],
                              ),
                            ),

                              if(snapshot.data[index].data['leave'] == "yes")
                                Container(
                                  margin: EdgeInsets.only(top: 15, left: 20, bottom: 15),
                                  child: Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Text(
                                            "Leave",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              ),
                                        ),

                                        onTap: ()
                                        {

                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => editTask(widget.name, widget.designation, widget.email
                                                  , snapshot.data[index].data["task"], snapshot.data[index].data['project'], snapshot.data[index].data['hours']
                                                  , projectList, snapshot.data[index].data['date'].toDate(), snapshot.data[index].documentID,
                                                  projects, hourList, snapshot.data[index].data['leave'], applicationList, snapshot.data[index].data['application'],
                                                  snapshot.data[index].data['inTime'], snapshot.data[index].data['outTime'])));

                                        },

                                        onLongPress: ()
                                        {
                                          print("chala");
                                          print(snapshot.data[index].documentID);
                                          //  Firestore.instance.collection("user").document("UN9AJpPbSjYoOZXtQhom").collection("hrteam").document(snapshot.data[index].documentID).delete();
                                          //  Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              // return object of type Dialog
                                              return AlertDialog(
                                                title: new Text("Delete This Information"),

                                                actions: <Widget>[
                                                  // usually buttons at the bottom of the dialog
                                                  new FlatButton(
                                                    child: new Text("Yes"),
                                                    onPressed: () {
                                                      print("yes chala");
                                                      Firestore.instance.collection("todo").document("Kbf1V676TEjD7E2sZIbO").collection("task").document(snapshot.data[index].documentID).delete();
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => Task(widget.name, widget.designation, widget.email, projects, hourList),
                                                          ));

                                                    },
                                                  ),
                                                  new FlatButton(
                                                    child: new Text("No"),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                          else

                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
                              padding: EdgeInsets.fromLTRB(5, 13, 5, 13),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ExpandablePanel(
                                  header: Text("${snapshot.data[index].data['application']} (${snapshot.data[index].data['project']})- ${snapshot.data[index].data['hours'].toString()} hrs.", style: new TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    collapsed: Text("${snapshot.data[index].data["task"]}", softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  expanded: Text(" ${snapshot.data[index].data["task"]}", softWrap: true, ),
                                  tapHeaderToExpand: true,
                                  hasIcon: true,
                                ),
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  stops: [0.015, 0.015],
                                  colors: [Colors.blue, Colors.white],
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: CustomColors.GreyBorder,
                                    blurRadius: 10.0,
                                    spreadRadius: 5.0,
                                    offset: Offset(0.0, 0.0),
                                  ),
                                ],
                              ),
                            ),

                            onDoubleTap: ()
                            {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => editTask(widget.name, widget.designation, widget.email
                                      , snapshot.data[index].data["task"], snapshot.data[index].data['project'], snapshot.data[index].data['hours']
                                      , projectList, snapshot.data[index].data['date'].toDate(), snapshot.data[index].documentID,
                                  projects, hourList, snapshot.data[index].data['leave'], applicationList, snapshot.data[index].data['application'],
                                  snapshot.data[index].data['inTime'], snapshot.data[index].data['outTime'])));
                            },

                            onLongPress: (){
                              print("chala");
                              print(snapshot.data[index].documentID);
                              //  Firestore.instance.collection("user").document("UN9AJpPbSjYoOZXtQhom").collection("hrteam").document(snapshot.data[index].documentID).delete();
                              //  Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    title: new Text("Delete This Information"),

                                    actions: <Widget>[
                                      // usually buttons at the bottom of the dialog
                                      new FlatButton(
                                        child: new Text("Yes"),
                                        onPressed: () {
                                          print("yes chala");
                                          Firestore.instance.collection("todo").document("Kbf1V676TEjD7E2sZIbO").collection("task").document(snapshot.data[index].documentID).delete();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => Task(widget.name, widget.designation, widget.email, projects, hourList),
                                              ));

                                        },
                                      ),
                                      new FlatButton(
                                        child: new Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );

                            },


                          )


                        ],
                      );



                      SizedBox(height: 15);
                    }
                );
              }
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:  FloatingActionButton(
        onPressed: () async{
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {


            getList();
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
        },
        elevation: 5,
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset('assets/images/fab-add.png'),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                CustomColors.PurpleLight,
                CustomColors.PurpleDark,
              ],
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
            boxShadow: [
              BoxShadow(
                color: CustomColors.PurpleShadow,
                blurRadius: 10.0,
                spreadRadius: 5.0,
                offset: Offset(0.0, 0.0),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
      BottomNavigationBarApp(bottomNavigationBarIndex, context, widget.name,widget.designation, widget.email, projects, hourList),
    );
  }
}
