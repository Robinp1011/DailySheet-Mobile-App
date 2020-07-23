

import 'package:flutter/material.dart';

import 'home.dart';
import 'task.dart';
import 'util.dart';


class BottomNavigationBarApp extends StatelessWidget {
   int bottomNavigationBarIndex;
   BuildContext context;
  String name;
  String designation;
  String email;
   Set<String> projects;
   List<int> hourList;


   BottomNavigationBarApp(int bottomNavigationBarIndex,BuildContext context, String name, String designation, String email,
       Set<String> projects, List<int> hourList
     )
  {
    this.bottomNavigationBarIndex = bottomNavigationBarIndex;
    this.context = context;
    this.name = name;
    this.designation = designation;
    this.email = email;
    this.hourList = hourList;
    this.projects = projects;

  }





  void onTabTapped(int index) {
    Navigator.of(context).push(
      MaterialPageRoute<Null>(builder: (BuildContext context) {
        return (index == 1) ? Task(name, designation, email, projects, hourList) : Home(name, designation, email,projects, hourList);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: bottomNavigationBarIndex,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 10,
      selectedLabelStyle: TextStyle(color: CustomColors.BlueDark),
      selectedItemColor: CustomColors.BlueDark,
      unselectedFontSize: 10,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Image.asset(
              'assets/images/home.png',
              color: (bottomNavigationBarIndex == 0)
                  ? CustomColors.BlueDark
                  : CustomColors.TextGrey,
            ),
          ),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Image.asset(
              'assets/images/task.png',
              color: (bottomNavigationBarIndex == 1)
                  ? CustomColors.BlueDark
                  : CustomColors.TextGrey,
            ),
          ),
          title: Text('Task'),
        ),
      ],
      onTap: onTabTapped,
    );
  }
}
