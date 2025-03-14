import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/pages/detail_page.dart';
import 'package:untitled2/services/database.dart';

class CategoriesEvent extends StatefulWidget {
  String eventcategory;

  CategoriesEvent({required this.eventcategory});

  @override
  State<CategoriesEvent> createState() => _CategoriesEventState();
}

class _CategoriesEventState extends State<CategoriesEvent> {
  Stream? eventStream;

  getontheload() async {
    eventStream = await DatabaseMethods().getEventCategories(widget.eventcategory);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allEvents() {
    return StreamBuilder(
        stream: eventStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                String inputDate = ds["Date"];
                DateTime parsedDate = DateTime.parse(inputDate);
                String formattedDate = DateFormat('MMM dd').format(parsedDate);
                DateTime currentDate = DateTime.now();
                bool hasPassed = currentDate.isAfter(parsedDate);
                return hasPassed
                    ? Container()
                    : GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                              date: ds["Date"],
                              detail: ds["Detail"],
                              location: ds["Location"],
                              price: ds["Price"],
                              name: ds["Name"],
                              image: "",
                              time: ds["Time"],
                            )));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Color(0xC231327C),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    "images/hackathon.jpg",
                                    height: 200,
                                    width: 360,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 15,
                              left: 15,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Color(0xFF4A44EF), borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  formattedDate,
                                  style: TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      ds["Name"],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "\$${ds["Price"]}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.grey, size: 18),
                                  SizedBox(width: 5),
                                  Text(
                                    ds["Location"],
                                    style: TextStyle(color: Colors.grey, fontSize: 18.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
              : Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
                    )),
                SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 70.0, top: 20),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 150,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xFF4A44EF), borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.eventcategory,
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: allEvents(),
          )
        ],
      ),
    );
  }
}