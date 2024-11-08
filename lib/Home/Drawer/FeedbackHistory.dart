import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedbackHistoryPage extends StatelessWidget {
  FeedbackHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Feedback History'),
        ),
        body: Center(
          child: Text('User not logged in.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback History'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        // Directly reference the user's document in the 'feedback' collection
        stream: FirebaseFirestore.instance
            .collection('feedback')
            .doc(user.uid) // Use the user's UID as the document ID
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Check if the document exists
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No feedback available.'));
          }

          // Access the feedback data from the document
          Map<String, dynamic>? feedbackData =
          snapshot.data!.data() as Map<String, dynamic>?;

          // Check if the feedback data is not null
          if (feedbackData == null) {
            return Center(child: Text('No feedback available.'));
          }

          // Create a list to hold feedback items
          List<Widget> feedbackItems = [];

          // Loop through the feedback fields
          int index = 1;
          while (true) {
            String feedbackField = 'feedback$index';
            String starRatingField = 'starRating$index';
            String timestampField = 'timestamp$index';
            String replyField = 'reply$index';

            // Break the loop if no more feedback fields are found
            if (feedbackData[feedbackField] == null) {
              break;
            }

            // Extract the feedback details
            String feedbackText = feedbackData[feedbackField] ?? 'No feedback';
            int starRating = feedbackData[starRatingField] ?? 0;
            Timestamp timestamp = feedbackData[timestampField] ?? Timestamp.now();
            String replyText = feedbackData[replyField] ?? 'No feedback';
            // Create a feedback item widget
            feedbackItems.add(
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedbackText,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Star Rating: $starRating'),
                    SizedBox(height: 4),
                    Text('Submitted on: ${timestamp.toDate()}'),
                    SizedBox(height: 4),
                    Text('Reply: $replyText'),
                  ],
                ),
              ),
            );

            // Increment index to check for the next feedback
            index++;
          }

          // If no feedback items are found, display a message
          if (feedbackItems.isEmpty) {
            return Center(child: Text('No feedback available.'));
          }

          // Display all feedback items in a ListView
          return ListView(
            children: feedbackItems,
          );
        },
      ),
    );
  }
}
