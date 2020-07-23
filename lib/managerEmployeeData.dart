import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'managerView.dart';
import 'onCardSelect.dart';
class employeeData extends StatefulWidget {
  @override
  String name;
  String designation;
  String email;
  Set<String> projects;
  List<int> hourList;
  employeeData(String name, String designation, String email, Set<String> projects, List<int> hourList)
  {
    this.name = name;
    this.designation = designation;
    this.email = email;
    this.projects = projects;
    this.hourList = hourList;
  }
  _employeeDataState createState() => _employeeDataState();
}

class _employeeDataState extends State<employeeData> {
  @override

  Future  getPosts()  async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").where("reportingMail", isEqualTo: widget.email ).getDocuments();
    return qn.documents;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Employee List"),

        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => managerView(widget.name, widget.designation, widget.email, widget.projects, widget.hourList)));
          },
        ),
      ),

      body: WillPopScope(

        onWillPop: ()
        {

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => managerView(widget.name, widget.designation, widget.email, widget.projects, widget.hourList)));

        },
        child: Container(
          child: new FutureBuilder(
              future: getPosts(),
              builder: (_,snapshot){

                if(snapshot.connectionState == ConnectionState.waiting)
                {
                  return new Text("loading");
                }
                else
                {
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,

                      itemBuilder: (_, index)
                      {
                        return Card(

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0),),
                          child: GestureDetector(
                            child: new ListTile(
                              contentPadding: EdgeInsets.all(20.0),


                              subtitle: new Text(snapshot.data[index].data['email']),


                            ),
                            onTap:()
                              {

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => onCardSelect(snapshot.data[index].data['email'].toString())));
                              }



                          ),
                        );

                      }
                  );

                }
              }),
        ),
      ),
    );
  }
}
