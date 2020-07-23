





import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'dart:math';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class DynamicWidget extends StatelessWidget {
  @override
  List<String> projectList;

  int number;
  int r1,r2,r3;
  List<String> applicationList;
  String projectDropDown;
  String applicationDropDown;
  DynamicWidget(List<String> projectList, int number, int r1, int r2, int r3, List<String> applicationList,String projectDropDown, String applicationDropDown)
  {
    this.projectList = projectList;
    this.number = number;
    this.r1 = r1;
    this.r2 = r2;
    this.r3 = r3;
    this.applicationList = applicationList;
    this.projectDropDown = projectDropDown;
    this.applicationDropDown = applicationDropDown;
  }

 

  //String dropDownValue = "DCM";
  int hours =0;
  //String applicationDropDown ="Solar";
  // List<DropdownMenuItem> itmes =['anda', 'fanda', danda];

  TextEditingController controller1 = new TextEditingController();

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[


        Container(
          height: 270,
          margin: new EdgeInsets.only(left:18.0, right: 18, top: 10),
          decoration: new BoxDecoration(
           //   borderRadius:  new BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: Colors.blue),
              color: Colors.grey[100],
              boxShadow: [BoxShadow(
                color: Colors.grey,
                blurRadius: 7.0,
              ),]
          ),

          child: Padding(
            padding: const EdgeInsets.only(right:12.0, top: 26, bottom: 12, left: 24),

            child: Column(
              children: <Widget>[


                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: new TextField(

                    // maxLengthEnforced: true,
                    keyboardType: TextInputType.text,
                    controller: controller1,
                    maxLength: 200,
                    maxLengthEnforced: true,
                    decoration: new InputDecoration(
                      // contentPadding: EdgeInsets.symmetric(vertical: 26,horizontal: 10),
                        border: OutlineInputBorder(),
                        hintText: "Add Task name",
                        labelText: "Add Task name"
                    ),
                  ),
                ),


                Column(
                  children: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text("Select Product:", style: new TextStyle(fontSize: 12),),
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
                              /*  return  DropdownButton<String>(
                                //  hint: Text('Project'),
                                  value:applicationDropDown,
                                  isExpanded: true,

                                  // style: Theme.of(context).textTheme.title,
                                  //  icon: Icon(Icons.arrow_drop_down,color: Colors.lightBlue,),

                                  onChanged: (String newValue) {
                                    setState(() {
                                      applicationDropDown = newValue;
                                    });


                                  },
                                  items: applicationList.cast<String>()

                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),

                                    );
                                  })
                                      .toList()
                              );        */

                              return SearchableDropdown.single(
                                items: applicationList.cast<String>()

                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,   ),

                                  );
                                })
                                    .toList(),
                                value: applicationDropDown,
                                hint: "Select one",
                                searchHint: "Select one",
                                onChanged: (value) {
                                  setState(() {
                                    applicationDropDown = value;
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


                Padding(
                  padding: const EdgeInsets.only(top:7.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        //  mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text("Select Customer:", style: new TextStyle(fontSize: 12),),

                          Container(

                            height: 50,
                            width: MediaQuery.of(context).size.width/2,
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
                                    return SearchableDropdown.single(
                                      items: projectList.cast<String>()

                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, ),

                                        );
                                      })
                                          .toList(),
                                      value: projectDropDown,
                                      hint: "Select one",
                                      searchHint: "Select one",
                                      onChanged: (value) {
                                        setState(() {
                                          projectDropDown = value;
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
                        width: MediaQuery.of(context).size.width/14,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text("Hours take:", style: new TextStyle(fontSize: 12),),
                          Container(
                            width:   MediaQuery.of(context).size.width/5,
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


              ],
            ),
          ),
        ),


        Padding(
          padding: const EdgeInsets.only(left: 17.8,top: 9.8),
          child: Container(







       //     margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
            // height: 60,
             width: 100,

            child: Stack(
              children: <Widget>[
                Image.asset("assets/images/cut.png", fit: BoxFit.cover,color:Color.fromARGB(255, r1, r2, r3),),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text("Task ${number.toString()}", style: new TextStyle(fontSize:16,color: Colors.white),),
                ),
              ],
            ),
          ),
        ),



    /*    Container(
          height: 240,
          width: MediaQuery.of(context).size.width/50,
          margin: new EdgeInsets.all(15.0),
          decoration: new BoxDecoration(
            borderRadius:  new BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),

            color: Color.fromARGB(255, r1, r2, r3),

          ),



        ),      */


      ],
    );
  }

}

class TriangluarClipper extends CustomClipper<Path>
{
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    final path = Path();
    path.lineTo(0,size.width);

    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }
  @override
  bool shouldReclip(TriangluarClipper oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}




/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class DynamicWidget extends StatelessWidget {
  @override
  List<String> projectList;

  int number;
  int r1,r2,r3;
  List<String> applicationList;
  String projectDropDown;
  String applicationDropDown;
  DynamicWidget(List<String> projectList, int number, int r1, int r2, int r3, List<String> applicationList,String projectDropDown, String applicationDropDown)
  {
    this.projectList = projectList;
    this.number = number;
    this.r1 = r1;
    this.r2 = r2;
    this.r3 = r3;
    this.applicationList = applicationList;
    this.projectDropDown = projectDropDown;
    this.applicationDropDown = applicationDropDown;
  }

  //String dropDownValue = "DCM";
  int hours =0;
  //String applicationDropDown ="Solar";
 // List<DropdownMenuItem> itmes =['anda', 'fanda', danda];

  TextEditingController controller1 = new TextEditingController();

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[


        Container(
          height: 240,
          margin: new EdgeInsets.all(15.0),
          decoration: new BoxDecoration(
              borderRadius:  new BorderRadius.all(Radius.circular(15)),

              color: Colors.grey[100],
              boxShadow: [BoxShadow(
                color: Colors.grey,
                blurRadius: 7.0,
              ),]
          ),

          child: Padding(
            padding: const EdgeInsets.only(right:12.0, top: 12, bottom: 12, left: 24),

            child: Column(
              children: <Widget>[


                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: new TextField(

                   // maxLengthEnforced: true,
                    keyboardType: TextInputType.multiline,
                    controller: controller1,
                    decoration: new InputDecoration(
                     // contentPadding: EdgeInsets.symmetric(vertical: 26,horizontal: 10),
                        border: OutlineInputBorder(),
                        hintText: "Add Task name Only",
                        labelText: "Add Task name only"
                    ),
                  ),
                ),
                new SizedBox(
                  height:6
                ),

                Column(
                  children: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text("Select Product:", style: new TextStyle(fontSize: 12),),
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
                            /*  return  DropdownButton<String>(
                                //  hint: Text('Project'),
                                  value:applicationDropDown,
                                  isExpanded: true,

                                  // style: Theme.of(context).textTheme.title,
                                  //  icon: Icon(Icons.arrow_drop_down,color: Colors.lightBlue,),

                                  onChanged: (String newValue) {
                                    setState(() {
                                      applicationDropDown = newValue;
                                    });


                                  },
                                  items: applicationList.cast<String>()

                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),

                                    );
                                  })
                                      .toList()
                              );        */

                            return SearchableDropdown.single(
                              items: applicationList.cast<String>()

                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, ),

                                );
                              })
                                  .toList(),
                              value: applicationDropDown,
                              hint: "Select one",
                              searchHint: "Select one",
                              onChanged: (value) {
                                setState(() {
                                  applicationDropDown = value;
                                });
                              },
                              isExpanded: true,
                             // label: "Select Project",

                              selectedValueWidgetFn: (item) {
                                return Container(
                                    transform: Matrix4.translationValues(-10,0,0),
                                    alignment: Alignment.centerLeft,
                                    child: (Text(item.toString())));
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


                Padding(
                  padding: const EdgeInsets.only(top:7.0),
                  child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                      //  mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text("Select Customer:", style: new TextStyle(fontSize: 12),),

                          Container(

                            height: 50,
                            width: MediaQuery.of(context).size.width/2,
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
                                  return SearchableDropdown.single(
                                    items: projectList.cast<String>()

                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value, ),

                                      );
                                    })
                                        .toList(),
                                    value: projectDropDown,
                                    hint: "Select one",
                                    searchHint: "Select one",
                                    onChanged: (value) {
                                      setState(() {
                                        projectDropDown = value;
                                      });
                                    },
                                    isExpanded: true,
                                    // label: "Select Project",

                                    selectedValueWidgetFn: (item) {
                                      return Container(
                                          transform: Matrix4.translationValues(-10,0,0),
                                          alignment: Alignment.centerLeft,
                                          child: (Text(item.toString())));
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
                            width:   MediaQuery.of(context).size.width/4,
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


              ],
            ),
          ),
        ),


        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
            // height: 60,
            //  width: 60,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, r1, r2, r3),
              shape: BoxShape.circle,
              //     borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(number.toString(), style: new TextStyle(fontSize:11,color: Colors.white),),
                )),
          ),
        ),



        Container(
          height: 240,
          width: MediaQuery.of(context).size.width/50,
          margin: new EdgeInsets.all(15.0),
          decoration: new BoxDecoration(
            borderRadius:  new BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),

            color: Color.fromARGB(255, r1, r2, r3),

          ),



        ),


      ],
    );
  }

}




 */