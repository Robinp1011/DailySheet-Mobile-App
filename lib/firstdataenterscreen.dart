


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dynamicWidget.dart';
import 'util.dart';
import 'package:intl/intl.dart';
import 'empty.dart';
import 'appBars.dart';
import 'util.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'profilePage.dart';
import 'dart:math';
import 'usertask.dart';
import 'signup.dart';
import 'task.dart';
import 'dart:async';
import 'package:date_util/date_util.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:connectivity/connectivity.dart';

import 'package:date_picker_timeline/date_picker_timeline.dart';


class IstScreen extends StatefulWidget {
  @override
  List<String> projectList;
  String name;
  String designation;
  String firstLetter;
  String lastName;
  String email;
  Set<String> projects;
  List<int> hourList;
  List<String> applicationList;


  IstScreen(List<String> projectList, String name, String designation, String firstLetter, String lastName, String email,Set<String> projects,
      List<int> hourList, List<String> applicationList

      )
  {
    this.projectList = projectList;
    this.name = name;
    this.designation = designation;
    this.firstLetter = firstLetter;
    this.lastName = lastName;
    this.email = email;
    this.projects = projects;
    this.hourList = hourList;
    this.applicationList = applicationList;

  }

  _IstScreenState createState() => _IstScreenState();
}

class _IstScreenState extends State<IstScreen> {
  @override

  TextEditingController taskController = new TextEditingController();
  List<DynamicWidget> widgetList = [];
  DateTime _dateTime = DateTime.parse("${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()} 00:00:00");
  Random random = new Random();
  int r1 ,r3,r2;

  String name;
  int _itemCount = 1;

