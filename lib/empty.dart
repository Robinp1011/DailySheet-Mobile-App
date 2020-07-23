import 'package:flutter/material.dart';

import 'appBars.dart';
import 'bottomNavigation.dart';
//import 'package:flutter_todolist/fab.dart';
import 'util.dart';
import 'onboarding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bottomSheet.dart';
import 'firstdataenterscreen.dart';

class Empty extends StatefulWidget {
     String name;
     String designation;
     String email;
     Empty(String name, String designation, String email)
     {
       this.name = name;
       this.designation = designation;
       this.email = email;
     }

  _EmptyState createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  var bottomNavigationBarIndex = 0;
  var names;

   List<dynamic>  projectList=[];
   Modal modal = new Modal();

  getList() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("projects").getDocuments();
    projectList = qn.documents[0].data['projectlist'];
    getNavigate();

    //     addList(str);
  }



  getNavigate()
  {
   // Navigator.push(context,
    //    MaterialPageRoute(builder: (context) => IstScreen(projectList, widget.name, widget.designation, firstLetter,lastname, widget.email)));

  }

  void initState()
  {
    super.initState();
   // getList();
    var  names = widget.name.split(' ');
    if(names.length == 1)
      {
        firstLetter = names[0].substring(0,1).toUpperCase();
        lastname = "";
      }
    else {
   firstLetter = names[0].substring(0,1).toUpperCase();
    lastname = names[1].substring(0,1).toUpperCase();
    print(lastname) ;  }





  }

  String firstLetter;
  String lastname;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: emptyAppbar(context, widget.name, widget.designation,firstLetter, lastname ),
      body: WillPopScope(
        onWillPop: ()
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Onboarding(widget.name,widget.designation, widget.email)));
        },
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Hero(
                    tag: 'Clipboard',
                    child: Image.asset('assets/images/Clipboard-empty.png'),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'No tasks',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: CustomColors.TextHeader),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'You have no tasks to do.',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: CustomColors.TextBody,
                            fontFamily: 'opensans'),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         getList();
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
    //  bottomNavigationBar: BottomNavigationBarApp(bottomNavigationBarIndex, context, widget.name,widget.designation, widget.email),
    );
  }
}
