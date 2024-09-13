import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/Assessment/G10Intro.dart';
import 'package:myapp/Assessment/assess4g10.dart';
import 'package:myapp/Home/homeg10.dart';
import 'package:myapp/Result/resultg10.dart';
import 'package:myapp/Search/searchg10.dart';

class G10Rules extends StatefulWidget {
  const G10Rules({Key? key}) : super(key: key);

  @override
  _G10Rules createState() => _G10Rules();
}

class _G10Rules extends State<G10Rules> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.10;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 158, 39, 39),
          elevation: 0,
          leading: IconButton(
            icon: Image.asset(
              'assets/back.png',
              width: 24.0,
              height: 24.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg6.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Empty body with only header and footer remaining
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 158, 39, 39),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Interest Assessment',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
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
                      MaterialPageRoute(builder: (context) => const HomeG10()),
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
                      MaterialPageRoute(builder: (context) => const SearchG10()),
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
                  color: const Color(0xFFF08080),
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
                          MaterialPageRoute(builder: (context) => SubmissionConfirmation()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const G10Intro()),
                        );
                      }
                    }
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
    );
  }
}
