import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'firstdataenterscreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'appBars.dart';
import 'bottomNavigation.dart';
import 'fab.dart';
import 'util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'profilePage.dart';
import 'package:expandable/expandable.dart';
import 'onboarding.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';



class OrdinalSales {
  final String year;
  final double sales;

  OrdinalSales(this.year, this.sales);
}


class Home extends StatefulWidget {
//  Home({Key key}) : super(key: key);
   String name;
   String designation;
   String email;
   Set<String> projects;
   List<int> hourList;

   Home(String name, String desgination, String email, Set<String> projects, List<int> hourList)
   {
     this.name = name;
     this.designation = desgination;
     this.email = email;
     this.projects = projects;
     this.hourList = hourList;

   }
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final bottomNavigationBarIndex = 0;
 Random rand = new Random();

 List<charts.Series<OrdinalSales, String>> seriesList=[] ;
 List<OrdinalSales> data = [];
   List<String> projectList = [];
  List<String> applicationList = [];

   int r1, r2, r3;
  Set<String> projects ={};
  List<int> hourList =[];
  List<int> taskCount = [];
  String name = "";

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

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration,_createSampleData);
  }


  void initState()
  {
    super.initState();
    // getList();

       getName();
       getProject();
     // startTime();
   _createSampleData();
  }

  String firstLetter="";
  String lastname="";



  getList() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("customerList").getDocuments();
    for(int i=0;i<qn.documents.length;i++)
      {
        projectList.add(qn.documents[i].data['name']);

      }
    print(projectList);

    QuerySnapshot qn2 = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("projects").getDocuments();
    for(int i=0;i<qn2.documents.length;i++)
      {

        applicationList.add(qn2.documents[i].data['name']);
      }
    print(applicationList);
 //   applicationList = qn2.documents[0].data['applicationList'];
    getNavigate();

    //     addList(str);
  }
  getNavigate()
  {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => IstScreen(projectList, widget.name, widget.designation, firstLetter,lastname, widget.email, widget.projects, widget.hourList, applicationList)));

  }


  Future  getPosts()  async
  {
     print(widget.email);
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("todo").document("Kbf1V676TEjD7E2sZIbO").collection("task").where("email", isEqualTo: widget.email).orderBy("date", descending: true). getDocuments();
    return qn.documents;
  }


   void  _createSampleData() {
     List<OrdinalSales> data = [];
    for(int i=0;i<widget.hourList.length;i++)
        {
              if(widget.projects.elementAt(i) !="")
                {
                  data.add( new OrdinalSales(widget.projects.elementAt(i),widget.hourList.elementAt(i).toDouble()));

                }

        //  data.add( new OrdinalSales(projects.elementAt(i),hourList.elementAt(i)));
         // print(data);

        }

    /* data = [
       new OrdinalSales(widget.projects.elementAt(0), widget.hourList.elementAt(0).toDouble()),
       new OrdinalSales('2015', 25),
       new OrdinalSales('2016', 100),
       new OrdinalSales('2017', 75),
     ];   */
     print(data);


      seriesList.add( new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
          labelAccessorFn: (OrdinalSales sales, _) =>
          '${sales.sales.toString()}')
      )
      ;
      print(seriesList);









  }
  void SampleData()
  {
    setState(() {

      seriesList.add( new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      ))
      ;
      print(seriesList);


    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: GradientAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Onboarding(widget.name, widget.designation, widget.email)));

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
                  if(hourList.length<2)
                    Text(
                      'you are working on ${hourList.length} project',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                    )
                  else
                    Text(
                      'you are working on ${hourList.length} projects',
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
              margin: EdgeInsets.fromLTRB(0, 0, 20,8),
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
            onTap: ()  async
            {

              var connectivityResult = await (Connectivity().checkConnectivity());
              if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage(widget.name, widget.designation, widget.email,widget.projects, widget.hourList)));
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




      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[


              if(taskCount.length == 0)
            WillPopScope(
              onWillPop:  ()
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Onboarding(widget.name, widget.designation, widget.email)));
              },
              child: Center(
              child: Container(
              width: MediaQuery.of(context).size.width / 1.2,
                height:MediaQuery.of(context).size.height/1.5,
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
            )

                else
              WillPopScope(
                onWillPop:  ()
                {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Onboarding(widget.name, widget.designation, widget.email)));
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Container(
                             height:MediaQuery.of(context).size.height/2.7,
                        child: new charts.BarChart(

                          seriesList,
                          animate:true,

                          barRendererDecorator: charts.BarLabelDecorator<String>(
                            labelAnchor: charts.BarLabelAnchor.middle,
                            labelPosition: charts.BarLabelPosition.outside,

                          ),

                          domainAxis: new charts.OrdinalAxisSpec(
                            viewport: new charts.OrdinalViewport('AePS', 5),
                            renderSpec: new charts.SmallTickRendererSpec(
                                minimumPaddingBetweenLabelsPx: 2,
                                // Tick and Label styling here.
                                labelStyle: new charts.TextStyleSpec(
                                fontSize: 9, // size in Pts.
                            ),

                          ),   ),
                          behaviors: [

                            new charts.ChartTitle('Projects',
                                behaviorPosition: charts.BehaviorPosition.bottom,
                                titleOutsideJustification:
                                charts.OutsideJustification.middleDrawArea),
                            new charts.ChartTitle("Hours",
                                behaviorPosition: charts.BehaviorPosition.start,
                                 titleOutsideJustification:
                                charts.OutsideJustification.middleDrawArea),
                         //   new charts.PanAndZoomBehavior(),
                           // new charts.SeriesLegend(),
                            new charts.SlidingViewport(),
                          new charts.PanBehavior(),
                          //  new charts.PanAndZoomBehavior(),
                            //  new charts.SeriesLegend(),


                          ],
                     //       animationDuration: Duration(seconds: 5),
                        ),
                      ),

                      Container(
                        height: MediaQuery.of(context).size.height/2.26,
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

                                        Container(
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
                                            height: 150.0);



                                  },

                                ),


                      ),
                    ],
                  ),
                ),
              ),
            ],
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
          BottomNavigationBarApp(bottomNavigationBarIndex, context, widget.name,widget.designation, widget.email, widget.projects, widget.hourList),
    );
  }
}


