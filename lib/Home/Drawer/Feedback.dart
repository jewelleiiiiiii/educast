import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _feedbackController = TextEditingController();
  int _selectedStarRating = 0;
  String? _errorMessage;

  Future<void> _submitFeedback() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _errorMessage = "User is not logged in.";
      });
      return;
    }

    final String feedbackText = _feedbackController.text.trim();

    if (_selectedStarRating == 0) {
      setState(() {
        _errorMessage = "Please select a star rating.";
      });
      return;
    }

    if (feedbackText.isEmpty) {
      setState(() {
        _errorMessage = "Please provide some feedback.";
      });
      return;
    }

    try {
      // Fetch the user's document from the 'users' collection
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        setState(() {
          _errorMessage = "User profile not found.";
        });
        return;
      }

      final userData = userDoc.data();
      final gradeLevel = userData?['gradeLevel'] as String?;
      final campus = userData?['campus'] as String?;

// Ensure gradeLevel is not null before comparing
      final strand = (gradeLevel == "Grade 12" && userData?['strand'] != null)
          ? userData!['strand'] as String
          : null;

      final course = (gradeLevel == "Fourth-year College" && userData?['course'] != null)
          ? userData!['course'] as String
          : null;

      // Get the existing feedback document (or create if doesn't exist)
      final feedbackDocRef = FirebaseFirestore.instance
          .collection('feedback')
          .doc(user.uid);

      final feedbackDoc = await feedbackDocRef.get();

      // Check how many feedback fields exist
      int feedbackCount = 0;
      if (feedbackDoc.exists) {
        final feedbackData = feedbackDoc.data();
        feedbackCount = feedbackData?.keys
            .where((key) => key.startsWith('feedback'))
            .length ??
            0;
      }

      final newFeedbackIndex = feedbackCount + 1;

      // Add the new feedback field, starRating, timestamp, etc.
      await feedbackDocRef.set({
        'feedback$newFeedbackIndex': feedbackText,
        'starRating$newFeedbackIndex': _selectedStarRating,
        'timestamp$newFeedbackIndex': FieldValue.serverTimestamp(),
        'gradeLevel': gradeLevel,
        'campus': campus,
        if (strand != null) 'strand': strand,
        if (course != null) 'course': course,
      }, SetOptions(merge: true));

      setState(() {
        _errorMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Feedback submitted successfully.")),
      );

      // Optionally clear the feedback input field after submission
      _feedbackController.clear();
      _selectedStarRating = 0;

      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _errorMessage = "Error submitting feedback. Please try again.";
      });
    }
  }


  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _selectedStarRating ? Icons.star : Icons.star_border,
            color: Colors.yellow,
          ),
          onPressed: () {
            setState(() {
              _selectedStarRating = index + 1;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit Feedback"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 16),
            ],
            Text(
              "Rate your experience:",
              style: TextStyle(fontSize: 18),
            ),
            _buildStarRating(),
            SizedBox(height: 16),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Write your feedback here",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: Text("Submit Feedback"),
            ),
          ],
        ),
      ),
    );
  }
}
