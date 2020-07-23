
import 'dart:async';
import 'package:flutter/material.dart';
import 'bezierContainer.dart';
import 'loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();

  String dropDownValue;
  bool isShow = true;
  bool isEmailExist = false;
  bool isRed = false;
  bool isRed2 = false;
  bool isManage = false;
  bool isSenManage = false;
  bool isRed3 = false;

   String reportingDropDown;
   String manReportingDropDown;
  bool isWidget = false;
  bool isManWidget = false;
  List<String> designation = [ "Senior Management" , "Employee", "Manager"];
  List<String> reporting = [];
  List<String> manReporting = [];
  
  getReportingMail() async
  {
    QuerySnapshot qn = await Firestore.instance.collection("todo").document("Kbf1V676TEjD7E2sZIbO").collection("mails").getDocuments();
    for(int i=0;i<qn.documents.length;i++)
      {
        reporting.add(qn.documents[i].data['email']);
      }
    QuerySnapshot qn2 = await Firestore.instance.collection("todo").document("Kbf1V676TEjD7E2sZIbO").collection("senmails").getDocuments();
    for(int i=0;i<qn2.documents.length;i++)
    {
      manReporting.add(qn2.documents[i].data['email']);
    }

  }

  void initState()
  {
    super.initState();
    getReportingMail();
  }

  void navigationPage() {
      setState(() {
        isRed = false;
      });
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }
  void manPage() {
    setState(() {
      isRed2 = false;
    });
    print(isRed2);
  }

  manTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, manPage);
  }
  nocheck()
  {
    setState(() {
      isRed2 = true;
    });
    manTime();

  }

  void manSenPage() {
    setState(() {
      isRed3 = false;
    });
    print(isRed2);
  }
  manSenTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, manSenPage);
  }
  noSencheck()
  {
    setState(() {
      isRed3 = true;
    });
    manSenTime();

  }

  managementCheck() async
{
  var firestore = Firestore.instance;
  QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("mails").getDocuments();

  for(int i=0;i<qn.documents.length;i++)
    {
       // print("yha aaya mein");
      //  print(qn.documents[i].data['email']);
      if(qn.documents[i].data['email'] == emailController.text)
        {
           isManage = true;
           break;
        }
    }
 // print(isManage);
     if(isManage)
       {
         addUserLate();
         isManage = false;
       }
     else
       {
         nocheck();
       }

}


  seniormanagementCheck() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("senmails").getDocuments();

    for(int i=0;i<qn.documents.length;i++)
    {
      // print("yha aaya mein");
      //  print(qn.documents[i].data['email']);
      if(qn.documents[i].data['email'] == emailController.text)
      {
        isSenManage = true;
        break;
      }
    }
    // print(isManage);
    if(isSenManage)
    {
      addUserLate();
      isSenManage = false;
    }
    else
    {
      noSencheck();
    }

  }

  addUserLate() async{

    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").getDocuments();

    for(int i=0;i<qn.documents.length;i++)
    {
      if(qn.documents[i].data['email'] == emailController.text)
      {
        isEmailExist = true;
        break;
      }

    }

    if(isEmailExist)
      {
               setState(() {
                 isRed = true;
               });
               startTime();
               isEmailExist = false;
      }
    else
      {

         if(dropDownValue == "Employee")
           {
             User user = new User(emailController.text, passController.text, dropDownValue,nameController.text, reportingDropDown);


             try {
               print("employee ky ander");
               Firestore.instance.runTransaction(
                     (Transaction transaction) async {
                   await Firestore.instance
                       .collection("todo")
                       .document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").document()
                       .setData(user.toJson());

                 },
               );
             } catch (e) {
               print(e.toString());
             }

             Navigator.push(context,
                 MaterialPageRoute(builder: (context) => SplashScreenSign(nameController.text,dropDownValue)));

           }
         else if(dropDownValue == "Manager")
           {

             User user = new User(emailController.text, passController.text, dropDownValue,nameController.text, manReportingDropDown);


             try {
               print("Manager ky ander");
               Firestore.instance.runTransaction(
                     (Transaction transaction) async {
                   await Firestore.instance
                       .collection("todo")
                       .document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").document()
                       .setData(user.toJson());

                 },
               );
             } catch (e) {
               print(e.toString());
             }

             Navigator.push(context,
                 MaterialPageRoute(builder: (context) => SplashScreenSign(nameController.text,dropDownValue)));
           }

         else
           {
             User user = new User(emailController.text, passController.text, dropDownValue,nameController.text,"");


             try {
               print("seniro aya ky ander");
               Firestore.instance.runTransaction(
                     (Transaction transaction) async {
                   await Firestore.instance
                       .collection("todo")
                       .document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").document()
                       .setData(user.toJson());

                 },
               );
             } catch (e) {
               print(e.toString());
             }

             Navigator.push(context,
                 MaterialPageRoute(builder: (context) => SplashScreenSign(nameController.text,dropDownValue)));

           }

      }

  }




  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }


  Widget _submitButton() {
    return GestureDetector(
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
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      onTap: ()
      {
        if(_formKey.currentState.validate())
          {
            if( dropDownValue == "Manager")
              {
                managementCheck();
              }
            else if(dropDownValue == "Senior Management")
              {
                seniormanagementCheck();
              }
            else
              {
                addUserLate();
              }

          }

      },

    );
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

           new SizedBox(
             height: 10,
           ),
          GestureDetector(
            child: Text(
              'Login',
              style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),

            onTap: ()
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          )
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Daily',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.lightBlue,
          ),
          children: [
            TextSpan(
              text: "Sheet",
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),

          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[

       /*   Row(
            children: <Widget>[
              new Text("Email id", style: new TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          ),  */

          new  TextFormField(
            //    key: _formKey,
            controller: nameController,
            keyboardType: TextInputType.text,
            validator: (val){
              if (val.length == 0)
                return "Please enter Name";
              if(val.trim().length==0)
                return "Please enter Name";

              else
                return null;
            },


            decoration: InputDecoration(
              contentPadding: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
              border: OutlineInputBorder(),
              labelText: 'Name',

            ),
          ),

          SizedBox(
            height: 10,
          ),
          Container(
            decoration: ShapeDecoration(

              shape: RoundedRectangleBorder(

                side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: DropdownButton<String>(
                  hint: Text('Designation'),
                  value:dropDownValue,
                  isExpanded: true,

                  // style: Theme.of(context).textTheme.title,
                  icon: Icon(Icons.arrow_drop_down,color: Colors.lightBlue,),

                  onChanged: (String newValue) {

                    setState(() {
                      dropDownValue = newValue;
                      if(newValue == "Employee")
                        {
                          setState(() {
                            isWidget = true;
                            isManWidget = false;
                          });
                        }
                      else if(newValue == "Manager")
                        {
                          setState(() {
                            isManWidget = true;
                            isWidget = false;
                          });
                        }
                      else
                        {
                          setState(() {
                            isWidget = false;
                            isManWidget = false;

                          });
                        }



                    });

                  },
                  items:  designation

                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                      ),

                    );
                  })
                      .toList()
              ),
            ),
          ),


         if(isWidget)
          Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: ShapeDecoration(

                  shape: RoundedRectangleBorder(

                    side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0),
                  child: DropdownButton<String>(
                      hint: Text('Reporting To'),
                      value: reportingDropDown,
                      isExpanded: true,

                      // style: Theme.of(context).textTheme.title,
                      icon: Icon(Icons.arrow_drop_down,color: Colors.lightBlue,),

                      onChanged: (String newValue) {

                        setState(() {
                          reportingDropDown = newValue;



                        });

                      },
                      items:  reporting

                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                          ),

                        );
                      })
                          .toList()
                  ),
                ),
              ),
            ],
          ),

          if(isManWidget)
            Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: ShapeDecoration(

                    shape: RoundedRectangleBorder(

                      side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                    child: DropdownButton<String>(
                        hint: Text('Reporting To'),
                        value: manReportingDropDown,
                        isExpanded: true,

                        // style: Theme.of(context).textTheme.title,
                        icon: Icon(Icons.arrow_drop_down,color: Colors.lightBlue,),

                        onChanged: (String newValue) {

                          setState(() {
                            manReportingDropDown = newValue;



                          });

                        },
                        items:  manReporting

                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                            ),

                          );
                        })
                            .toList()
                    ),
                  ),
                ),
              ],
            ),

          new SizedBox(
            height: 10,
          ),

          new  TextFormField(
            //    key: _formKey,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (val){
              if (val.length == 0)
                return "Please enter email";
              else if (!val.contains("@blp.co.in"))
                return "Please enter valid email";
              else
                return null;
            },


            decoration: InputDecoration(
              contentPadding: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
              border: OutlineInputBorder(),
              labelText: 'Email id',

            ),
          ),

          if(isRed)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerRight,
              child: Text('Email already exist',
                  style:
                  TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.red)),
            ),
          if(isRed2)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerRight,
              child: Text('Not a Manager mail',
                  style:
                  TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.red)),
            ),
          if(isRed3)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerRight,
              child: Text('Not a Senior Management mail',
                  style:
                  TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.red)),
            ),






          new SizedBox(
            height: 10,
          ),

          new  TextFormField(

            controller: passController,
            obscureText: isShow? true: false,
          //  obscureText: true,
            validator: (val){
              if (val.length == 0)
                return "Please enter password";
              else if (val.length <= 5)
                return "Your password should be more then 6 char long";
              else
                return null;
            },

            decoration: InputDecoration(

              suffixIcon:GestureDetector(child: isShow? Icon(Icons.remove_red_eye) : Icon(Icons.visibility_off),onTap:(){
                setState(() {
                  isShow = !isShow;
                });
              } ,),
              contentPadding: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
              border: OutlineInputBorder(),
              labelText: 'Password',

            ),
          )

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: SizedBox(),
                      ),
                      _title(),
                      SizedBox(
                        height: 50,
                      ),

                      _emailPasswordWidget(),



                      new SizedBox(
                        height: 20,
                      ),
                      _submitButton(),
                      Expanded(
                        flex: 2,
                        child: SizedBox(),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _loginAccountLabel(),
                ),
              //  Positioned(top: 40, left: 0, child: _backButton()),
                Positioned(
                    top: -MediaQuery.of(context).size.height * .15,
                    right: -MediaQuery.of(context).size.width * .4,
                    child: BezierContainer()),

                Positioned(
                  top: 55,
                  left: 10,
                  child: Image.asset("assets/images/aloginlogo.png", width: 75, height: 75,),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class registrationComplete extends StatefulWidget {
  @override
  String name;
  String designation;
  registrationComplete(String name, String designation)
  {
    this.name = name;
    this.designation = designation;
  }

  _registrationCompleteState createState() => _registrationCompleteState();
}

class _registrationCompleteState extends State<registrationComplete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              new SizedBox(
                height: 80,
              ),

              new Text("SUCCESS", style: new TextStyle(fontSize: 21,),),
              new SizedBox(
                height: 20,
              ),
              Image.asset("assets/images/success.png", width:240, height:240),
              new SizedBox(
                height: 20,
              ),
              new Text("${widget.name} Registered", style: new TextStyle(fontSize: 21,),),
              new SizedBox(
                height: 15,
              ),
              new Text("${widget.designation} has been register"),
                new SizedBox(
                  height: 3,
                ),
              new Text("successfully with this device"),

              Padding(
                padding: const EdgeInsets.all(40.0),
                child: GestureDetector(
                  child: Container(
                      height: 50.0,
                      // width: 300.0,
                      width : MediaQuery.of(context).size.width ,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.lightBlue,
                        color: Colors.lightBlue,
                        elevation: 7.0,
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Montserrat'),
                          ),
                        ),
                      )),

                  onTap: ()
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>  LoginPage()));
                  },
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}




class SplashScreenSign extends StatefulWidget {
  @override
  String name;
  String designation;
  SplashScreenSign(String name, String designation)
  {
    this.name = name;
    this.designation = designation;
  }

  _SplashScreenSignState createState() => _SplashScreenSignState();
}

class _SplashScreenSignState extends State<SplashScreenSign> {
  @override

  void navigationPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>  registrationComplete(widget.name, widget.designation)));
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
        color: Colors.white,
        child: Container(

          decoration: BoxDecoration(
              image: DecorationImage(
                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),

                  image: AssetImage("assets/images/signupfade.png"), fit: BoxFit.cover)),

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
      ),
    );
  }

}



