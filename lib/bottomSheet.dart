import 'package:flutter/material.dart';

import 'home.dart';
import 'util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dynamicWidget.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';



class Modal {


  mainBottomSheet(BuildContext context, List<dynamic> projectList) {



    TextEditingController taskController = new TextEditingController();
    List<DynamicWidget> widgetList = [];
     DateTime _dateTime = DateTime.now();

    String name;

     TimeOfDay stTime = TimeOfDay.now();
     TimeOfDay picked;

   String stTimeStr =  stTime.toString().substring(10, 15);
    String endTimeStr =  stTime.toString().substring(10, 15);




    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height - 80,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height / 25,
                left: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(175, 30),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 340,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Image.asset('assets/images/fab-delete.png'),
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
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Text(
                            'fill your worksheet for Today',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),

                          SizedBox(height: 10),


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

                                    new Text("Choose Date", style: new TextStyle(color: Colors.grey, fontSize:10),),
                                   // new Text(totalEnergyConsumption.toString(), style: new TextStyle(color: Colors.white),),

                                    new SizedBox(
                                      height: 3,
                                    ),

                                    StatefulBuilder(
                                     // stream: null,
                                        builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                        return GestureDetector(child: new Text(DateFormat('MM/dd/yyyy').format(_dateTime).toString(), style: new TextStyle( fontSize:12),),
                                        onTap: ()
                                          {
                                            showDatePicker(
                                                context: context,
                                                initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                                firstDate: DateTime(2001),
                                                lastDate: DateTime(2026)
                                            ).then((date) {

                                              setState(
                                                      (){
                                                    _dateTime = date;
                                                  }
                                              );

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

                                Container(height: 35, child: VerticalDivider(color: Colors.black, width: 10,)),
                                Row(
                                  children: <Widget>[

                                    new SizedBox(
                                      height: 4,
                                    ),

                                    Column(
                                      children: <Widget>[
                                        new Text("StartTime", style: new TextStyle(color: Colors.grey, fontSize: 10),),

                                        new SizedBox(
                                          height: 3,
                                        ),
                                        StatefulBuilder(
                                          // stream: null,
                                            builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                              return GestureDetector(child: new Text(stTimeStr, style: new TextStyle( fontSize:12),),
                                                onTap: () async
                                                {
                                                  TimeOfDay timepick = await showTimePicker(
                                                      context: context, initialTime: new TimeOfDay.now());

                                                  if (timepick != null) {
                                                    setState(() {
                                                      stTimeStr = timepick.toString().substring(10, 15);
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
                                        new Text("EndTime", style: new TextStyle(color: Colors.grey, fontSize: 10),),

                                       new SizedBox(
                                         height: 3,
                                       ),
                                        StatefulBuilder(
                                          // stream: null,
                                            builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                                              return GestureDetector(child: new Text(endTimeStr, style: new TextStyle( fontSize:12),),
                                                onTap: () async
                                                {
                                                  TimeOfDay timepick = await showTimePicker(
                                                      context: context, initialTime: new TimeOfDay.now());

                                                  if (timepick != null) {
                                                    setState(() {
                                                      endTimeStr = timepick.toString().substring(10, 15);
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

                          SizedBox(height: 5),

                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                        //    height: 80,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 1.0,
                                  color: CustomColors.GreyBorder,
                                ),
                                bottom: BorderSide(
                                  width: 1.0,
                                  color: CustomColors.GreyBorder,
                                ),
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              new Text("Task Planning", style: new TextStyle( fontSize: 12, fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          new Text("How many tasks you are planning to complete today?", style: new TextStyle(color: Colors.grey, fontSize: 10),),
                                        ],
                                      ),

                                      new SizedBox(
                                        width: 30,
                                      ),

                                      StatefulBuilder(
                                      //  stream: null,
                                          builder: (BuildContext context, StateSetter setState /*You can rename this!*/)  {
                                          return Container(
                                            width: 50,
                                            height: 40,
                                            child: new  TextFormField(

                                              controller: taskController,
                                              keyboardType: TextInputType.number,

                                              onFieldSubmitted: (str)   async
                                              {

                                                setState(()  {
                                                 // getList(str);
                                                //  getList(str);
                                               //   print(projectList);

                                                  for(int i=0;i<int.parse(str);i++)
                                                  {
                                                    print(projectList);

                                                 //   widgetList.add(new DynamicWidget(projectList));
                                                  }
                                                });

                                              },

                                              decoration: InputDecoration(
                                                contentPadding: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                                                border: OutlineInputBorder(),



                                              ),
                                            ),
                                          );
                                        }
                                      ),
                                    ],

                                ),




                          SizedBox(height: 10),


                                Container(
                                  height: 60,
                                  child: ListView(
                                    children: <Widget>[
                                      Column(children: widgetList,),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ),
                          SizedBox(height: 20),
                          RaisedButton(
                            onPressed: () {

                              // Navigator.pop(context);
                            },
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 60,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    CustomColors.BlueLight,
                                    CustomColors.BlueDark,
                                  ],
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: CustomColors.BlueShadow,
                                    blurRadius: 2.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0.0, 0.0),
                                  ),
                                ],
                              ),
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Center(
                                child: const Text(
                                  'Add task',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
