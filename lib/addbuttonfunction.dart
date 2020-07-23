import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class dataOutput extends StatefulWidget {
  @override
  _dataOutputState createState() => _dataOutputState();
}


class _dataOutputState extends State<dataOutput> {
  @override


  Future  getPosts()  async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("projects").getDocuments();
         return qn.documents;
  }


  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: new AppBar(
        title: new Text("Projects"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                      // scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,

                      itemBuilder: (_, index)
                      {

                        return Card(


                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0),),
                          child: GestureDetector(
                            child: new ListTile(
                              contentPadding: EdgeInsets.all(20.0),

                              title: Row(
                                children: <Widget>[

                                  new Text(snapshot.data[index].data['project']),
                                ],
                              ),



                        //      trailing: Icon(Icons.arrow_forward_ios),

                            ),

                            onTap: (){

                            },
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
