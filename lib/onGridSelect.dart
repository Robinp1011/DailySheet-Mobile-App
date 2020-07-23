import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'util.dart';
import 'package:intl/intl.dart';
import 'package:expandable/expandable.dart';

class onGridSelect extends StatefulWidget {
  @override
  String email;
  String project;
  onGridSelect(String email, String project)
  {
    this.email = email;
    this.project = project;
  }
  _onGridSelectState createState() => _onGridSelectState();
}

class _onGridSelectState extends State<onGridSelect> {
  @override

  Future  getPosts()  async
  {

    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("todo").document("Kbf1V676TEjD7E2sZIbO").collection("task")
        .where("email", isEqualTo: widget.email).where("project", isEqualTo: widget.project).orderBy("date", descending: true).getDocuments();
    return qn.documents;
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Tasks of ${widget.project}"),
      ),
      
      body: Container(
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

                            

                            )


                        ],
                      );



                      SizedBox(height: 15);
                    }
                );
            }
        ),
      ),
    );
  }
}
