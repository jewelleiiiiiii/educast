import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educast/Home/homeg12.dart';
import 'package:educast/Notification/panel_widget.dart';
import 'package:flutter/material.dart';

import '../Home/Home4th.dart';
import '../Home/homeg10.dart';
import '../common/grade_level.dart';

class NotificationPage extends StatefulWidget {
  final String uuid;

  const NotificationPage({
    super.key,
    required this.uuid,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<Map<String, dynamic>> _devices = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Loop the animation with a reverse effect

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _fetchGradeLevel(); // Fetch the grade level
    _fetchDevices();    // Fetch devices
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchGradeLevel() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uuid)
          .get();

      if (userDoc.exists) {
        setState(() {
          GradeLevel.gradeLevel = userDoc['gradeLevel'] as String;
        });
      } else {
        print("User document not found");
      }
    } catch (e) {
      print("Error fetching grade level: $e");
    }
  }

  Future<void> _fetchDevices() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users-device')
          .doc(widget.uuid)
          .collection('devices')
          .get();

      setState(() {
        _devices = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print("Error fetching devices: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final iconSize = _width * 0.10;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg8.png',
              fit: BoxFit.cover,
            ),
          ),
          Stack(
            children: [
              Positioned(
                top: 205,
                left: (_width * 0.5) - 5,
                child: Text(
                  '${_devices.length}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // Animated circle
              Positioned(
                top: 180,
                left: (_width * 0.5) - 40,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.withOpacity(0.5),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 300,
            left: 10,
            right: 10,
            child: SizedBox(
              width: _width,
              height: _height * 0.5,
              child: ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  final device = _devices[index];
                  return PanelContainerWidget(data: device);
                },
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
        child: GradeLevel.gradeLevel == "Grade 10"
            ? BottomNavigationHome10(iconSize: iconSize)
            : GradeLevel.gradeLevel == "Grade 12"
            ? BottomNavigationHome12(iconSize: iconSize)
            : BottomNavitation4th(iconSize: iconSize),
      ),
    );
  }
}
