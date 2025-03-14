import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/services/database.dart';

class UploadEvent extends StatefulWidget {
  const UploadEvent({super.key});

  @override
  State<UploadEvent> createState() => _UploadEventState();
}

class _UploadEventState extends State<UploadEvent> {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController pricecontroller = new TextEditingController();
  TextEditingController detailcontroller = new TextEditingController();
  TextEditingController locationcontroller = new TextEditingController();

  final List<String> eventcategory = ["Music", "Tech","Festival"];
  String? value;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }


  DateTime selectedDate= DateTime.now();
  TimeOfDay selectedTime= TimeOfDay(hour: 10, minute: 00);

  Future<void> _pickDate() async{
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if(pickedDate != null && pickedDate != selectedDate){
      setState(() {
        selectedDate=pickedDate;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time){
    final now= DateTime.now();
    //   convert TimeOfDay to DateTime
    final dateTime = DateTime(now.year,now.month,now.day,time.hour,time.minute);
    //Format to desired format with leading zero
    return DateFormat('hh:mm a').format(dateTime);
  }
  Future<void> _pickTime() async{
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context, initialTime: TimeOfDay.now(),
    );
    if(pickedTime != null && pickedTime != selectedTime){
      setState(() {
        selectedTime=pickedTime;
      });
    }
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
                end: Alignment.bottomCenter)),
        child: Container(
          margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [

                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5.0,

                    ),

                    Padding(
                      padding: const EdgeInsets.only(top:10.0,left: 25,bottom: 10.0),
                      child: Text(
                        "Upload Event",
                        style: TextStyle(
                            color: Color(0xFF817BF8),
                            fontSize: 27.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                // Image Upload Placeholder
                selectedImage!=null? Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(selectedImage!,height:250 ,width: 400,fit:BoxFit.cover ,)),
                ) :Center(
                  child: GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Container(
                      height: 150,
                      width:150,
                      decoration: BoxDecoration(
                          // border: Border.all(color: Colors.white, width: 2.0),
                          // borderRadius: BorderRadius.circular(20)
                        ),
                      child: Image.asset("images/send (1).png",),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Event Name",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xFF212121),
                      borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFF4A44EF), width: 2),),
                  child: TextField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Enter Event Name", hintStyle: TextStyle(color: Colors.white54),),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Ticket Price",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xFF212121),
                      borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFF4A44EF), width: 2),),
                  child: TextField(
                    controller: pricecontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Enter Price", hintStyle: TextStyle(color: Colors.white54),),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Event Category",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xFF212121),
                      borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFF4A44EF), width: 2),),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items: eventcategory
                          .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.white),
                          )))
                          .toList(),
                      onChanged: ((value) => setState(() {
                        this.value = value;
                      })),
                      dropdownColor: Color(0xFF212121),

                      hint: Text("Select Category" ,style: TextStyle(color: Colors.white54)),
                      iconSize: 36.0,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF4A44EF),
                      ),
                      value: value,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Expiry Date (Date Picker)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          SizedBox(height: 4), // Halka sa space niche
                          GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color(0xFF4A44EF), width: 2), // Custom blue border
                                color: Color(0xFF212121), // Custom black background
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('dd MMM yyyy').format(selectedDate),
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                  Icon(Icons.calendar_month, color: Color(0xFF4A44EF)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16), // Space between date & time

                    // CVV (Time Picker)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          SizedBox(height: 4), // Halka sa space niche
                          GestureDetector(
                            onTap: _pickTime,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Color(0xFF4A44EF), width: 2), // Custom blue border
                                color: Color(0xFF212121), // Custom black background
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatTimeOfDay(selectedTime),
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                  Icon(Icons.access_time, color: Color(0xFF4A44EF)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Event Location",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xFF212121),
                      border: Border.all(color: Color(0xFF4A44EF), width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: locationcontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Enter Location", hintStyle: TextStyle(color: Colors.white54),),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Event Detail",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xFF212121),
                      border: Border.all(color: Color(0xFF4A44EF), width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: detailcontroller,
                    maxLines: 6,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "About the event (description)",
                        hintStyle: TextStyle(color: Colors.white54),

                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: ()async{
                    // String addId= randomAlphaNumeric(10);
                    // Reference firebaseStorageRef= FirebaseStorage.instance.ref().child("blogImage").child(addId);
                    // final UploadTask task=firebaseStorageRef.putFile(selectedImage!);
                    // var downloadUrl=await(await task).ref.getDownloadURL();
                    String id=  randomAlphaNumeric(10);
                    String firstletter= namecontroller.text.substring(0,1).toUpperCase();
                    Map<String, dynamic>uploadevent={
                      // "Image":downloadUrl,
                      "Image":"",
                      "Name":namecontroller.text,
                      "Price":pricecontroller.text,
                      "Category":value,
                      "SearchKey": firstletter,
                      "Detail":detailcontroller.text,
                      "UpdatedName":namecontroller.text.toUpperCase(),
                      "Date": DateFormat('yyyy-MM-dd').format(selectedDate!),
                      "Time":formatTimeOfDay(selectedTime!),
                      "Location":locationcontroller.text,

                    };
                    await DatabaseMethods().addEvent(uploadevent, id).then((value){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            "Event Uploaded Successfully!!!",
                            style: TextStyle(fontSize: 20.0,),
                          )));
                      setState(() {
                        namecontroller.text="";
                        pricecontroller.text="";
                        detailcontroller.text="";
                        selectedImage=null;
                      });
                    });


                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF4A44EF),
                          borderRadius: BorderRadius.circular(10)),
                      width: 200,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Upload",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}