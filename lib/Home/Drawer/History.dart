import 'package:educast/Assessment/AssessmentHistory/AssessmentHistory4th.dart';
import 'package:educast/Assessment/AssessmentHistory/AssessmentHistoryG10.dart';
import 'package:educast/Home/Drawer/FeedbackHistory.dart';
import 'package:flutter/material.dart';

class HistoryPageG10 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Assessment List Tile
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Assessment'),
            onTap: () {
              // Navigate to Assessment Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssessmentHistoryG10()),
              );
            },
          ),
          Divider(),

          // Feedback List Tile
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Feedback'),
            onTap: () {
              // Navigate to Feedback Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackHistoryPage()),
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}


class HistoryPageG12 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Assessment List Tile
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Assessment'),
            onTap: () {
              // Navigate to Assessment Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssessmentHistoryG10()),
              );
            },
          ),
          Divider(),

          // Feedback List Tile
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Feedback'),
            onTap: () {
              // Navigate to Feedback Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackHistoryPage()),
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}

class HistoryPage4th extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Assessment List Tile
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Assessment'),
            onTap: () {
              // Navigate to Assessment Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssessmentHistory4th()),
              );
            },
          ),
          Divider(),

          // Feedback List Tile
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Feedback'),
            onTap: () {
              // Navigate to Feedback Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackHistoryPage()),
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
