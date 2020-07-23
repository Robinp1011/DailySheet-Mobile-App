import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'util.dart';
import 'onGridSelect.dart';

class onCardSelect extends StatefulWidget {
  @override
  String email;
  onCardSelect(String email)
  {
    this.email = email;
  }
  _onCardSelectState createState() => _onCardSelectState();
}

class _onCardSelectState extends State<onCardSelect> {
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
      if(qn.documents[i].data['leave'] == "no")
        projects.add(qn.documents[i].data['project']);
      else
        continue;
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
      setState(() {
        hourList.add(hours);
        taskCount.add(qn.documents.length);
      });

    }
    print(hourList);
    //_createSampleData();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Projects of ${widget.email}"),
      ),

      body:  Container(
        height: MediaQuery.of(context).size.height/1.1,
        width: MediaQuery.of(context).size.width,
        child:
        GridView.builder(
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount:taskCount.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,

          itemBuilder: (BuildContext context, int index) {



            return

              GestureDetector(
                child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Container(
                            width: 90,
                            height: 90,
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: new Text(projects.elementAt(index)),
                                )),
                            decoration: const BoxDecoration(
                              color: CustomColors.GreenBackground,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),

                          Text (
                            "Hours: ${hourList.elementAt(index)}",
                            style: TextStyle(
                                fontSize: 17,
                                color: CustomColors.TextHeaderGrey,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "No. of Tasks: ${taskCount.elementAt(index)}",
                            style: TextStyle(
                                fontSize: 14,
                                color: CustomColors.TextSubHeaderGrey),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
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
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.all(10),
                    height: 150.0),

                onTap: ()
                {

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => onGridSelect(widget.email,projects.elementAt(index))));
                },

              );



          },

        ),


      ),
    );
  }
}
