import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/pages/bottomnav.dart';
import 'package:untitled2/pages/categories_event.dart';
import 'package:untitled2/pages/detail_page.dart';
import 'package:untitled2/services/database.dart';
import 'package:untitled2/services/shared_pref.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? eventStream;
  String? name;

  getthesharedpref() async {
    name = await SharedpreferenceHelper().getUserName();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    eventStream = await DatabaseMethods().getallEvents();
    setState(() {});
  }

  bool search = false;
  var queryResultSet = [];
  var tempSearchStore = [];
  TextEditingController searchcontroller = TextEditingController();

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
    var CapitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['UpdatedName'].startsWith(CapitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  void initState() {
    ontheload();
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
              physics: NeverScrollableScrollPhysics(), // Prevent scrolling of inner ListView
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];

                String inputDate = ds["Date"];
                DateTime parsedDate = DateTime.parse(inputDate);
                String formattedDate =
                DateFormat('MMM, dd').format(parsedDate);
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
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color(0xC231327C),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15),
                                          bottom: Radius.circular(15)),
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4A44EF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          ds["Name"],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "₹" + ds["Price"],
                                        style: TextStyle(
                                          color: Color(0xFFF78B6F),
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.white54, size: 18),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          ds["Location"],
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 18,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                    ],
                  ),
                );
              })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 50.0, left: 20.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF02000D),
                Color(0xFF02000D),
                Color(0xFF1A1A40),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 65),
                child: Row(
                  children: [
                    Image.asset(
                      "images/namaste.png",
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 10),
                    Text("Welcome To VIT",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text(" Hello, " + (name ?? "Guest"),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0),
              SizedBox(height: 15.0),
              Container(
                margin: EdgeInsets.only(right: 20.0),
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x994A44EF),
                      Color(0xB3201D60),
                      Color(0xB2201D53)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: searchcontroller,
                  onChanged: (value) {
                    initiateSearch(value.toUpperCase());
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search_outlined, color: Colors.white, size: 30),
                    border: InputBorder.none,
                    hintText: "Search any event...",
                    hintStyle: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              search
                  ? ListView(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                primary: false,
                shrinkWrap: true,
                children: tempSearchStore.map((element) {
                  return buildResultCard(element);
                }).toList(),
              )
                  : Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Bottomnav()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5.0),
                            child: Material(
                              elevation: 3.0,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: 150,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color(0xFF4A44EF),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "All Events",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CategoriesEvent(eventcategory: "Music")));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5.0),
                            child: Material(
                              elevation: 3.0,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: 130,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color(0xCB12123E),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "images/music.png",
                                      height: 25,
                                      width: 25,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Music",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CategoriesEvent(eventcategory: "Tech")));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5.0),
                            child: Material(
                              elevation: 3.0,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: 130,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color(0xCB12123E),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "images/computer.png",
                                      height: 25,
                                      width: 25,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Tech",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CategoriesEvent(eventcategory: "Festival")));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5.0),
                            child: Material(
                              elevation: 3.0,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: 150,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color(0xCB12123E),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "images/confetti.png",
                                      height: 25,
                                      width: 25,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Festival",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text("Upcoming Events",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text("See More",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              allEvents(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return Container(
      height: 100,
      child: Row(
        children: [
          Image.network(data["Image"], height: 50, width: 50, fit: BoxFit.cover),
          Text(data["Name"],
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}