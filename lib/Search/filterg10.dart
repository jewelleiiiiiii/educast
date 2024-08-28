import 'package:flutter/material.dart';
import 'package:myapp/Home/homeg10.dart';
import 'package:myapp/Search/searchg10.dart';

class FilterG10 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Header Container
            Container(
              width: double.infinity,
              height: 100.0,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 158, 39, 39),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: Center(
                child: Text(
                  'Filter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20.0,
              left: 16.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Navigate back to previous screen
                },
                child: Image.asset(
                  '../lib/assets/back.png', // Replace with your back button image path
                  width: 30.0,
                  height: 30.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 100.0,
                  left: 16.0,
                  right: 16.0), // Adjust top padding to make space for header
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start, // Align children to the left
                children: [
                  Container(
                    height: 40.0,
                    alignment: Alignment.bottomLeft, // Align text to the left
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Category',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // First Layer: Three clickable containers for Category
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Align to the left
                    children: [
                      RoundedButtonContainer(buttonName: 'English'),
                      RoundedButtonContainer(buttonName: 'Math'),
                      RoundedButtonContainer(buttonName: 'Science'),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  // Second Layer: Two clickable containers centered for Category
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center, // Align to the left
                    children: [
                      RoundedButtonContainer(buttonName: 'Filipino'),
                      SizedBox(width: 10.0),
                      RoundedButtonContainer(buttonName: 'Mapeh'),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  // Third Layer: Three clickable containers for Category
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Align to the left
                    children: [
                      RoundedButtonContainer(buttonName: 'AP'),
                      RoundedButtonContainer(buttonName: 'ESP'),
                      RoundedButtonContainer(buttonName: 'TLE'),
                    ],
                  ),
                  SizedBox(height: 20.0), // Increased spacing for clarity
                  Container(
                    height: 35.0,
                    alignment: Alignment.bottomLeft, // Align text to the left
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Skills', // Changed text to "Skills"
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // First Layer: Three clickable containers for Skills
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Align to the left
                    children: [
                      RoundedButtonContainer(buttonName: 'Critical Thinking'),
                      RoundedButtonContainer(buttonName: 'Communication'),
                      RoundedButtonContainer(buttonName: 'Collaboration'),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  // Second Layer: Two clickable containers centered for Skills
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Align to the left
                    children: [
                      RoundedButtonContainer(buttonName: 'Analysis'),
                      RoundedButtonContainer(buttonName: 'Technical'),
                      RoundedButtonContainer(buttonName: 'Management'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey, // Border color
              width: .2, // Border width
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
                '../lib/assets/home.png',
                width: 25.0,
                height: 25.0,
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
                '../lib/assets/search.png',
                width: 25.0,
                height: 25.0,
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => MainG10()),
                // );
              },
              icon: Image.asset(
                '../lib/assets/main.png',
                width: 40.0,
                height: 40.0,
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => NotificationScreen()),
                // );
              },
              icon: Image.asset(
                '../lib/assets/notif.png',
                width: 25.0,
                height: 25.0,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                '../lib/assets/stats.png',
                width: 25.0,
                height: 25.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedButtonContainer extends StatefulWidget {
  final String buttonName;

  RoundedButtonContainer({required this.buttonName});

  @override
  _RoundedButtonContainerState createState() => _RoundedButtonContainerState();
}

class _RoundedButtonContainerState extends State<RoundedButtonContainer> {
  bool _isHovered = false;
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        // Implement your onTap logic here
        print('Button ${widget.buttonName} tapped');
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          width: 80.0,
          height: 25.0,
          decoration: BoxDecoration(
            color: _isSelected
                ? Colors.pink
                : (_isHovered
                ? Colors.pink
                : const Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: Colors.black, // Set your stroke color here
              width: 1.0, // Set the width of the stroke
            ),
          ),
          child: Center(
            child: Text(
              widget.buttonName,
              style: TextStyle(
                color: Colors.black, // Text color
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
