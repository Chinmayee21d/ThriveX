import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/services/constant.dart';
import 'package:untitled2/services/database.dart';
import 'package:untitled2/services/shared_pref.dart';

class DetailPage extends StatefulWidget {
  //for Image from firebase use Image url
  String image, name, location, date, detail, price, time;

  DetailPage(
      {required this.date,
      required this.detail,
      required this.image,
      required this.location,
      required this.name,
      required this.price,
      required this.time});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? paymentIntent;
  int ticket = 1;
  int total = 0;
  String? name, image, id;

  @override
  void initState() {
    total = int.parse(widget.price);
    ontheload();
    super.initState();
  }

  ontheload() async {
    name = await SharedpreferenceHelper().getUserName();
    image = await SharedpreferenceHelper().getUserImage();
    id = await SharedpreferenceHelper().getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(

          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xFF02000D),
                    Color(0xFF02000D),
                    // Dark base color
                    Color(0xFF1A1A40), // Deep blueish-purple for depth
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                //for Image from firebase use Image.network
                Image.asset(
                  "images/hackathon.jpg",
                  height: MediaQuery.of(context).size.height/2 ,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(top: 60.0, left: 20.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFF161455),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                color: Colors.white,
                              ),
                            ),
                          )),
                      // Container(
                      //   padding: EdgeInsets.only(left: 20.0),
                      //   width: MediaQuery.of(context).size.width,
                      //   decoration: BoxDecoration(color: Color(0xCB1A1A40)),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       SizedBox(
                      //         height: 5.0,
                      //       ),
                      //       Text(
                      //         widget.name!,
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 25.0,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //       SizedBox(
                      //         height: 5.0,
                      //       ),
                      //       Row(
                      //         children: [
                      //           Icon(
                      //             Icons.calendar_month,
                      //             color: Colors.white,
                      //           ),
                      //           SizedBox(
                      //             width: 10.0,
                      //           ),
                      //           Text(
                      //             widget.date!,
                      //             style: TextStyle(
                      //               color: Colors.white70,
                      //               fontSize: 20.0,
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             width: 20.0,
                      //           ),
                      //           Icon(
                      //             Icons.access_time_rounded,
                      //             color: Colors.white,
                      //           ),
                      //           Text(
                      //             widget.time!,
                      //             style: TextStyle(
                      //               color: Colors.white70,
                      //               fontSize: 20.0,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 5.0,
                      //       ),
                      //       Row(
                      //         children: [
                      //           Icon(
                      //             Icons.location_on_outlined,
                      //             color: Colors.white,
                      //           ),
                      //           Text(
                      //             widget.location!,
                      //             style: TextStyle(
                      //                 color: Colors.white70,
                      //                 fontSize: 20.0,
                      //                 fontWeight: FontWeight.bold),
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 20.0,
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                )
              ]),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                child: Text(
                  widget.name!,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff2d3459), Color(0xFF232458)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today, color: Colors.white60),
                          const SizedBox(height: 4),
                          Text("Date", style: TextStyle(color: Colors.white70, fontSize: 18)),
                          const SizedBox(height: 4),
                          Text(widget.date!, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 1.2,
                        color: Colors.white,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time_outlined, color: Colors.white60),
                          const SizedBox(height: 4),
                          Text("Time", style: TextStyle(color: Colors.white70, fontSize: 18)),
                          const SizedBox(height: 4),
                          Text(widget.time!, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 1.2,
                        color: Colors.white24,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, color: Colors.white60),
                          const SizedBox(height: 4),
                          Text("Location", style: TextStyle(color: Colors.white70, fontSize: 18)),
                          const SizedBox(height: 4),
                          Text(widget.location!, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                child: Text(
                  "About Event",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  widget.detail!,
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Text(
                      "Number of Tickets",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (ticket > 1) {
                              total -= int.parse(widget.price);
                              ticket--;
                              setState(() {});
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.remove, color: Colors.black, size: 20),
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF4D47FF), width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            ticket.toString(),
                            style: TextStyle(
                              color: Color(0xFF5954FF),
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            total += int.parse(widget.price);
                            ticket++;
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.add, color: Colors.black, size: 20),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),
              SizedBox(
                height: 58.0,
              ),
              Positioned(

                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF151434),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(
                        "Amount : \₹" + total.toString(),
                        style: TextStyle(
                          color: Color(0xFF6963FF),
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),),
                      GestureDetector(
                        onTap: () {
                          makePayment(total.toString());
                        },
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF4A44EF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Book Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'INR');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent?['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Chinmayee'))
          .then((value) {});
      displayPaymentSheet(amount);
    } catch (e, s) {
      print('exception: $e$s');
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        Map<String, dynamic> bookingdetail = {
          "Number": ticket.toString(),
          "Total": total.toString(),
          "Event": widget.name,
          "Location": widget.location,
          "Date": widget.date,
          "Time": widget.time,
          "Name": name,
          "Image": image
        };
        await DatabaseMethods()
            .addUserBooking(bookingdetail, id!)
            .then((value) async {
          await DatabaseMethods().addAdminTicket(bookingdetail);
        });
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline_sharp,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull")
                        ],
                      )
                    ],
                  ),
                ));
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print("Error is:---> $error $stackTrace");
      });
    } on StripeException catch (e) {
      print("Error is:---> $e");
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled"),
              ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: {${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);
    return calculatedAmount.toString();
  }
}
