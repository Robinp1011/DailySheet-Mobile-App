

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loginPage.dart';
import 'package:flutter/services.dart';

import 'package:flutter_statusbar_text_color/flutter_statusbar_text_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding.dart';






  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var name = prefs.getString('name');
    var designation = prefs.getString('designation');
    print(email);
    runApp(MyApp(name, designation, email));
  }


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  String email;
  String designation;
  String name;
  MyApp(String name, String designation, String email)
  {
    this.name = name;
    this.designation = designation;
    this.email = email;
  }

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'RobotoMono',
          primarySwatch: Colors.blue,
        //  textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
         //   body1: GoogleFonts.montserrat(textStyle: textTheme.body1, ),
        //  ),
        ),
        debugShowCheckedModeBanner: false,
        supportedLocales: const[Locale('en','US')],
        home: email == null?LoginPage():Onboarding(name, designation, email),
      ),

     onTap: ()
      {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus)
          {
            currentFocus.unfocus();
          }
      },
    );
  }
}