  bool isLeave = false;
  TimeOfDay stTime = TimeOfDay.fromDateTime(DateTime.now());
  TimeOfDay endTime = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 8, minutes: 30)));
  TimeOfDay picked;

  String stTimeStr ;
  String endTimeStr ;
  String email;


  String nameaya = "";
  String firstLetter ="";
  String lastname = "";
  var dateUtil = new DateUtil();
  int date;
  String dateStr= "";
  String dateDay = "";
  DateTime  lastTime;
  bool isPresent = false;
  bool isPresent2 = false;
  bool ishourPresent  = false;
  String projectDropDown;
  String applicationDropDown;
  bool isLeaveAlPresent = false;

  bool isEmpty = false;

  String formatTimeOfDay(TimeOfDay tod)
  {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }


  getDate() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("task").where("email", isEqualTo: widget.email).orderBy("date", descending: true).getDocuments();

    if(qn.documents.length == 0)
    {
      addUserLate();
    }
    else
    {
      lastTime = qn.documents[0].data['date'].toDate();


      dateStr = DateFormat('dd').format(_dateTime).toString();
      date = int.parse(dateStr);
      dateDay = DateFormat('EEEE').format(_dateTime).toString();
      print(lastTime);
      print(_dateTime.subtract(Duration(days: 3)));
      print(lastTime == _dateTime.subtract(Duration(days: 3)));
      print(dateDay);

      if(dateDay == 'Monday')
      {
        for(int i=0;i<qn.documents.length;i++)
        {
          if(qn.documents[i].data['date'].toDate()  == _dateTime.subtract(Duration(days: 3)) || lastTime == _dateTime)
          {
            isPresent = true;
            break;
          }
        }
        if(isPresent)
        {
          isPresent = false;
          for(int j=0; j<widgetList.length;j++)
          {
            if(widgetList[j].controller1.text == "" || widgetList[j].hours == 0 )
            {
              isEmpty = true;
              break;
            }
          }



          if(isEmpty)
          {
            isEmpty = false;



            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Either you have not entered your task or hour these cannot be pushed empty."),


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
          else {

            for(int i=0;i<qn.documents.length;i++)
              {
                if(qn.documents[i].data['date'].toDate() == _dateTime)
                  {
                    if(qn.documents[i].data['leave'] == "yes")
                      {
                        isLeaveAlPresent = true;
                        break;
                      }
                  }
              }

            if(isLeaveAlPresent)
              {
                  isLeaveAlPresent = false;
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text("You have already entered leave on that day."),


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
            else
              {
                addUserLate();
              }


          }

        }
        else
        {
          print("monday chala");
          for(int j=0; j<widgetList.length;j++)
          {
            if(widgetList[j].controller1.text == "" || widgetList[j].hours == 0)
            {
              isEmpty = true;
              break;
            }
          }
          if(isEmpty)
          {
            isEmpty = false;

            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Either you have not entered your task or hour these cannot be pushed empty."),


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
          else {

            for(int i=0;i<qn.documents.length;i++)
            {
              if(qn.documents[i].data['date'].toDate() == _dateTime)
              {
                if(qn.documents[i].data['leave'] == "yes")
                {
                  isLeaveAlPresent = true;
                  break;
                }
              }
            }

            if(isLeaveAlPresent)
            {
               isLeaveAlPresent = false;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: new Text("You have already entered leave on that day."),


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
            else
            {
              addUserLateoutSplash();
            }

          }



        }
      }
      else if(dateDay == 'Saturday' || dateDay == 'Sunday')
      {

        for(int j=0; j<widgetList.length;j++)
        {
          if(widgetList[j].controller1.text == "" || widgetList[j].hours == 0)
          {
            isEmpty = true;
            break;
          }
        }
        if(isEmpty)
        {
          isEmpty = false;

          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Either you have not entered your task or hour these cannot be pushed empty."),


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
        else {

          addUserLate();
        }

      }
      else
      {
        for(int i=0;i<qn.documents.length;i++)
        {
          if(qn.documents[i].data['date'].toDate() == _dateTime.subtract(Duration(days: 1)) || lastTime == _dateTime)
          {
            isPresent2 = true;
            break;
          }
        }
        if(isPresent2)
        {
          isPresent2 = false;
          for(int j=0; j<widgetList.length;j++)
          {
            if(widgetList[j].controller1.text == "" || widgetList[j].hours == 0)
            {
              isEmpty = true;
              break;
            }
          }
          if(isEmpty)
          {
            isEmpty = false;

            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Either you have not entered your task or hour these cannot be pushed empty."),


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
          else {

            for(int i=0;i<qn.documents.length;i++)
            {
              if(qn.documents[i].data['date'].toDate() == _dateTime)
              {
                if(qn.documents[i].data['leave'] == "yes")
                {
                  isLeaveAlPresent = true;
                  break;
                }
              }
            }

            if(isLeaveAlPresent)
            {
                isLeaveAlPresent = false;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: new Text("You have already entered leave on that day."),


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
            else
            {
              addUserLate();
            }

          }


        }
        else
        {
          for(int j=0; j<widgetList.length;j++)
          {
            if(widgetList[j].controller1.text == "" || widgetList[j].hours == 0)
            {
              isEmpty = true;
              break;
            }
          }
          if(isEmpty)
          {
            isEmpty = false;

            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Either you have not entered your task or hour these cannot be pushed empty."),


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
          else {

            for(int i=0;i<qn.documents.length;i++)
            {
              if(qn.documents[i].data['date'].toDate() == _dateTime)
              {
                if(qn.documents[i].data['leave'] == "yes")
                {
                  isLeaveAlPresent = true;
                  break;
                }
              }
            }

            if(isLeaveAlPresent)
            {
              isLeaveAlPresent = false;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: new Text("You have already entered leave on that day."),


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
            else
            {
              addUserLateoutSplash();
            }

          }


        }

      }

    }



  }



  getName() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").where("email", isEqualTo: widget.email).getDocuments();
    setState(() {
      nameaya = qn.documents[0].data['name'];
    });

    var  names = nameaya.split(' ');
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
    stTimeStr = formatTimeOfDay(stTime);
    endTimeStr = formatTimeOfDay(endTime);
    email = widget.email;
    projectDropDown = widget.projectList.elementAt(0);
    applicationDropDown = widget.applicationList.elementAt(0);

    print(_dateTime);

    print(widget.projectList);
    r1 = random.nextInt(255);
    r2 = random.nextInt(255);
    r3 = random.nextInt(255);
    getName();

    widgetList.add(new DynamicWidget(widget.projectList,_itemCount,r1,r2,r3, widget.applicationList, projectDropDown, applicationDropDown));
    //  getDate();


  }


  void  increaseCount()
  {
    //  widgetList = [];
    setState(() {
      _itemCount++;
    });
    fillList(_itemCount.toString());
  }

  void decreaseCount()
  {
    //  widgetList = [];
    if(_itemCount >1)
    {
      setState(() {
        _itemCount--;
      });
      deleteList();
    }

  }

  void deleteList()
  {
    widgetList.removeLast();
  }

  void fillList(String str)
  {

    setState(()  {
      //  widgetList =[];

      print(widget.projectList);
      r1 = random.nextInt(255);
      r2 = random.nextInt(255);
      r3 = random.nextInt(255);

      widgetList.add(new DynamicWidget(widget.projectList, int.parse(str),r1,r2,r3, widget.applicationList, projectDropDown, applicationDropDown));

    });
  }


  addUserLateoutSplash() async{
    print(widgetList.length);

    if(isLeave)
    {

      UserTask user = new UserTask(widget.email, "","" , 0,_dateTime, "yes","","","");

      print("yha bhi aaya");

      try {
        print("aya ky ander");
        Firestore.instance.runTransaction(
              (Transaction transaction) async {
            await Firestore.instance
                .collection("todo")
                .document("Kbf1V676TEjD7E2sZIbO").collection("task").document()
                .setData(user.toJson());

          },
        );
      } catch (e) {
        print(e.toString());
      }
      if(dateDay == 'Monday') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Warning: "),
              content: new Text("Dear ${nameaya}, you have not updated"
                  " last day ${DateFormat('dd-MMM-yyyy')
                  .format(_dateTime.subtract(Duration(days: 3)))
                  .toString()} task. Please update. As its "
                  "mandatory."),

              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Task(
                            widget.name, widget.designation, widget.email,
                            widget.projects, widget.hourList),
                        ));
                  },
                ),
              ],

            );
          },
        );
      }
      else
      {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Warning: "),
              content: new Text("Dear ${nameaya}, you have not updated"
                  " last day ${DateFormat('dd-MMM-yyyy')
                  .format(_dateTime.subtract(Duration(days: 1)))
                  .toString()} task. Please update. As its "
                  "mandatory."),

              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Task(
                            widget.name, widget.designation, widget.email,
                            widget.projects, widget.hourList),
                        ));
                  },
                ),
              ],

            );
          },
        );
      }
      // startTime();
    }

    else{

      for(int i=0;i<widgetList.length;i++)
      {
        UserTask user = new UserTask(widget.email, widgetList[i].projectDropDown,widgetList[i].controller1.text , widgetList[i].hours,_dateTime,"no",widgetList[i].applicationDropDown, stTimeStr, endTimeStr);

        print("yha bhi aaya");

        try {
          print("aya ky ander");
          Firestore.instance.runTransaction(
                (Transaction transaction) async {
              await Firestore.instance
                  .collection("todo")
                  .document("Kbf1V676TEjD7E2sZIbO").collection("task").document()
                  .setData(user.toJson());

            },
          );
        } catch (e) {
          print(e.toString());
        }

      }
      if(dateDay == "Monday")  {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Warning: "),
              content: new Text("Dear ${nameaya}, you have not updated"
                  " last day ${DateFormat('dd-MMM-yyyy').format(_dateTime.subtract(Duration(days: 3))).toString()} task. Please update. As its "
                  "mandatory."),

              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Task(widget.name, widget.designation, widget.email, widget.projects, widget.hourList),
                        ));

                  },
                ),
              ],

            );
          },
        );    }

      else
      {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Warning: "),
              content: new Text("Dear ${nameaya}, you have not updated"
                  " last day ${DateFormat('dd-MMM-yyyy').format(_dateTime.subtract(Duration(days: 1))).toString()} task. Please update. As its "
                  "mandatory."),

              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Task(widget.name, widget.designation, widget.email, widget.projects, widget.hourList),
                        ));

                  },
                ),
              ],

            );
          },
        );
      }
      // startTime();
    }


  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>  Task(widget.name, widget.designation, widget.email,widget.projects, widget.hourList)));
  }

  addUserLate() async{
    print(widgetList.length);

    if(isLeave)
    {
      UserTask user = new UserTask(widget.email, "","" , 0,_dateTime, "yes","","","");

      print("yha bhi aaya");

      try {
        print("aya ky ander");
        Firestore.instance.runTransaction(
              (Transaction transaction) async {
            await Firestore.instance
                .collection("todo")
                .document("Kbf1V676TEjD7E2sZIbO").collection("task").document()
                .setData(user.toJson());

          },
        );
      } catch (e) {
        print(e.toString());
      }


      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>SplashScreenFirst(widget.name, widget.designation,widget.email, widget.projects, widget.hourList)));
      //  Navigator.pop(context);
    }

    else{

      for(int i=0;i<widgetList.length;i++)
      {
        UserTask user = new UserTask(widget.email, widgetList[i].projectDropDown,widgetList[i].controller1.text , widgetList[i].hours,_dateTime,"no", widgetList[i].applicationDropDown, stTimeStr, endTimeStr);

        print("yha bhi aaya");

        try {
          print("aya ky ander");
          Firestore.instance.runTransaction(
                (Transaction transaction) async {
              await Firestore.instance
                  .collection("todo")
                  .document("Kbf1V676TEjD7E2sZIbO").collection("task").document()
                  .setData(user.toJson());

            },
          );
        } catch (e) {
          print(e.toString());
        }

      }

      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>SplashScreenFirst(widget.name, widget.designation,widget.email, widget.projects, widget.hourList)));
      //  Navigator.pop(context);

    }


  }




  Widget build(BuildContext context) {
    return Scaffold(

      appBar: GradientAppBar(

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
                    'Hello ${nameaya}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  if(_itemCount<2)
                    Text(
                      'you have ${_itemCount} task',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                    )
                  else
                    Text(
                      'you have ${_itemCount} tasks',
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
            onTap: ()
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage(widget.name, widget.designation, widget.email, widget.projects, widget.hourList)));
            },
          ),
        ],
        elevation: 0,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CustomColors.HeaderBlueDark, CustomColors.HeaderBlueLight],
        ),

        bottom:
        PreferredSize(
          preferredSize: Size.fromHeight(110.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                    // height: 110,
              decoration: new BoxDecoration(

                //  color: Color.fromRGBO(138,192,239,1),
               // color: Colors.blueAccent,
                  color: CustomColors.HeaderGreyLight,
                  borderRadius: new BorderRadius.all(
                      Radius.circular(5)   )
              ),
              child: Column(
                children: <Widget>[
                  new SizedBox(
                    height: 5,
                  ),



                  Column(
                    children: <Widget>[

                      new Text("SELECT DATE", style: new TextStyle( fontSize:12,fontWeight: FontWeight.bold),),
                      // new Text(totalEnergyConsumption.toString(), style: new TextStyle(color: Colors.white),),

                      new SizedBox(
                        height: 3,
                      ),

                      StatefulBuilder(
                        // stream: null,
                          builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                            return GestureDetector(child: new Text(DateFormat('dd-MMM-yyyy').format(_dateTime).toString(), style: new TextStyle( color:Colors.white,fontSize:16, fontWeight: FontWeight.bold),)
                            ,
                            onTap: ()
                              {
                                showDatePicker(
                                  context: context,
                                  initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                  firstDate: DateTime(2001),
                                  lastDate:DateTime.now(),
                                  //selectableDayPredicate: (DateTime val) =>
                                  // val.weekday == 6 || val.weekday == 7 ? false : true,

                                ).then((date) {
                                  if(date!= null)
                                  {
                                    setState(
                                            (){
                                          _dateTime = date;
                                        }
                                    );  }

                                  print(DateFormat('MM/dd/yyyy').format(_dateTime).toString());
                                });

                              },);
                          }
                      ),



                    ],
                  ),

                  new SizedBox(
                    height: 5,
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width / 1.15,
                    child:  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text("IN TIME", style: new TextStyle(color: Color.fromRGBO(16, 48, 68, 1), fontSize: 11, fontWeight: FontWeight.bold),),

                              new SizedBox(
                                height: 4,
                              ),
                              StatefulBuilder(
                                // stream: null,
                                  builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                    return GestureDetector(child: new Text(stTimeStr, style: new TextStyle(color: Colors.white, fontSize:18),),
                                      onTap: () async
                                      {
                                        TimeOfDay timepick = await showTimePicker(
                                            context: context, initialTime: new TimeOfDay.now());

                                        if (timepick != null) {
                                          setState(() {
                                            stTimeStr = formatTimeOfDay(timepick);
                                            //    stTimeStr = timepick.hourOfPeriod.toString();
                                          });
                                        }
                                      },

                                    );
                                  }
                              ),

                            ],
                          ),



               /*         Expanded(
                            child: Column(
                              children: <Widget>[

                                new SizedBox(
                                  height: 4,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Text("Choose Date", style: new TextStyle(color: Color.fromRGBO(16, 48, 68, 1), fontSize:12,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                // new Text(totalEnergyConsumption.toString(), style: new TextStyle(color: Colors.white),),

                                new SizedBox(
                                  height: 3,
                                ),

                                StatefulBuilder(
                                  // stream: null,
                                    builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                      return GestureDetector(child: new Text(DateFormat('MM/dd/yyyy').format(_dateTime).toString(), style: new TextStyle( color:Colors.white,fontSize:16),),
                                        onTap: ()
                                        {
                                          showDatePicker(
                                            context: context,
                                            initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                            firstDate: DateTime(2001),
                                            lastDate:DateTime.now(),
                                            //selectableDayPredicate: (DateTime val) =>
                                            // val.weekday == 6 || val.weekday == 7 ? false : true,

                                          ).then((date) {
                                            if(date!= null)
                                            {
                                              setState(
                                                      (){
                                                    _dateTime = date;
                                                  }
                                              );  }

                                            print(DateFormat('MM/dd/yyyy').format(_dateTime).toString());
                                          });
                                        },

                                      );
                                    }
                                ),



                                new SizedBox(
                                  height: 4,
                                ),
                              ],
                            ),
                          ),   */

                          new Row(

                            children: <Widget>[


                              GestureDetector(child: new Icon(Icons.remove, color: Colors.white, size: 25,),
                                onTap: ()
                                {
                                  decreaseCount();
                                },
                              ),
                              new SizedBox(
                                width: 8,
                              ),
                              new Text(_itemCount.toString(), style: new TextStyle(fontSize: 34,fontWeight: FontWeight.bold, color:Colors.white),),

                              new SizedBox(
                                width: 8,
                              ),

                              GestureDetector(child: new Icon(Icons.add, color: Colors.white,size: 25,),
                                onTap: ()
                                {
                                  if(!isLeave)
                                    {
                                  increaseCount(); }
                                },
                              ),
                            ],
                          ),



                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new Text("OUT TIME", style: new TextStyle(color:  Color.fromRGBO(16, 48, 68, 1), fontSize: 11, fontWeight: FontWeight.bold),),

                              new SizedBox(
                                height: 4,
                              ),
                              StatefulBuilder(
                                // stream: null,
                                  builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                    return GestureDetector(child: new Text(endTimeStr, style: new TextStyle( color:Colors.white,fontSize:18),),
                                      onTap: () async
                                      {
                                        TimeOfDay timepick = await showTimePicker(
                                            context: context, initialTime: new TimeOfDay.now());

                                        if (timepick != null) {
                                          setState(() {
                                            endTimeStr = formatTimeOfDay(timepick);
                                          });
                                        }
                                      },

                                    );
                                  }
                              ),
                              new SizedBox(
                                height: 4,
                              )
                            ],
                          ),


                        ],

                      ),
                    ),
                  ),

               //    SizedBox(height: 5),



             /*     Container(
                   // width: MediaQuery.of(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DatePicker(
                          DateTime(2020),
                        //  height: 60,
                          initialSelectedDate:_dateTime == null ? DateTime.now() : _dateTime,
                          selectionColor: Colors.black,
                          selectedTextColor: Colors.white,
                        //  firstDate: DateTime(2001),
                        //  lastDate:DateTime.now(),

                          onDateChange: (date) {
                            // New date selected
                            setState(() {
                              _dateTime = date;
                            });
                          },
                        ),
                      ],
                    ),
                  )     */
                ],
              ),
            ),
          ),
        ),

      ),

      body: SingleChildScrollView(
        child: SizedBox(
        //  height: MediaQuery.of(context).size.height,
          child: Container(
            child: Center(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[



                  Container(
                    height: 310,
                    //  color: Colors.grey[100],
                    child: ListView(
                      children: <Widget>[
                        Column(children: widgetList,),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),


                  Padding(
                      padding: const EdgeInsets.only(left:8, right: 8),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        //    height: 80,
                        //   padding: EdgeInsets.symmetric(vertical: 2),

                        child:
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[


                            SizedBox(
                              height: 18,
                              width:  18,
                              child: new Checkbox(value: isLeave,

                                  onChanged: (str)
                                  {
                                    isLeave = !isLeave;
                                    if(isLeave)
                                    {
                                      setState(() {
                                        widgetList =[];
                                        _itemCount =0;
                                      });
                                    }
                                    else
                                    {
                                      setState(() {

                                        _itemCount = 1;
                                        widgetList.add(new DynamicWidget(widget.projectList,_itemCount,r1,r2,r3, widget.applicationList, projectDropDown, applicationDropDown));
                                        print(isLeave);
                                      });
                                    }


                                  }),
                            ),


                            new SizedBox(
                              width: 20,
                            ),
                            new Text("I am on leave" , style: new TextStyle(fontWeight: FontWeight.bold),),

                          ],
                        ),
                      )
                  ),


                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
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
                          'Add Task ',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ), 
                      ),

                      onTap: ()  async
                      {



                        var connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                          getDate();
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
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




class SplashScreenFirst extends StatefulWidget {
  @override
  String name;
  String designation;
  String email;
  Set<String> projects;
  List<int> hourList;

  SplashScreenFirst(String name, String designation, String email, Set<String> projects, List<int> hourList)
  {
    this.name = name;
    this.designation = designation;
    this.email = email;
    this.projects = projects;
    this.hourList = hourList;
  }

  _SplashScreenFirstState createState() => _SplashScreenFirstState();
}

class _SplashScreenFirstState extends State<SplashScreenFirst> {
  @override

  void navigationPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>  Task(widget.name, widget.designation, widget.email,widget.projects, widget.hourList)));
  }

  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void initState() {
    super.initState();
    startTime();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        color: Color.fromRGBO(250, 250, 250, 0.9),
        child: new Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: Center(
              child:
              Image.asset("assets/images/newloader.gif"),
            ),
          ),
        ),
      ),
    );
  }

}







