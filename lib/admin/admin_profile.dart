import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/pages/signup.dart';
import 'package:untitled2/services/auth.dart';
import 'package:untitled2/services/shared_pref.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  String? name, email;

  Future<void> getAdminData() async {
    String? adminId = await SharedpreferenceHelper().getUserId();
    if (adminId != null) {
      DocumentSnapshot adminDoc = await FirebaseFirestore.instance
          .collection('AdminProfile')
          .doc(adminId)
          .get();

      if (adminDoc.exists) {
        setState(() {
          name = adminDoc["Name"];
          email = adminDoc["Email"];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getAdminData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 SizedBox(height: 30),

                // Title
                const Center(
                  child: Text(
                    "Admin Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                 SizedBox(height: 30),

                // Circular Container for Profile Image
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2), // White border
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "images/Admin.png",
                      fit: BoxFit.cover,

                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Name
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Color(0xFF8896FF), size: 22),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          name ?? "Chinmayee Deshmukh",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                 SizedBox(height: 20),

                // Email
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.email, color: Color(0xFF8896FF), size: 22),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          email ?? "deshmukhchinmaye@gmail.com",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                 SizedBox(height: 20),

                // Logout Button
                GestureDetector(
                  onTap: () {
                    AuthMethods().SignOut().then((value) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );

                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A44EF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.logout, color: Colors.white, size: 22),
                          SizedBox(width: 12),
                          Text(
                            "Log Out",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
