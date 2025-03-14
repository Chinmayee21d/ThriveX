import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/pages/booking.dart';
import 'package:untitled2/pages/home.dart';
import 'package:untitled2/pages/profile.dart';
class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  late List<Widget> pages;
  late Home home;
  late Booking booking;
  late Profile profile;
  int currentTabIndex=0;

  @override
  void initState() {
    home=Home();
    booking=Booking();
    profile=Profile();
    pages=[home,booking,profile];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:CurvedNavigationBar(
          height: 65,
          backgroundColor: Color(0xFF151434),
          color: Color(0xA901011B
          ),
          animationDuration: Duration(milliseconds: 500),
          onTap: (int index){
            setState(() {
              currentTabIndex=index;
            });
          },
          items: [
            Icon(
                Icons.home_outlined,size: 30.0,
                color: Colors.white,
            ),
            Icon(
              Icons.book,size: 30.0,
              color:Colors.white,
            ),
            Icon(
              Icons.person_outline,size: 30.0,
              color: Colors.white,
            )

          ]),
      body:pages[currentTabIndex],
    );
  }
}