/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dynamicWidget.dart';
import 'util.dart';
import 'package:intl/intl.dart';
import 'empty.dart';
import 'appBars.dart';
import 'util.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'profilePage.dart';
import 'dart:math';
import 'usertask.dart';
import 'signup.dart';
import 'task.dart';
import 'dart:async';
import 'package:date_util/date_util.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';


class IstScreen extends StatefulWidget {
  @override
  List<String> projectList;
  String name;
  String designation;
  String firstLetter;
  String lastName;
  String email;
  Set<String> projects;
  List<int> hourList;
  List<String> applicationList;


  IstScreen(List<String> projectList, String name, String designation, String firstLetter, String lastName, String email,Set<String> projects,
  List<int> hourList, List<String> applicationList

  )
  {
    this.projectList = projectList;
    this.name = name;
    this.designation = designation;
    this.firstLetter = firstLetter;
    this.lastName = lastName;
    this.email = email;
    this.projects = projects;
    this.hourList = hourList;
    this.applicationList = applicationList;

  }

  _IstScreenState createState() => _IstScreenState();
}

class _IstScreenState extends State<IstScreen> {
  @override

  TextEditingController taskController = new TextEditingController();
  List<DynamicWidget> widgetList = [];
  DateTime _dateTime = DateTime.parse("${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()} 00:00:00");
  Random random = new Random();
  int r1 ,r3,r2;

