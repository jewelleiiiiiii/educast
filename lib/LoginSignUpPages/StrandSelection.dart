import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:educast/Home/homeg12.dart'; // Import Firebase Auth

class StrandSelection extends StatefulWidget {
  const StrandSelection({super.key});

  @override
  _StrandSelection createState() => _StrandSelection();
}

class _StrandSelection extends State<StrandSelection> {
  final _academicInterests = [
    'Science, Technology, Engineering, and Mathematics',
    'Accountancy, Business, and Management',
    'Humanities and Social Sciences',
    'General Academic Strand'
  ];

  String? _selectedInterest;

  // Calculate the width of the longest interest
  final double _maxContainerWidth = _calculateTextWidth(
    'Science, Technology, Engineering, and Mathematics',
    const TextStyle(fontSize: 18), // Adjusted fontSize for larger text
  );

  static double _calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width + 40; // Added more padding for larger text
  }

  Future<void> _updateStrand() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _selectedInterest != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'strand': _selectedInterest,
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeG12(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, // Disable back button
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 155, 15, 15),
        centerTitle: true,
        leading: IconButton(
          icon: SizedBox(
            width: 20,
            height: 20,
            child: Image.asset('assets/back.png'),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 229, 228, 228),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                children: const [
                  SizedBox(height: 30),
                  Text(
                    'Strands',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 155, 15, 15),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: const Center(
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 150),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      _buildInterestSection('Academic', _academicInterests),
                      const SizedBox(height: 30),
                      Container(
                        height: 2,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                  child: TextButton(
                    onPressed: () async {
                      // Update Firestore with the selected strand
                      await _updateStrand();
                    },
                    child: const Text(
                      'Ok',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildInterestSection(String title, List<String> interests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 2,
          color: Colors.black,
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center, // Center the containers
          spacing: 8,
          runSpacing: 8,
          children: interests.map((interest) {
            final isSelected = _selectedInterest == interest;
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedInterest = null;
                      } else {
                        _selectedInterest = interest;
                      }
                    });
                  },
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: _maxContainerWidth,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12), // Adjusted padding
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromARGB(255, 155, 15, 15)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        // Center the text
                        child: Text(
                          interest,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16, // Increased font size
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    height: 16), // Adjust the height for your desired spacing
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
