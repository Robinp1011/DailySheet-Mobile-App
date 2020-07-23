import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'util.dart';
import 'usertask.dart';
import 'task.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:search_choices/search_choices.dart';
import 'package:connectivity/connectivity.dart';

class editTask extends StatefulWidget {
  @override
  String name;
  String designation;
  String email;
  String task;
  String dropDownValue;
  int hours;
  List<String> projectList;
  DateTime date;
  String reference;
  Set<String> projects;
  List<int> hourList;
  String leave;
  List<String> applicationList;
  String applicationDropDown;
  String inTime;
  String outTime;



  editTask(String name, String designation, String email, String task, String dropDownValue,int hours, List<String> projectList, DateTime date, String reference
 , Set<String> projects,
  List<int> hourList, String leave, List<String> applicationList, String applicationDropDown, String inTime, String outTime
  )
  {
    this.name = name;
    this.designation = designation;
    this.email = email;
    this.task = task;
    this.dropDownValue = dropDownValue;
    this.hours = hours;
    this.projectList = projectList;
    this.date = date;
    this.reference = reference;
    this.projects = projects;
    this.hourList = hourList;
    this.leave = leave;
    this.applicationList = applicationList;
    this.applicationDropDown = applicationDropDown;
    this.inTime = inTime;
    this.outTime = outTime;

  }

  _editTaskState createState() => _editTaskState();
}

class _editTaskState extends State<editTask> {
  @override
  int hours;
  String dropDownValue;
  String applicationDropDown;
  TextEditingController controller1 = new TextEditingController();
  bool isLeave ;

  getLeave()
  {
    if(widget.leave == "yes")
      {
        setState(() {
          isLeave = true;
        });

      }
    else
      {
        setState(() {
          isLeave = false;
        });

      }
  }

  void initState()
  {
    controller1 = new TextEditingController(text: widget.task);
    hours = widget.hours;
    dropDownValue = widget.dropDownValue;
    applicationDropDown = widget.applicationDropDown;
    print("main chala");
    print(dropDownValue);
    print(widget.projectList);
    getLeave();
  }