  String name;
  int _itemCount = 1;

   bool isLeave = false;
  TimeOfDay stTime = TimeOfDay.fromDateTime(DateTime.now());
  TimeOfDay endTime = TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 8, minutes: 30)));
  TimeOfDay picked;

  String stTimeStr ;
  String endTimeStr ;
  String email;


  String nameaya;
  String firstLetter ="";
  String lastname = "";
  var dateUtil = new DateUtil();
  int date;
  String dateStr= "";
  String dateDay = "";
  DateTime  lastTime;
  bool isPresent = false;
  bool isPresent2 = false;
  String projectDropDown;
  String applicationDropDown;

  bool isEmpty = false;

  String formatTimeOfDay(TimeOfDay tod)
  {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }


  getDate() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("task").where("email", isEqualTo: widget.email).orderBy("date", descending: true).getDocuments();

    if(qn.documents.length == 0)
      {
        addUserLate();
      }
    else
      {
        lastTime = qn.documents[0].data['date'].toDate();


        dateStr = DateFormat('dd').format(_dateTime).toString();
        date = int.parse(dateStr);
        dateDay = DateFormat('EEEE').format(_dateTime).toString();
        print(lastTime);
        print(_dateTime.subtract(Duration(days: 3)));
        print(lastTime == _dateTime.subtract(Duration(days: 3)));
        print(dateDay);

        if(dateDay == 'Monday')
        {
          for(int i=0;i<qn.documents.length;i++)
            {
              if(qn.documents[i].data['date'].toDate()  == _dateTime.subtract(Duration(days: 3)) || lastTime == _dateTime)
                {
                  isPresent = true;
                  break;
                }
            }
          if(isPresent)
          {
            isPresent = false;
            for(int j=0; j<widgetList.length;j++)
              {
                if(widgetList[j].controller1.text == "")
                  {
                      isEmpty = true;
                      break;
                  }
              }
            if(isEmpty)
              {
                isEmpty = false;

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text("you have not entered your task it can't be push empty"),


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
            else {

              addUserLate();
            }

          }
          else
          {
            print("monday chala");
            for(int j=0; j<widgetList.length;j++)
            {
              if(widgetList[j].controller1.text == "")
              {
                isEmpty = true;
                break;
              }
            }
            if(isEmpty)
            {
              isEmpty = false;

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: new Text("you have not entered your task it can't be push empty"),


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
            else {

              addUserLateoutSplash();
            }



          }
        }
        else if(dateDay == 'Saturday' || dateDay == 'Sunday')
          {

            for(int j=0; j<widgetList.length;j++)
            {
              if(widgetList[j].controller1.text == "")
              {
                isEmpty = true;
                break;
              }
            }
            if(isEmpty)
            {
              isEmpty = false;

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: new Text("you have not entered your task it can't be push empty"),


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
            else {

              addUserLate();
            }

          }
        else
        {
          for(int i=0;i<qn.documents.length;i++)
            {
              if(qn.documents[i].data['date'].toDate() == _dateTime.subtract(Duration(days: 1)) || lastTime == _dateTime)
                {
                  isPresent2 = true;
                  break;
                }
            }
          if(isPresent2)
          {
            isPresent2 = false;
            for(int j=0; j<widgetList.length;j++)
            {
              if(widgetList[j].controller1.text == "")
              {
                isEmpty = true;
                break;
              }
            }
            if(isEmpty)
            {
              isEmpty = false;

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: new Text("you have not entered your task it can't be push empty"),


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
            else {

              addUserLate();
            }


          }
          else
          {
            for(int j=0; j<widgetList.length;j++)
            {
              if(widgetList[j].controller1.text == "")
              {
                isEmpty = true;
                break;
              }
            }
            if(isEmpty)
            {
              isEmpty = false;

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: new Text("you have not entered your task it can't be push empty"),


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
            else {

              addUserLateoutSplash();
            }


          }

        }

      }

     

  }



  getName() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").where("email", isEqualTo: widget.email).getDocuments();
    setState(() {
      nameaya = qn.documents[0].data['name'];
    });

    var  names = nameaya.split(' ');
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
    stTimeStr = formatTimeOfDay(stTime);
    endTimeStr = formatTimeOfDay(endTime);
    email = widget.email;
    projectDropDown = widget.projectList.elementAt(0);
    applicationDropDown = widget.applicationList.elementAt(0);

    print(_dateTime);

    print(widget.projectList);
    r1 = random.nextInt(255);
    r2 = random.nextInt(255);
    r3 = random.nextInt(255);
    getName();

    widgetList.add(new DynamicWidget(widget.projectList,_itemCount,r1,r2,r3, widget.applicationList, projectDropDown, applicationDropDown));
  //  getDate();


  }


  void  increaseCount()
  {
  //  widgetList = [];
     setState(() {
       _itemCount++;
     });
    fillList(_itemCount.toString());
  }

  void decreaseCount()
  {
  //  widgetList = [];
     if(_itemCount >1)
       {
         setState(() {
           _itemCount--;
         });
         deleteList();
       }

  }

  void deleteList()
  {
    widgetList.removeLast();
  }

  void fillList(String str)
  {

    setState(()  {
    //  widgetList =[];

        print(widget.projectList);
        r1 = random.nextInt(255);
        r2 = random.nextInt(255);
        r3 = random.nextInt(255);

        widgetList.add(new DynamicWidget(widget.projectList, int.parse(str),r1,r2,r3, widget.applicationList, projectDropDown, applicationDropDown));

    });
  }


  addUserLateoutSplash() async{
    print(widgetList.length);

    if(isLeave)
    {
      UserTask user = new UserTask(widget.email, "","" , 0,_dateTime, "yes","","","");

      print("yha bhi aaya");

      try {
        print("aya ky ander");
        Firestore.instance.runTransaction(
              (Transaction transaction) async {
            await Firestore.instance
                .collection("todo")
                .document("Kbf1V676TEjD7E2sZIbO").collection("task").document()
                .setData(user.toJson());

          },
        );
      } catch (e) {
        print(e.toString());
      }
      if(dateDay == 'Monday') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Warning: "),
              content: new Text("Dear ${nameaya}, you have not updated"
                  " last day ${DateFormat('dd-MMM-yyyy')
                  .format(_dateTime.subtract(Duration(days: 3)))
                  .toString()} task. Please update. As its "
                  "mandatory."),

              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Task(
                            widget.name, widget.designation, widget.email,
                            widget.projects, widget.hourList),
                        ));
                  },
                ),
              ],

            );
          },
        );
      }
      else
        {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Warning: "),
                content: new Text("Dear ${nameaya}, you have not updated"
                    " last day ${DateFormat('dd-MMM-yyyy')
                    .format(_dateTime.subtract(Duration(days: 1)))
                    .toString()} task. Please update. As its "
                    "mandatory."),

                actions: <Widget>[
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Task(
                              widget.name, widget.designation, widget.email,
                              widget.projects, widget.hourList),
                          ));
                    },
                  ),
                ],

              );
            },
          );
        }
   // startTime();
      }

    else{

      for(int i=0;i<widgetList.length;i++)
      {
        UserTask user = new UserTask(widget.email, widgetList[i].projectDropDown,widgetList[i].controller1.text , widgetList[i].hours,_dateTime,"no",widgetList[i].applicationDropDown, stTimeStr, endTimeStr);

        print("yha bhi aaya");

        try {
          print("aya ky ander");
          Firestore.instance.runTransaction(
                (Transaction transaction) async {
              await Firestore.instance
                  .collection("todo")
                  .document("Kbf1V676TEjD7E2sZIbO").collection("task").document()
                  .setData(user.toJson());

            },
          );
        } catch (e) {
          print(e.toString());
        }

      }
      if(dateDay == "Monday")  {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Warning: "),
            content: new Text("Dear ${nameaya}, you have not updated"
                " last day ${DateFormat('dd-MMM-yyyy').format(_dateTime.subtract(Duration(days: 3))).toString()} task. Please update. As its "
                "mandatory."),

            actions: <Widget>[
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Task(widget.name, widget.designation, widget.email, widget.projects, widget.hourList),
                      ));

                },
              ),
            ],

          );
        },
      );    }

      else
        {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Warning: "),
                content: new Text("Dear ${nameaya}, you have not updated"
                    " last day ${DateFormat('dd-MMM-yyyy').format(_dateTime.subtract(Duration(days: 1))).toString()} task. Please update. As its "
                    "mandatory."),

                actions: <Widget>[
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Task(widget.name, widget.designation, widget.email, widget.projects, widget.hourList),
                          ));

                    },
                  ),
                ],

              );
            },
          );
        }
         // startTime();
    }


  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>  Task(widget.name, widget.designation, widget.email,widget.projects, widget.hourList)));
  }

  addUserLate() async{
       print(widgetList.length);

       if(isLeave)
         {
           UserTask user = new UserTask(widget.email, "","" , 0,_dateTime, "yes","","","");

           print("yha bhi aaya");

           try {
             print("aya ky ander");
             Firestore.instance.runTransaction(
                   (Transaction transaction) async {
                 await Firestore.instance
                     .collection("todo")
                     .document("Kbf1V676TEjD7E2sZIbO").collection("task").document()
                     .setData(user.toJson());

               },
             );
           } catch (e) {
             print(e.toString());
           }


           Navigator.push(context,
               MaterialPageRoute(builder: (context) =>SplashScreenFirst(widget.name, widget.designation,widget.email, widget.projects, widget.hourList)));
           //  Navigator.pop(context);
         }

       else{

         for(int i=0;i<widgetList.length;i++)
         {
           UserTask user = new UserTask(widget.email, widgetList[i].projectDropDown,widgetList[i].controller1.text , widgetList[i].hours,_dateTime,"no", widgetList[i].applicationDropDown, stTimeStr, endTimeStr);

           print("yha bhi aaya");

           try {
             print("aya ky ander");
             Firestore.instance.runTransaction(
                   (Transaction transaction) async {
                 await Firestore.instance
                     .collection("todo")
                     .document("Kbf1V676TEjD7E2sZIbO").collection("task").document()
                     .setData(user.toJson());

               },
             );
           } catch (e) {
             print(e.toString());
           }

         }

         Navigator.push(context,
             MaterialPageRoute(builder: (context) =>SplashScreenFirst(widget.name, widget.designation,widget.email, widget.projects, widget.hourList)));
         //  Navigator.pop(context);

       }


  }




  Widget build(BuildContext context) {
    return Scaffold(

      appBar: GradientAppBar(

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
                    'Hello ${nameaya}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  if(_itemCount<2)
                  Text(
                    'you have ${_itemCount} task',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                  )
                  else
                    Text(
                      'you have ${_itemCount} tasks',
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
            onTap: ()
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage(widget.name, widget.designation, widget.email, widget.projects, widget.hourList)));
            },
          ),
        ],
        elevation: 0,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CustomColors.HeaderBlueDark, CustomColors.HeaderBlueLight],
        ),

        bottom:
        PreferredSize(
          preferredSize: Size.fromHeight(110.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(

              decoration: new BoxDecoration(

                  color: Color.fromRGBO(138,192,239,1),
                  borderRadius: new BorderRadius.all(
                   Radius.circular(20)   )
              ),
              child: Column(
                children: <Widget>[
                    new SizedBox(
                      height: 5,
                    ),


                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child:  new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[

                            new SizedBox(
                              height: 4,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Text("Choose Date", style: new TextStyle(color: Color.fromRGBO(16, 48, 68, 1), fontSize:12,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            // new Text(totalEnergyConsumption.toString(), style: new TextStyle(color: Colors.white),),

                            new SizedBox(
                              height: 3,
                            ),

                            StatefulBuilder(
                              // stream: null,
                                builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                  return GestureDetector(child: new Text(DateFormat('MM/dd/yyyy').format(_dateTime).toString(), style: new TextStyle( color:Colors.white,fontSize:16),),
                                    onTap: ()
                                    {
                                      showDatePicker(
                                          context: context,
                                          initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                          firstDate: DateTime(2001),
                                          lastDate:DateTime.now(),
                                        //selectableDayPredicate: (DateTime val) =>
                                       // val.weekday == 6 || val.weekday == 7 ? false : true,

                                      ).then((date) {
                                        if(date!= null)
                                        {
                                          setState(
                                                  (){
                                                _dateTime = date;
                                              }
                                          );  }

                                        print(DateFormat('MM/dd/yyyy').format(_dateTime).toString());
                                      });
                                    },

                                  );
                                }
                            ),



                            new SizedBox(
                              height: 4,
                            ),
                          ],
                        ),

                        Container(height: 35, child: VerticalDivider(color: Colors.white, width: 10,)),
                        Row(
                          children: <Widget>[

                            new SizedBox(
                              height: 4,
                            ),

                            Column(
                              children: <Widget>[
                                new Text("InTime", style: new TextStyle(color: Color.fromRGBO(16, 48, 68, 1), fontSize: 12, fontWeight: FontWeight.bold),),

                                new SizedBox(
                                  height: 3,
                                ),
                                StatefulBuilder(
                                  // stream: null,
                                    builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                      return GestureDetector(child: new Text(stTimeStr, style: new TextStyle(color: Colors.white, fontSize:16),),
                                        onTap: () async
                                        {
                                          TimeOfDay timepick = await showTimePicker(
                                              context: context, initialTime: new TimeOfDay.now());

                                          if (timepick != null) {
                                            setState(() {
                                              stTimeStr = formatTimeOfDay(timepick);
                                          //    stTimeStr = timepick.hourOfPeriod.toString();
                                            });
                                          }
                                        },

                                      );
                                    }
                                ),

                              ],
                            ),

                            new SizedBox(
                              width: 8,
                            ),

                            Column(
                              children: <Widget>[
                                new Text("OutTime", style: new TextStyle(color:  Color.fromRGBO(16, 48, 68, 1), fontSize: 12, fontWeight: FontWeight.bold),),

                                new SizedBox(
                                  height: 3,
                                ),
                                StatefulBuilder(
                                  // stream: null,
                                    builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                      return GestureDetector(child: new Text(endTimeStr, style: new TextStyle( color:Colors.white,fontSize:16),),
                                        onTap: () async
                                        {
                                          TimeOfDay timepick = await showTimePicker(
                                              context: context, initialTime: new TimeOfDay.now());

                                          if (timepick != null) {
                                            setState(() {
                                              endTimeStr = formatTimeOfDay(timepick);
                                            });
                                          }
                                        },

                                      );
                                    }
                                ),

                              ],
                            ),

                            new SizedBox(
                              height: 4,
                            ),
                          ],
                        )
                      ],

                    ),
                  ),

                //  SizedBox(height: 5),





                  Padding(
                    padding: const EdgeInsets.only(right:8.0, left: 8, bottom: 8),
                    child: Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        //    height: 80,
                     //   padding: EdgeInsets.symmetric(vertical: 2),

                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                             new Text("Task Planning", style: new TextStyle( color:Colors.white,fontSize: 16, fontWeight: FontWeight.bold),),
                                  new SizedBox(
                                    width: 20,
                                  ),

                                   Container(
                                   //  color: Colors.white,
                                    //   width: 100,
                                     child: new Row(

                                       children: <Widget>[


                                         GestureDetector(child: new Icon(Icons.remove, color: Colors.white, size: 25,),
                                         onTap: ()
                                           {
                                             decreaseCount();
                                           },
                                         ),
                                         new SizedBox(
                                           width: 6,
                                         ),
                                         new Text(_itemCount.toString(), style: new TextStyle(fontSize: 15,fontWeight: FontWeight.bold, color:Colors.white),),

                                         new SizedBox(
                                           width: 6,
                                         ),

                                         GestureDetector(child: new Icon(Icons.add, color: Colors.white,size: 25,),
                                           onTap: ()
                                           {
                                             increaseCount();
                                           },
                                         ),
                                       ],
                                     ),
                                   )

                            ],

                          ),
                        )
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),

      ),

      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Container(
            child: Center(
              child: Column(
               // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[



                  Container(
                    height: 290,
                  //  color: Colors.grey[100],
                    child: ListView(
                      children: <Widget>[
                        Column(children: widgetList,),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),


                  Padding(
                      padding: const EdgeInsets.only(left:8, right: 8),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        //    height: 80,
                        //   padding: EdgeInsets.symmetric(vertical: 2),

                        child:
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[


                            SizedBox(
                              height: 18,
                              width:  18,
                              child: new Checkbox(value: isLeave,

                                  onChanged: (str)
                                  {
                                     isLeave = !isLeave;
                                     if(isLeave)
                                       {
                                         setState(() {
                                           widgetList =[];
                                           _itemCount =0;
                                         });
                                       }
                                     else
                                       {
                                         setState(() {

                                           _itemCount = 1;
                                           widgetList.add(new DynamicWidget(widget.projectList,_itemCount,r1,r2,r3, widget.applicationList, projectDropDown, applicationDropDown));
                                           print(isLeave);
                                         });
                                       }


                                  }),
                            ),


                            new SizedBox(
                              width: 20,
                            ),
                            new Text("I am on leave" , style: new TextStyle(fontWeight: FontWeight.bold),),

                          ],
                        ),
                      )
                  ),


                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
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
                          'Add Task ',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),

                      onTap: ()
                      {

                         getDate();
                        //addUserLate();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




class SplashScreenFirst extends StatefulWidget {
  @override
  String name;
  String designation;
  String email;
  Set<String> projects;
  List<int> hourList;

  SplashScreenFirst(String name, String designation, String email, Set<String> projects, List<int> hourList)
  {
    this.name = name;
    this.designation = designation;
    this.email = email;
    this.projects = projects;
    this.hourList = hourList;
  }

  _SplashScreenFirstState createState() => _SplashScreenFirstState();
}

class _SplashScreenFirstState extends State<SplashScreenFirst> {
  @override

  void navigationPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>  Task(widget.name, widget.designation, widget.email,widget.projects, widget.hourList)));
  }

  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void initState() {
    super.initState();
    startTime();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        color: Color.fromRGBO(250, 250, 250, 0.9),
        child: new Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: Center(
              child:
              Image.asset("assets/images/newloader.gif"),
            ),
          ),
        ),
      ),
    );
  }

}


 */