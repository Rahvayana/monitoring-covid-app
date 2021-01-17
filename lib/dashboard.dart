import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:monitoring_covid_app/contact.dart';
import 'package:monitoring_covid_app/home.dart';
import 'package:monitoring_covid_app/maps.dart';
import 'package:monitoring_covid_app/post.dart';

class MainWidget extends StatefulWidget {
  @override
  MainWidgetState createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  int currentTab = 0;
  final List<Widget> screens = [Home(), Post(), Contact()];
  Widget currentScreen = Home();

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: PageStorage(child: currentScreen, bucket: bucket),
        bottomNavigationBar: bmnav.BottomNav(
          index: currentTab,
          labelStyle: bmnav.LabelStyle(visible: false),
          onTap: (i) {
            setState(() {
              currentTab = i;
              currentScreen = screens[i];
            });
          },
          items: [
            bmnav.BottomNavItem(Icons.home, label: 'Home'),
            bmnav.BottomNavItem(Icons.library_books, label: 'Post'),
            bmnav.BottomNavItem(Icons.contact_phone, label: 'Contact'),
            // bmnav.BottomNavItem(Icons.map, label: 'Maps'),
          ],
        ),
      ),
    );
  }
}
