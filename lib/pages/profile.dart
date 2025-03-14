import 'package:flutter/material.dart';
import 'package:untitled2/pages/signup.dart';
import 'package:untitled2/services/auth.dart';
import 'package:untitled2/services/shared_pref.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image, name, email, id;

  Future<void> getSharedPrefData() async {
    id = await SharedpreferenceHelper().getUserId();
    image = await SharedpreferenceHelper().getUserImage();
    name = await SharedpreferenceHelper().getUserName();
    email = await SharedpreferenceHelper().getUserEmail();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefData();
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
        child: SafeArea(

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Profile",
                    style: TextStyle(
                        color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[800],
                    backgroundImage:
                    image != null && image!.isNotEmpty ? NetworkImage(image!) : null,
                    child: image == null || image!.isEmpty
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.white, size: 22),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          name ?? "N/A",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.email, color: Colors.white, size: 22),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          email ?? "N/A",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    AuthMethods().SignOut().then((value) {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => Signup()));
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFF4A44EF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.logout, color: Colors.white, size: 22),
                        SizedBox(width: 12),
                        Text(
                          "Log Out",
                          style: TextStyle(
                              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    AuthMethods().deleteuser().then((value) {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => Signup()));
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.delete, color: Colors.white, size: 22),
                        SizedBox(width: 12),
                        Text(
                          "Delete Account",
                          style: TextStyle(
                              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
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
