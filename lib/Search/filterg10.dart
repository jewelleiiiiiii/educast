import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Import Firestore

class FilterG10 extends StatefulWidget {
  const FilterG10({super.key});

  @override
  _FilterG10State createState() => _FilterG10State();
}

class _FilterG10State extends State<FilterG10> {
  List<String> selectedButtons = [];

  @override
  void initState() {
    super.initState();
    _loadFilters(); // Load filters when the widget is initialized
  }

  Future<void> _loadFilters() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('userAction').doc(uid).get();
        if (doc.exists) {
          setState(() {
            selectedButtons = List<String>.from(doc.get('filter') ?? []);
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to load filters: $e'),
        ));
      }
    }
  }

  void _toggleButton(String buttonName) {
    setState(() {
      if (selectedButtons.contains(buttonName)) {
        selectedButtons.remove(buttonName);
      } else {
        selectedButtons.add(buttonName);
      }
    });
  }

  Future<void> _saveFilters() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('User not authenticated.'),
      ));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('userAction').doc(uid).set({
        'filter': selectedButtons,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Filters saved successfully!'),
      ));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save filters: $e'),
      ));
    }
  }

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
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 158, 39, 39),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: const Center(
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
                  Navigator.pop(context); // Navigate back to the previous screen
                },
                child: Image.asset(
                  'assets/back.png', // Replace with your back button image path
                  width: 30.0,
                  height: 30.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 130.0,
                left: 16.0,
                right: 16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 40.0,
                      alignment: Alignment.centerLeft,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Category',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    // Buttons in two-column rows
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 4, // 40% width
                              child: RoundedButtonContainer(
                                buttonName: 'English',
                                isSelected: selectedButtons.contains('English'),
                                onPressed: _toggleButton,
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                            Flexible(
                              flex: 4, // 40% width
                              child: RoundedButtonContainer(
                                buttonName: 'Math',
                                isSelected: selectedButtons.contains('Math'),
                                onPressed: _toggleButton,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 4, // 40% width
                              child: RoundedButtonContainer(
                                buttonName: 'Science',
                                isSelected: selectedButtons.contains('Science'),
                                onPressed: _toggleButton,
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                            Flexible(
                              flex: 4, // 40% width
                              child: RoundedButtonContainer(
                                buttonName: 'Filipino',
                                isSelected: selectedButtons.contains('Filipino'),
                                onPressed: _toggleButton,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 4, // 40% width
                              child: RoundedButtonContainer(
                                buttonName: 'Mapeh',
                                isSelected: selectedButtons.contains('Mapeh'),
                                onPressed: _toggleButton,
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                            Flexible(
                              flex: 4, // 40% width
                              child: RoundedButtonContainer(
                                buttonName: 'AP',
                                isSelected: selectedButtons.contains('AP'),
                                onPressed: _toggleButton,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 4, // 40% width
                              child: RoundedButtonContainer(
                                buttonName: 'ESP',
                                isSelected: selectedButtons.contains('ESP'),
                                onPressed: _toggleButton,
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                            Flexible(
                              flex: 4, // 40% width
                              child: RoundedButtonContainer(
                                buttonName: 'TLE',
                                isSelected: selectedButtons.contains('TLE'),
                                onPressed: _toggleButton,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      height: 35.0,
                      alignment: Alignment.centerLeft,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Skills',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    // Buttons in two-column rows for Skills
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 4, // 40% width
                              child: RoundedButtonContainer(
                                buttonName: 'Critical Thinking',
                                isSelected: selectedButtons.contains('Critical Thinking'),
                                onPressed: _toggleButton,
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                            Flexible(
                              flex: 4, // 40% width
                              child: RoundedButtonContainer(
                                buttonName: 'Communication',
                                isSelected: selectedButtons.contains('Communication'),
                                onPressed: _toggleButton,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 4, // 40% width
                              child: RoundedButtonContainer(
                                buttonName: 'Collaboration',
                                isSelected: selectedButtons.contains('Collaboration'),
                                onPressed: _toggleButton,
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                            Flexible(
                              flex: 4, // 40% width
                              child: RoundedButtonContainer(
                                buttonName: 'Creativity',
                                isSelected: selectedButtons.contains('Creativity'),
                                onPressed: _toggleButton,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: _saveFilters,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedButtonContainer extends StatelessWidget {
  final String buttonName;
  final bool isSelected;
  final void Function(String) onPressed;

  const RoundedButtonContainer({super.key,
    required this.buttonName,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.red : Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
        onPressed: () => onPressed(buttonName),
        child: Text(
          buttonName,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
