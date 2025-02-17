import 'package:educast/Home/User/ResetPasswordG12.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:educast/Assessment/Rules/G10Intro.dart';
import 'package:educast/Assessment/assess4g10.dart';
import 'package:educast/Home/homeg10.dart';
import 'package:educast/Result/resultg10.dart';
import 'package:educast/Search/searchg10.dart';

class UserG10 extends StatefulWidget {
  const UserG10({super.key});

  @override
  _UserG10 createState() => _UserG10();
}

class _UserG10 extends State<UserG10> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String password =
      '********'; // Placeholder for the password, as it's not retrievable.
  String gradeLevel = '';
  String campus = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            firstName = data['firstName'] ?? '';
            lastName = data['lastName'] ?? '';
            email = data['email'] ?? '';
            gradeLevel = data['gradeLevel'] ?? '';
            campus = data['campus'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.10;
    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Image.asset(
                'assets/back.png',
                width: 24.0,
                height: 24.0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeG10(gradeLevel: "10")),
                );
              },
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg8.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: kToolbarHeight),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 70),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Center(
                                child: CircleAvatar(
                                  radius: screenHeight * 0.05,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.person,
                                    size: screenHeight * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          buildUserInfo('First Name', firstName),
                          SizedBox(height: 15),
                          buildUserInfo('Last Name', lastName),
                          SizedBox(height: 15),
                          buildUserInfo('Email', email),
                          SizedBox(height: 15),
                          buildUserInfo('Password', password),
                          SizedBox(height: 15),
                          buildUserInfo('Grade Level', gradeLevel),
                          SizedBox(height: 15),
                          buildUserInfo('Campus', campus),
                          SizedBox(height: 25),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ResetPasswordPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 158, 39, 39),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                              ),
                              child: Text('Reset Password'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.10,
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(
              top: BorderSide(
                color: Colors.grey,
                width: 0.2,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -2),
                blurRadius: 0,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HomeG10(gradeLevel: "10")),
                      );
                    },
                    icon: Image.asset(
                      'assets/home.png',
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchG10()),
                      );
                    },
                    icon: Image.asset(
                      'assets/search.png',
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                  SizedBox(width: iconSize),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/notif.png',
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResultG10()),
                      );
                    },
                    icon: Image.asset(
                      'assets/stats.png',
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -iconSize * 0.75,
                left: MediaQuery.of(context).size.width / 2 - iconSize,
                child: Container(
                  width: iconSize * 2,
                  height: iconSize * 2,
                  decoration: BoxDecoration(
                    color: Color(0xFFF08080),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.8),
                      width: 10,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        final userResultDoc = FirebaseFirestore.instance
                            .collection('userResultG10')
                            .doc(user.uid);

                        final docSnapshot = await userResultDoc.get();

                        if (docSnapshot.exists) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubmissionConfirmation()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => G10Intro()),
                          );
                        }
                      } else {}
                    },
                    icon: Image.asset(
                      'assets/main.png',
                      width: iconSize * 1.3,
                      height: iconSize * 1.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserInfo(String label, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          Text(
            info,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