  addUserLate() async{
    if(isLeave)
      {
        UserTask user = new UserTask(widget.email, "","", 0,widget.date, "yes","","","");

        print("yha bhi aaya");

        try {
          print("aya ky ander");
          Firestore.instance.runTransaction(
                (Transaction transaction) async {
              await Firestore.instance
                  .collection("todo")
                  .document("Kbf1V676TEjD7E2sZIbO").collection("task").document(widget.reference)
                  .setData(user.toJson());

            },
          );
        } catch (e) {
          print(e.toString());
        }

        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>Task(widget.name, widget.designation,widget.email, widget.projects, widget.hourList)));
        //Navigator.pop(context);

      }
    else
      {
        UserTask user = new UserTask(widget.email, dropDownValue,controller1.text , hours,widget.date, "no", applicationDropDown, widget.inTime, widget.outTime);

        print("yha bhi aaya");

        try {
          print("aya ky ander");
          Firestore.instance.runTransaction(
                (Transaction transaction) async {
              await Firestore.instance
                  .collection("todo")
                  .document("Kbf1V676TEjD7E2sZIbO").collection("task").document(widget.reference)
                  .setData(user.toJson());

            },
          );
        } catch (e) {
          print(e.toString());
        }




        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>Task(widget.name, widget.designation,widget.email, widget.projects, widget.hourList)));
        //Navigator.pop(context);

      }


  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Edit task"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[

                new SizedBox(
                  height: 20,
                ),
                new TextField(

                  keyboardType: TextInputType.text,
                  maxLength: 200,
                  maxLengthEnforced: true,
                  controller: controller1,
                  decoration: new InputDecoration(
                  //  contentPadding: EdgeInsets.symmetric(vertical: 26, horizontal: 10),
                      border: OutlineInputBorder(),
                      hintText: "Add Task name",
                      labelText: "Add Task name"
                  ),
                ),

                new SizedBox(
                  height: 8,
                ),

                Column(
                  children: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Align(child: new Text("Select Product:", style: new TextStyle(fontSize: 14),),
                          alignment: Alignment.topLeft,
                        ),
                      ],
                    ),

                    Container(

                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: ShapeDecoration(

                        shape: RoundedRectangleBorder(

                          side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:10.0),
                        child: StatefulBuilder(
                          //stream: null,
                            builder: (BuildContext context, StateSetter setState) {
                              return SearchChoices.single(
                                items: widget.applicationList.cast<String>()

                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),

                                  );
                                })
                                    .toList(),
                                value: applicationDropDown,
                                hint: "Select one",
                                searchHint: "Select one",

                               onChanged:  (value) {

                                  setState(() {
                                    print(value);
                                    applicationDropDown = value;
                                    print(value);
                                    print(applicationDropDown);
                                  });
                                },
                                selectedValueWidgetFn: (item) {
                                  return Container(
                                      transform: Matrix4.translationValues(-10,0,0),
                                      alignment: Alignment.centerLeft,
                                      child: (Text(item.toString(),overflow: TextOverflow.ellipsis)));
                                },

                                isExpanded: true,
                                // label: "Select Project",



                                // style: Theme.of(context).textTheme.title,
                                displayClearIcon: false,

                              );
                            }
                        ),
                      ),
                    ),
                  ],
                ),

                new SizedBox(
                  height: 20,
                ),


                Padding(
                  padding: const EdgeInsets.only(top:7.0),
                  child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        //  mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text("Select Customer:", style: new TextStyle(fontSize: 12),),

                          Container(

                            height: 50,
                            width: MediaQuery.of(context).size.width/1.8,
                            decoration: ShapeDecoration(

                              shape: RoundedRectangleBorder(

                                side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.blue),
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:10.0),
                              child: StatefulBuilder(
                                //stream: null,
                                  builder: (BuildContext context, StateSetter setState) {
                                    return  SearchChoices.single(
                                      items: widget.projectList.cast<String>()

                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),

                                        );
                                      })
                                          .toList(),
                                      value: dropDownValue,
                                      hint: "Select one",
                                      searchHint: "Select one",
                                      onChanged: (value) {
                                        setState(() {
                                          dropDownValue = value;
                                        });
                                      },
                                      isExpanded: true,
                                      // label: "Select Project",
                                      selectedValueWidgetFn: (item) {
                                        return Container(
                                            transform: Matrix4.translationValues(-10,0,0),
                                            alignment: Alignment.centerLeft,
                                            child: (Text(item.toString(),overflow: TextOverflow.ellipsis)));
                                      },


                                      // style: Theme.of(context).textTheme.title,
                                       displayClearIcon: false,

                                    );
                                  }
                              ),
                            ),
                          ),
                        ],



                       ),
                      new SizedBox(
                        width: MediaQuery.of(context).size.width/12,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text("Hours take:", style: new TextStyle(fontSize: 12),),
                          Container(
                            width:   MediaQuery.of(context).size.width/4.5,
                            height: 50,
                            child: /*new  TextFormField(

                                controller: hourController,
                                keyboardType: TextInputType.number,

                                onFieldSubmitted: (str)
                                {

                                },

                                decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                                  border: OutlineInputBorder(),



                                ),
                              ),   */

                            StatefulBuilder(

                                builder: (BuildContext context, StateSetter setState ) {
                                  return Container(
                                    decoration: ShapeDecoration(

                                      shape: RoundedRectangleBorder(

                                        side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.blue),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                    ),
                                    child: new Row(

                                      children: <Widget>[


                                        Expanded(
                                          child: GestureDetector(child: new Icon(Icons.remove, color: Colors.blue,size: 25,),
                                            onTap: ()
                                            {
                                              if(hours>0)
                                              {
                                                setState(() {
                                                  hours--;
                                                });  }
                                            },
                                          ),
                                        ),



                                        Expanded(child: Align(child: new Text(hours.toString(), style: new TextStyle(fontSize: 14),),
                                          alignment: Alignment.center,
                                        ),

                                        ),


                                        Expanded(
                                          child: GestureDetector(child: new Icon(Icons.add, color: Colors.blue,size:25,),
                                            onTap: ()
                                            {
                                              setState(() {
                                                hours++;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

               new SizedBox(
                 height: 20,
               ),

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
                                  setState(() {
                                    isLeave = !isLeave;
                                    //  _itemCount = 0;
                                    print(isLeave);
                                  });

                                }),
                          ),


                          new SizedBox(
                            width: 20,
                          ),
                          new Text(" Was on Leave" ,),
                        ],
                      ),
                    )
                ),

                new SizedBox(
                  height: 20,
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
                      'Update Task ',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),

                  onTap: ()  async
                  {


                    var connectivityResult = await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                      addUserLate();
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
