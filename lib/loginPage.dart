import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bezierContainer.dart';
import 'onboarding.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';


import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  String emailcond;

  bool isFull = false ;
  bool isPasswordCorrect  = false;

  bool isShowGreen = false;
  bool isShowRed = false;
  bool isEmailExist = false;
  bool isEmailCheckCorrect = false;
  bool isShow = true;
  bool isRed = false;
  DocumentSnapshot snapshot;
  bool isForget = false;
  bool isRed3 = false;

  String username = "blpcleanalerts@gmail.com";
  String password = "qwerty@1234";

  String name , designation;

  void navigationPage() {
    setState(() {
      isRed = false;
    });
  }

  void navigationforget()
  {
    setState(() {
      isForget = false;
    });
  }
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  forgetTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationforget);
  }

  void manSenPage() {
    setState(() {
      isRed3 = false;
    });
    print(isRed3);
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


  void signIn() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.
      if(_formKey.currentState.validate()){

        try{
          // await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passController.text);
          getPassword();
        }catch(e){
          print(e.message);
        }
      }
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


  }


  getEmailCheck()    async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").getDocuments();

    for(int i=0;i<qn.documents.length;i++)
    {
      if(qn.documents[i].data['email'].toString().toLowerCase() == emailController.text.toLowerCase())
      {
        isEmailCheckCorrect = true;
        snapshot = qn.documents[i];
        break;

      }
    }

    if(isEmailCheckCorrect)
    {
      isEmailCheckCorrect = false;
      sendEmail(snapshot);


    }
    else
    {
         setState(() {
           isRed = true;
         });
         startTime();
    }



  }


  void sendEmail(DocumentSnapshot snapshot)  async
  {

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Daily Sheet')
      ..recipients.add(snapshot.data['email'])

      ..subject = 'Password Changed :: '
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Password of your email is </h1>\n<p>" + snapshot.data['password'] + "</p>";



    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());


    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text("Password is sent to your email id"),
            backgroundColor: Colors.black

        )
    );
  }




  getPassword()    async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").getDocuments();

    for(int i=0;i<qn.documents.length;i++)
    {

      if(qn.documents[i].data['email'].toString().toLowerCase() == emailController.text.toLowerCase()  && qn.documents[i].data['password'] == passController.text)
      {

        isFull = true;
        name = qn.documents[i].data['name'];
        designation = qn.documents[i].data['designation'];
        emailcond = qn.documents[i].data['email'];
        break;
      }

      if(qn.documents[i].data['email'].toString().toLowerCase() == emailController.text.toLowerCase()  && qn.documents[i].data['password'] != passController.text)
      {
        isPasswordCorrect = true;
      }


    }

    if(isFull)
    {
// navigation is present here
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', emailcond);
      prefs.setString('name', name);
      prefs.setString('designation', designation);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SplashScreen(name, designation, emailcond)));
       print("password is correct");
      isFull = false;
    }
    else
    {
      if(isPasswordCorrect)
      {
        print("password is incorrect");
         noSencheck();

        isPasswordCorrect = false;
      }
      else
      {
        print("Login credentials are wrong");


      }
    }

  }

  performEmailCheck(String str) async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('todo').document("Kbf1V676TEjD7E2sZIbO").collection("loginDetails").getDocuments();

    for(int i=0;i<qn.documents.length;i++)
    {
      if(qn.documents[i].data['email'].toString().toLowerCase() == str.toLowerCase())
      {
        isEmailExist = true;
        break;
      }

    }
    if(isEmailExist)
    {
      isEmailExist = false;
      setState(() {
        isShowGreen = true;
        isShowRed = false;
      });
    }
    else
    {
      setState(() {
        isShowRed = true;
        isShowGreen = false;
      });
    }
    if(str == "")
    {
      setState(() {
        isShowRed = false;
        isShowGreen = false;
      });
    }

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
          'Login ',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),

      onTap: ()
      {
        signIn();
      },
    );
  }



  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Column(
       mainAxisAlignment: MainAxisAlignment.end,
      //  crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ? \n',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          GestureDetector(
            child: Text(
              'Register',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),

            onTap: ()
            {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpPage()));
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
              text: 'Sheet',
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
          ),   */
          new  TextFormField(
        //    key: _formKey,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
                        onChanged: (String str)
            {
              performEmailCheck(str);
            },


            decoration: InputDecoration(
              contentPadding: new EdgeInsets.symmetric(vertical: 16.0,horizontal: 10),
              border: OutlineInputBorder(),
              labelText: 'Email id',


              suffixIcon: isShowGreen? Icon(Icons.check, color: Colors.blue,) : Icon(Icons.check, color: Colors.transparent,)  ,

            ),
          ),

          if(isShowRed)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerRight,
              child: Text("Email doesn't exist. Kindly Register to login.",
                  style:
                  TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.red)),
            ),

          if(isRed)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerRight,
              child: Text('Email is incorrect',
                  style:
                  TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.red)),
            ),


          new SizedBox(
            height: 10,
          ),
        /*  Row(
            children: <Widget>[
              new Text("Password", style: new TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          ),  */
          new  TextFormField(

            controller: passController,

            obscureText: isShow? true: false,
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
          ),


          if(isRed3)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerRight,
              child: Text('Incorrect Password',
                  style:
                  TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.red)),
            ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: ()
        {

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginPage()));

        },

        child: SingleChildScrollView(
          child: SizedBox(
          //  width: MediaQuery.of(context).size.width,
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
                        SizedBox(
                          height: 20,
                        ),
                        _submitButton(),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Text('Forgot Password ?',
                                style:
                                TextStyle(color: isForget? Colors.lightBlue:Colors.black,fontSize: 14, fontWeight: FontWeight.w500)),
                          ),

                          onTap: ()
                          {
                            isForget = true;
                            forgetTime();
                            getEmailCheck();
                          },
                        ),

                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _createAccountLabel(),
                  ),

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
      ),
    );
  }
}



class SplashScreen extends StatefulWidget {
  @override
  String name;
  String designation;
  String email;
  SplashScreen(String name, String designation, String email)
  {
    this.name = name;
    this.designation = designation;
    this.email = email;
  }

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  void navigationPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>  Onboarding(widget.name, widget.designation, widget.email)));
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

                  image: AssetImage("assets/images/newfade.png"), fit: BoxFit.cover)),

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



