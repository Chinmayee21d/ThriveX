import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/services/database.dart';
import 'package:untitled2/services/shared_pref.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  Stream? bookingStream;
  String? id;

  getthesharedpref() async {
    id = await SharedpreferenceHelper().getUserId();
    setState(() {});
    ontheload();
  }

  ontheload() async {
    if (id != null) {
      bookingStream = await DatabaseMethods().getbookings(id!);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getthesharedpref();
  }

  Widget allbookings() {
    return StreamBuilder(
        stream: bookingStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: ClipPath(
                    clipper: TicketClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0x914A44EF),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event Image
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.asset(
                              "images/hackathon.jpg",
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ds["Event"],
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),

                                // Date & Time
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _ticketDetail("Date", ds["Date"]),
                                    _ticketDetail("Time", "20:00"),
                                  ],
                                ),
                                SizedBox(height: 8),

                                // Seat & Location
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _ticketDetail("Seat", ds["Number"]),
                                    _ticketDetail("Location", ds["Location"], isBold: true),
                                  ],
                                ),
                                SizedBox(height: 8),

                                // Price
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _ticketDetail("Total Price", "₹" + ds["Total"], isBold: true),
                                  ],
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),

                          // Divider Above Barcode
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CustomPaint(
                              painter: DashedLinePainter(),
                              size: Size(double.infinity, 1),
                            ),
                          ),
                          SizedBox(height:8 ,),

                          // Barcode Section
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Column(
                                children: [
                                  BarcodeWidget(
                                    barcode: Barcode.code128(),
                                    width: 300,
                                    height: 60,
                                    color: Colors.white,
                                    data: '12345678909817',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  // Helper function for displaying ticket details
  Widget _ticketDetail(String title, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          children: [
            SizedBox(height: 60.0),
            Text(
              "Bookings",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: allbookings(),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for Ticket Shape with Cutouts
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 30;
    double cutoutRadius = 15;
    Path path = Path();

    // Top rounded corners
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height * 0.83 - cutoutRadius);

    // Right-side notch (moved lower)
    path.arcToPoint(
      Offset(size.width, size.height * 0.83 + cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );

    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.lineTo(0, size.height * 0.83 + cutoutRadius);

    // Left-side notch (moved lower)
    path.arcToPoint(
      Offset(0, size.height * 0.83 - cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );

    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(TicketClipper oldClipper) => false;
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashWidth = 6, dashSpace = 4;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) => false;
}
