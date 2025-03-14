import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/admin/admin_profile.dart';
import 'package:untitled2/admin/ticket_event.dart';
import 'package:untitled2/admin/upload_event.dart';
class AdminBottomnav extends StatefulWidget {
  const AdminBottomnav({super.key});

  @override
  State<AdminBottomnav> createState() => _AdminBottomnavState();
}

class _AdminBottomnavState extends State<AdminBottomnav> {
  late List<Widget> pages;
  late UploadEvent Upload;
  late TicketEvent Ticket;
  late AdminProfile Profile;
  int currentTabIndex=0;

  @override
  void initState() {

    Upload=UploadEvent();
    Ticket=TicketEvent();
    Profile=AdminProfile();
    pages=[Upload,Ticket,Profile];
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
              Icons.cloud_upload_rounded,size: 30.0,
              color:Colors.white,
            ),
            Icon(
              Icons.event_note,size: 30.0,
              color: Colors.white,
            ),
            Icon(
              Icons.person,size: 30.0,
              color: Colors.white,
            ),

          ]),
      body:pages[currentTabIndex],
    );
  }
}
