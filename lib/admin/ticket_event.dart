import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/services/database.dart';

class TicketEvent extends StatefulWidget {
  const TicketEvent({super.key});

  @override
  State<TicketEvent> createState() => _TicketEventState();
}

class _TicketEventState extends State<TicketEvent> {
  Stream? ticketStream;

  Future<void> ontheload() async {
    ticketStream = await DatabaseMethods().getTickets();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  Widget allTickets() {
    return StreamBuilder(
      stream: ticketStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          physics: NeverScrollableScrollPhysics(), // Prevents scrolling here
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF1E1B3A), // Dark purple card
                border: Border.all(color: Colors.black12, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Soft Shadow
                    blurRadius: 10, // Blur effect
                    spreadRadius: 2, // How much the shadow spreads
                    offset: Offset(5, 5), // Shadow position (x, y)
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            ds["Image"],
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ds["Event"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Icon(Icons.calendar_month, color: Colors.blue),
                                  SizedBox(width: 5.0),
                                  Expanded(
                                    child: Text(
                                      ds["Date"],
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, color: Colors.blue),
                                  SizedBox(width: 5.0),
                                  Expanded(
                                    child: Text(
                                      ds["Location"],
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Icon(Icons.group, color: Colors.blue),
                                  SizedBox(width: 5.0),
                                  Text(
                                    ds["Number"],
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Icon(Icons.wallet, color: Colors.blue),
                                  SizedBox(width: 5.0),
                                  Text(
                                    ds["Total"],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.w700,
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
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D0B1A), // Dark background color
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10.0, top: 60.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width / 4.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 50, right: 50),
                    child: Center(
                      child: Text(
                        "Tickets",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Spacer
              allTickets(), // This widget will now scroll
            ],
          ),
        ),
      ),
    );
  }
}
