import 'package:flutter/material.dart';

class TicketWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipPath(
            clipper: TicketClipper(),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Image
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      'https://i.imgur.com/xYO0dsd.png', // Replace with actual image URL
                      height: 160,
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
                          "Monatik",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),

                        // Date and Time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ticketDetail("Date", "Dec 13"),
                            _ticketDetail("Time", "20:00"),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Seat and Location
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ticketDetail("Seat", "5 (row 11)"),
                            _ticketDetail("Location", "Sumy, Drama Opera",
                                isBold: true),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Barcode Section
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        // BarcodeWidget(
                        //   barcode: Barcode.code128(),
                        //   data: '12345678909817',
                        //   width: 200,
                        //   height: 50,
                        // ),
                        SizedBox(height: 5),
                        Text("1 234567 8909817"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to create ticket details
  Widget _ticketDetail(String title, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// Custom Clipper for Ticket Shape
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 10;
    Path path = Path();

    path.addRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(0, 0, size.width, size.height),
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    );

    double notchRadius = 10;
    path.addOval(Rect.fromCircle(center: Offset(0, size.height * 0.75), radius: notchRadius));
    path.addOval(Rect.fromCircle(center: Offset(size.width, size.height * 0.75), radius: notchRadius));

    return path;
  }

  @override
  bool shouldReclip(TicketClipper oldClipper) => false;
}
