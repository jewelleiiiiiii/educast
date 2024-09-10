import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/Home/homeg10.dart';
import 'package:myapp/Home/homeg12.dart';
import 'package:myapp/Search/searchg10.dart';

class UserG12 extends StatefulWidget {
  const UserG12({super.key});

  @override
  _UserG12 createState() => _UserG12();
}

class _UserG12 extends State<UserG12> {
  // Controllers for the text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _strandController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _gradeLevelController = TextEditingController();
  final TextEditingController _campusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch the user's data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;
          // Update the text fields with the retrieved data
          setState(() {
            _firstNameController.text = data['firstName'] ?? '';
            _lastNameController.text = data['lastName'] ?? '';
            _emailController.text = data['email'] ?? '';
            _gradeLevelController.text = data['gradeLevel'] ?? '';
            _campusController.text = data['campus'] ?? '';
            _strandController.text = data['strand'] ?? ''; // Fetch strand
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Handle errors if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch screen size
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true, // Extend the body behind the AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Colors.transparent, // Make AppBar transparent to show background
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
                MaterialPageRoute(builder: (context) => const HomeG12()),
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
                image: AssetImage('assets/BG.png'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: kToolbarHeight), // Adjust the padding to avoid overlapping with the AppBar
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Adjust opacity if needed
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(right: screenWidth * 0.04),
                                child: CircleAvatar(
                                  radius: screenHeight * 0.07,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.person,
                                    size: screenHeight * 0.07,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'First Name',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              _buildTextFieldWithShadowUserG10(
                                controller: _firstNameController,
                                labelText: ' ',
                                height: screenHeight * 0.06,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Last Name',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              _buildTextFieldWithShadowUserG10(
                                controller: _lastNameController,
                                labelText: ' ',
                                height: screenHeight * 0.06,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              _buildTextFieldWithShadowUserG10(
                                controller: _emailController,
                                labelText: ' ',
                                height: screenHeight * 0.06,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Grade Level',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              _buildTextFieldWithShadowUserG10(
                                controller: _gradeLevelController,
                                labelText: ' ',
                                height: screenHeight * 0.06,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Campus',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              _buildTextFieldWithShadowUserG10(
                                controller: _campusController,
                                labelText: ' ',
                                height: screenHeight * 0.06,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Strand',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                              _buildTextFieldWithShadowUserG10(
                                controller: _strandController,
                                labelText: ' ',
                                height: screenHeight * 0.06,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: .2,
            ),
          ),
        ),
        child: Row(
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
                width: MediaQuery.of(context).size.width * 0.10,
                height: MediaQuery.of(context).size.height * 0.10,
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
                width: MediaQuery.of(context).size.width * 0.10,
                height: MediaQuery.of(context).size.height * 0.10,
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
                'assets/main.png',
                width: MediaQuery.of(context).size.width * 0.10,
                height: MediaQuery.of(context).size.height * 0.10,
              ),
            ),
            IconButton(
              onPressed: () {
                // Handle action
              },
              icon: Image.asset(
                'assets/notif.png',
                width: MediaQuery.of(context).size.width * 0.10,
                height: MediaQuery.of(context).size.height * 0.10,
              ),
            ),
            IconButton(
              onPressed: () {
                // Handle action
              },
              icon: Image.asset(
                'assets/stats.png',
                width: MediaQuery.of(context).size.width * 0.10,
                height: MediaQuery.of(context).size.height * 0.10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithShadowUserG10({
    required TextEditingController controller,
    required String labelText,
    required double height,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: Offset(0, 4),
            blurRadius: 10.0,
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        enabled: false, // Makes the field non-editable
      ),
    );
  }
}
